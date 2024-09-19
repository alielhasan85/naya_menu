import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:html' as html; // For web platforms

class ImagePickerWidget extends StatelessWidget {
  final Function(Uint8List?) onImageSelected;

  const ImagePickerWidget({super.key, required this.onImageSelected});

  // Function to pick and check image size
  Future<void> pickImage(BuildContext context) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      PlatformFile file = result.files.first;

      // Check if the file size is less than 15 MB (15 * 1024 * 1024 bytes)
      if (file.size <= 15 * 1024 * 1024) {
        await _cropImage(file.bytes!, context);
      } else {
        onImageSelected(null); // Notify if image size exceeds the limit
      }
    } else {
      onImageSelected(null); // Notify if no image is selected
    }
  }

  Future<void> _cropImage(Uint8List imageData, BuildContext context) async {
    html.Blob blob = html.Blob([imageData]);
    String url = html.Url.createObjectUrlFromBlob(blob);

    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: url,

        //to be configured

        aspectRatio: CropAspectRatio(ratioX: 4, ratioY: 3),
        compressQuality: 100,
        uiSettings: [
          WebUiSettings(
            context: context, // Pass context here
            presentStyle: WebPresentStyle.dialog, // Open as a dialog
            viewwMode: WebViewMode.mode_1, // View mode for web
            dragMode: WebDragMode.move, // Default mode allows cropping
            background: true, // Show grid background
            guides: true, // Show guidelines
            customDialogBuilder: (cropper, initCropper, crop, rotate, scale) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      16), // Add rounded corners to the dialog
                ),
                child: CropperDialog(
                  cropper: cropper,
                  initCropper: initCropper,
                  crop: crop,
                  rotate: rotate,
                ),
              );
            },
          ),
        ]);

    if (croppedImage != null) {
      // Read and optimize the cropped image
      final Uint8List croppedImageData = await croppedImage.readAsBytes();
      final Uint8List optimizedImage = await optimizeImage(croppedImageData);

      // Pass the optimized image back
      onImageSelected(optimizedImage);
    } else {
      onImageSelected(null); // Notify if cropping was canceled
    }

    html.Url.revokeObjectUrl(url); // Clean up URL
  }

  Future<Uint8List> optimizeImage(Uint8List imageData) async {
    int originalSize = imageData.length;
    int quality = 97;
    int minWidth = 1920;
    int minHeight = 1080;

    if (originalSize > 10 * 1024 * 1024) {
      quality = 60;
      minWidth = 1920;
      minHeight = 1080;
    } else if (originalSize > 5 * 1024 * 1024) {
      quality = 70;
    }

    return await FlutterImageCompress.compressWithList(
      imageData,
      minHeight: minHeight,
      minWidth: minWidth,
      quality: quality,
      rotate: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Placeholder widget, as the logic is triggered externally
    return SizedBox.shrink();
  }
}

class CropperDialog extends StatefulWidget {
  final Widget cropper;
  final void Function() initCropper;
  final Future<String?> Function() crop;
  final void Function(RotationAngle angle) rotate;

  CropperDialog({
    required this.cropper,
    required this.initCropper,
    required this.crop,
    required this.rotate,
  });

  @override
  _CropperDialogState createState() => _CropperDialogState();
}

class _CropperDialogState extends State<CropperDialog> {
  @override
  void initState() {
    super.initState();
    widget.initCropper(); // Initialize the cropper as soon as the dialog opens
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //TODO: to study later
      width: 800, // Fixed width for the dialog
      height: 600, // Fixed height for the dialog
      padding: const EdgeInsets.all(16), // Add padding inside the dialog
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Crop Image',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Ensure the cropper is constrained and fits within the container
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.0, // Maintain a square aspect ratio (1:1)
              child: ClipRect(
                // Clip any overflow outside the container
                child: widget.cropper, // This is the cropper widget
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Rotate buttons (optional)
              IconButton(
                icon: const Icon(Icons.rotate_left),
                onPressed: () {
                  widget.rotate(
                      RotationAngle.clockwise270); // Rotate image to the left
                },
              ),
              IconButton(
                icon: const Icon(Icons.rotate_right),
                onPressed: () {
                  widget.rotate(
                      RotationAngle.clockwise90); // Rotate image to the right
                },
              ),
              TextButton(
                onPressed: () async {
                  // Trigger the cropping functionality and return the result
                  final result = await widget.crop();
                  Navigator.of(context).pop(result); // Return the result
                },
                child: const Text('Crop'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
