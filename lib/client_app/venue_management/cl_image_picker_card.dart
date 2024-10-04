import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:naya_menu/client_app/image/image_picker.dart';

import 'package:naya_menu/theme/app_theme.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageUploadCard extends ConsumerWidget {
  final String title;
  final String subtitle;
  final String? imageUrl;
  final VoidCallback? onDeleteImage;
  final String imageKey;

  const ImageUploadCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    required this.imageKey,
    this.onDeleteImage,
  });

  Future<void> _pickImage(BuildContext context, WidgetRef ref) async {
    // Initialize ImagePickerWidget and pick image
    final imagePicker = ImagePickerWidget(imageKey: imageKey);
    await imagePicker.pickImage(context, ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget imageWidget;

    if (imageUrl != null) {
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    } else {
      imageWidget = Center(
        child: Text(
          'Tap to upload image',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      );
    }

    return Card(
      surfaceTintColor: AppTheme.grey,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    if (imageUrl != null && onDeleteImage != null)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: onDeleteImage,
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
