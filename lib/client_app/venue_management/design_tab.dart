//in this page we will upload the design paramter of the venue like logo (upload image and save url in firestore), text color, font style,
//it is part of

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/client_app/venue_management/cl_color.dart';
import 'package:naya_menu/client_app/venue_management/cl_image_picker_card.dart';
import 'package:naya_menu/service/firebase/firebase_storage_service.dart';
import 'package:naya_menu/client_app/notifier.dart';
import 'package:naya_menu/service/firebase/firestore_venue.dart';
import 'package:naya_menu/theme/app_theme.dart';

class DesignTab extends ConsumerWidget {
  const DesignTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access the venue provider
    final venue = ref.watch(venueProvider);
    final Map<String, dynamic> designAndDisplay = venue?.designAndDisplay ?? {};

    final String? logoUrl = designAndDisplay['logoUrl'];
    final String? backgroundUrl = designAndDisplay['backgroundUrl'];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customize your brand look',
              style: AppTheme.display1
                  .copyWith(fontSize: 24, color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your brand\'s colors to personalize your product. Choose text, background, and highlight colors to match your identity!',
              style: AppTheme.body2
                  .copyWith(fontSize: 12, color: AppTheme.lightText),
            ),
            const SizedBox(height: 16),
            const ColorPaletteWidget(), // Color palette widget
            const SizedBox(height: 40),
            // Logo Upload Section
            ImageUploadCard(
              title: 'Upload Venue Logo',
              subtitle: 'Image should be less than 15 MB',
              imageUrl: logoUrl,
              imageKey: 'logoUrl',
              onDeleteImage: () => _onImageDeleted(
                  context, ref, 'logoUrl'), // Pass the delete function
            ),
            const SizedBox(height: 40),
            // Background Image Upload Section
            ImageUploadCard(
              title: 'Upload Background Image',
              subtitle: 'Image should be less than 15 MB',
              imageUrl: backgroundUrl,
              imageKey: 'backgroundUrl',
              onDeleteImage: () => _onImageDeleted(
                  context, ref, 'backgroundUrl'), // Pass the delete function
            ),
          ],
        ),
      ),
    );
  }

  // Function to handle image deletion
  Future<void> _onImageDeleted(
      BuildContext context, WidgetRef ref, String imageKey) async {
    bool confirmDelete = await _showDeleteConfirmationDialog(context, imageKey);
    if (confirmDelete) {
      await _deleteImage(context, ref, imageKey);
    }
  }

  // Helper function to show a confirmation dialog
  Future<bool> _showDeleteConfirmationDialog(
      BuildContext context, String imageType) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Delete $imageType'),
            content: Text('Are you sure you want to delete the $imageType?'),
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

  // Function to delete image from Firebase and update provider
  Future<void> _deleteImage(
      BuildContext context, WidgetRef ref, String imageKey) async {
    try {
      // Show a loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final venue = ref.read(venueProvider);
      final userId = venue!.userId;
      final venueId = venue.venueId;
      Map<String, dynamic> designAndDisplay =
          Map.from(venue.designAndDisplay ?? {});

      if (designAndDisplay.containsKey(imageKey)) {
        // Delete the image from Firebase Storage
        await FirebaseStorageService().deleteImage(designAndDisplay[imageKey]);

        // Remove the image URL from the designAndDisplay map
        designAndDisplay.remove(imageKey);

        // Update Firestore: Use dot notation to delete the specific field
        await FirestoreVenue().deleteDesignAndDisplayField(
          userId,
          venueId,
          imageKey,
        );

        // Update the provider state
        final updatedVenue = venue.copyWith(designAndDisplay: designAndDisplay);
        ref.read(venueProvider.notifier).state = updatedVenue;

        // Show success feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  '${imageKey == 'logoUrl' ? 'Logo' : 'Background'} image deleted successfully!')),
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
}
