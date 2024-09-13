// image_picker_widget.dart
import 'dart:typed_data';
import 'dart:html' as html; // For web platforms
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(Uint8List?) onImageSelected;

  const ImagePickerWidget({Key? key, required this.onImageSelected})
      : super(key: key);

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  Uint8List? _imageData;
  String? _errorMessage;

  // Function to pick and check image size
  Future<void> pickImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      PlatformFile file = result.files.first;

      // Check if the file size is less than 15 MB (15 * 1024 * 1024 bytes)
      if (file.size <= 15 * 1024 * 1024) {
        setState(() {
          _imageData = file.bytes;
          _errorMessage = null;
        });

        // Open cropping dialog
        await _cropImage(file.bytes!);
      } else {
        setState(() {
          _errorMessage =
              'File size exceeds 15 MB. Please select a smaller file.';
          _imageData = null;
        });
        widget.onImageSelected(null);
      }
    } else {
      setState(() {
        _errorMessage = 'No image selected.';
        _imageData = null;
      });
      widget.onImageSelected(null);
    }
  }

  // Future<void> _cropImage(Uint8List imageData) async {
  //   // For web, you need to handle the image source differently
  //   html.Blob blob = html.Blob([imageData]);
  //   String url = html.Url.createObjectUrlFromBlob(blob);

  //   CroppedFile? croppedImage = await ImageCropper().cropImage(
  //     sourcePath: url, // Web-specific handling
  //     aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
  //     uiSettings: [
  //       WebUiSettings(
  //         context: context,
  //         presentStyle: WebPresentStyle.dialog, // Open as a dialog
  //         viewwMode: WebViewMode.mode_0, // View mode for web
  //         dragMode: WebDragMode.move, // Default mode
  //         initialAspectRatio: 1.0, // Square aspect ratio initially
  //         background: true, // Show the grid background
  //         guides: true, // Show guidelines
  //       ),
  //     ],
  //   );

  //   if (croppedImage != null) {
  //     // Read the cropped image as Uint8List
  //     final Uint8List croppedImageData = await croppedImage.readAsBytes();
  //     setState(() {
  //       _imageData = croppedImageData;
  //     });
  //     widget.onImageSelected(_imageData);
  //   }

  //   // Revoke the blob URL after use to free up memory
  //   html.Url.revokeObjectUrl(url);
  // }

  Future<void> _cropImage(Uint8List imageData) async {
    // For web, you need to handle the image source differently
    html.Blob blob = html.Blob([imageData]);
    String url = html.Url.createObjectUrlFromBlob(blob);

    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: url, // Web-specific handling
      aspectRatio: CropAspectRatio(ratioX: 4, ratioY: 3),
      uiSettings: [
        WebUiSettings(
          context: context,
          presentStyle: WebPresentStyle.dialog, // Open as a dialog
          viewwMode: WebViewMode.mode_1, // View mode for web
          dragMode: WebDragMode.move, // Default mode allows cropping
          //initialAspectRatio: 1.0, // Square aspect ratio initially
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
      ],
    );

    if (croppedImage != null) {
      // Read the cropped image as Uint8List
      final Uint8List croppedImageData = await croppedImage.readAsBytes();
      setState(() {
        _imageData = croppedImageData;
      });
      widget.onImageSelected(_imageData);
    }

    // Revoke the blob URL after use to free up memory
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: pickImage,
          child: Container(
            width: 400,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: _imageData != null
                ? Padding(
                    padding: const EdgeInsets.all(4),
                    child: Image.memory(_imageData!, fit: BoxFit.fitHeight))
                : Center(
                    child: Text('Upload Logo',
                        style:
                            TextStyle(fontSize: 16, color: Colors.grey[600]))),
          ),
        ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
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
      width: 600, // Fixed width for the dialog
      height: 400, // Fixed height for the dialog
      padding: EdgeInsets.all(16), // Add padding inside the dialog
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
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
                icon: Icon(Icons.rotate_left),
                onPressed: () {
                  widget.rotate(
                      RotationAngle.clockwise270); // Rotate image to the left
                },
              ),
              IconButton(
                icon: Icon(Icons.rotate_right),
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
                child: Text('Crop'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
