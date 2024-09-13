import 'dart:html' as html; // Needed for web-specific file handling
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;

class ImagePickerWdget extends StatefulWidget {
  final Function(File? image, Uint8List? webImage)?
      onImagePicked; // Callback to return the cropped image
  final Widget Function(BuildContext context, VoidCallback onPickImage)?
      triggerBuilder; // Custom UI for triggering image picking
  final double aspectRatioX; // Aspect ratio width
  final double aspectRatioY; // Aspect ratio height
  final bool lockAspectRatio; // Whether to lock the aspect ratio
  final int targetSizeKB; // Desired target size in KB

  const ImagePickerWdget({
    Key? key,
    this.onImagePicked,
    this.triggerBuilder,
    this.aspectRatioX = 1,
    this.aspectRatioY = 1,
    this.lockAspectRatio = false,
    this.targetSizeKB = 500, // Default target size is 500 KB
  }) : super(key: key);

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWdget> {
  Uint8List? _webImage; // For web platforms
  int compressQuality = 90; // Default compression quality

  // Function to pick and crop an image
  Future<void> _pickAndCropImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      CroppedFile? croppedImage;

      if (kIsWeb) {
        // Web cropping
        croppedImage = await ImageCropper().cropImage(
          sourcePath: image.path,
          uiSettings: [
            WebUiSettings(
              context: context,
              presentStyle:
                  WebPresentStyle.dialog, // Opens the cropper in a dialog
              initialAspectRatio: widget.aspectRatioX /
                  widget.aspectRatioY, // Set initial aspect ratio
              cropBoxResizable:
                  !widget.lockAspectRatio, // Lock or unlock aspect ratio
              cropBoxMovable: true,
            ),
          ],
        );

        if (croppedImage != null) {
          // Read the cropped image as bytes
          _webImage = await _readFileAsBytes(croppedImage.path);

          // Analyze and potentially compress the image if too large
          _webImage = await _analyzeAndCompress(_webImage!);
        }
      }

      // Notify parent widget with the final image
      if (widget.onImagePicked != null) {
        widget.onImagePicked!(null, _webImage); // For web
      }
    }
  }

  // Function to read the file as bytes (needed for web)
  Future<Uint8List> _readFileAsBytes(String path) async {
    final blob = html.Blob([
      await html.HttpRequest.request(path, responseType: "blob")
          .then((r) => r.response)
    ]);
    final reader = html.FileReader();
    reader.readAsArrayBuffer(blob);
    await reader.onLoadEnd.first;
    return reader.result as Uint8List;
  }

  // Function to compress image based on target size
  Future<Uint8List> _analyzeAndCompress(Uint8List originalImage) async {
    int imageSizeKB = originalImage.lengthInBytes ~/ 1024;

    // While the image size is larger than the target size, reduce the compression quality
    while (imageSizeKB > widget.targetSizeKB && compressQuality > 10) {
      compressQuality -= 10;

      // Compress the image further
      final compressedImage = await ImageCropper().cropImage(
        sourcePath: "", // We don't have a file path in web
        compressQuality: compressQuality,
        uiSettings: [
          WebUiSettings(
            context: context,
            presentStyle: WebPresentStyle.dialog,
          ),
        ],
      );

      if (compressedImage != null) {
        originalImage = await _readFileAsBytes(compressedImage.path);
        imageSizeKB = originalImage.lengthInBytes ~/ 1024;
      }
    }

    return originalImage; // Return the optimized image
  }

  @override
  Widget build(BuildContext context) {
    return widget.triggerBuilder != null
        ? widget.triggerBuilder!(context, _pickAndCropImage)
        : Container(); // You can use default UI here if desired
  }
}
