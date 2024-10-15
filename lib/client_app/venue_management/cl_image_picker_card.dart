import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:naya_menu/client_app/image/image_picker.dart';

import 'package:naya_menu/theme/app_theme.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:naya_menu/service/firebase/firebase_storage_service.dart';
import 'package:naya_menu/client_app/notifier.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageUploadCard extends ConsumerWidget {
  final String title;
  final String subtitle;
  final String? imageUrl;
  final String imageKey; // The field key in Firestore
  final CropAspectRatio aspectRatio;
  final String? imageName;
  final Map<String, dynamic> extraData; // Additional data if needed

  const ImageUploadCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    required this.imageKey,
    required this.aspectRatio,
    this.imageName,
    this.extraData = const {},
  });

  Future<void> _pickImage(BuildContext context, WidgetRef ref) async {
    final imagePicker = ImagePickerWidget(
      imageKey: imageKey,
      aspectRatio: aspectRatio,
      imageName: imageName,
      extraData: extraData,
    );
    await imagePicker.pickImage(context, ref);
  }

  Future<void> _onDeleteImage(BuildContext context, WidgetRef ref) async {
    bool confirmDelete = await _showDeleteConfirmationDialog(context);
    if (confirmDelete) {
      await _deleteImage(context, ref);
    }
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Image'),
            content: const Text('Are you sure you want to delete this image?'),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), // Return false
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true), // Return true
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _deleteImage(BuildContext context, WidgetRef ref) async {
    try {
      // Show a loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final userId = ref.read(userProvider)?.userId ?? '';
      final venue = ref.read(venueProvider);
      final venueId = venue?.venueId ?? '';

      String? imageUrlToDelete = imageUrl;

      if (imageUrlToDelete != null) {
        // Delete the image from Firebase Storage
        await FirebaseStorageService().deleteImage(imageUrlToDelete);

        // Update Firestore
        await _updateFirestoreAfterDeletion(userId, venueId);

        // Show success feedback
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image deleted successfully!')),
        );
      }
    } catch (e) {
      // Show error feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting image: $e')),
      );
    } finally {
      // Remove the loading indicator
      Navigator.of(context).pop();
    }
  }

  Future<void> _updateFirestoreAfterDeletion(
      String userId, String venueId) async {
    String? collectionName = extraData['collectionName'];
    String? documentId = extraData['documentId'];
    String fieldKey = imageKey;

    if (collectionName != null && documentId != null) {
      // Deleting image field from a specific collection (e.g., meals)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('venues')
          .doc(venueId)
          .collection(collectionName)
          .doc(documentId)
          .update({fieldKey: FieldValue.delete()});
    } else {
      // Default behavior: delete field from venue's designAndDisplay
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('venues')
          .doc(venueId)
          .update({'designAndDisplay.$fieldKey': FieldValue.delete()});
    }
  }

  void _updateProviderState(WidgetRef ref) {
    // Update the provider state if necessary
    final venue = ref.read(venueProvider);
    if (venue != null) {
      Map<String, dynamic> designAndDisplay =
          Map.from(venue.designAndDisplay ?? {});
      designAndDisplay.remove(imageKey);

      final updatedVenue = venue.copyWith(designAndDisplay: designAndDisplay);
      ref.read(venueProvider.notifier).state = updatedVenue;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget imageWidget = imageUrl != null
        ? CachedNetworkImage(
            imageUrl: imageUrl!,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          )
        : Center(
            child: Text(
              'Tap to upload image',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          );

    return Card(
      surfaceTintColor: AppTheme.grey,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text(subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 10),
            InkWell(
              onTap: () => _pickImage(context, ref),
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: imageWidget,
                      ),
                    ),
                    if (imageUrl != null)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => _onDeleteImage(context, ref),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
