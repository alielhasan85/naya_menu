import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:html' as html; // For web platforms

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/client_app/image/image_cropper.dart';

import 'package:naya_menu/client_app/notifier.dart';

class ImagePickerWidget extends ConsumerWidget {
  final String imageKey;

  ImagePickerWidget({super.key, required this.imageKey});

  // Function to pick and check image size
  Future<void> pickImage(BuildContext context, WidgetRef ref) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      PlatformFile file = result.files.first;

      // Check if the file size is less than 15 MB
      if (file.size <= 15 * 1024 * 1024) {
        await _cropImage(file.bytes!, context, ref);
      } else {
        // Handle file size error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image size exceeds the 15 MB limit.')),
        );
      }
    } else {
      // Handle no image selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected.')),
      );
    }
  }

  Future<void> _cropImage(
      Uint8List imageData, BuildContext context, WidgetRef ref) async {
    html.Blob blob = html.Blob([imageData]);
    String url = html.Url.createObjectUrlFromBlob(blob);

    final venue = ref.read(venueProvider);
    final String userId = venue?.userId ?? '';
    final String venueId = venue?.venueId ?? '';

    await ImageCropper().cropImage(
      sourcePath: url,
      aspectRatio: imageKey == 'logoUrl'
          ? const CropAspectRatio(ratioX: 1, ratioY: 1)
          : const CropAspectRatio(ratioX: 4, ratioY: 3),
      compressQuality: 100,
      uiSettings: [
        WebUiSettings(
          context: context,
          presentStyle: WebPresentStyle.dialog,
          viewwMode: WebViewMode.mode_1,
          dragMode: WebDragMode.move,
          background: true,
          guides: true,
          customDialogBuilder: (cropper, initCropper, crop, rotate, scale) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: CropperDialog(
                cropper: cropper,
                initCropper: initCropper,
                crop: crop,
                rotate: rotate,
                imageUrl: url,
                aspectRatio: imageKey == 'logoUrl'
                    ? const CropAspectRatio(ratioX: 1, ratioY: 1)
                    : const CropAspectRatio(ratioX: 4, ratioY: 3),
                imageKey: imageKey,
                userId: userId,
                venueId: venueId,
              ),
            );
          },
        ),
      ],
    );

    html.Url.revokeObjectUrl(url); // Clean up URL
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Placeholder widget
    return const SizedBox.shrink();
  }
}
