import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:naya_menu/client_app/image/image_picker.dart';

import 'package:naya_menu/theme/app_theme.dart';

class ImageUploadCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Uint8List? imageData;
  final String? imageUrl;
  final String? errorMessage;
  final Function(Uint8List?) onImageSelected;
  final VoidCallback? onDeleteImage;

  const ImageUploadCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.imageData,
    this.imageUrl,
    this.errorMessage,
    required this.onImageSelected,
    this.onDeleteImage,
  });

  Future<void> _pickImage(BuildContext context) async {
    // Initialize ImagePickerWidget and pick image
    final imagePicker = ImagePickerWidget(onImageSelected: onImageSelected);
    await imagePicker.pickImage(context);
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (imageData != null) {
      imageWidget = Image.memory(imageData!, fit: BoxFit.cover);
    } else if (imageUrl != null) {
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
              onTap: () => _pickImage(context),
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
                    if ((imageData != null || imageUrl != null) &&
                        onDeleteImage != null)
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
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
