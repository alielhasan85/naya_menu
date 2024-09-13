import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:crop_your_image/crop_your_image.dart';

class ImageCropperScreen extends StatefulWidget {
  final Uint8List imageData;
  final Function(Uint8List croppedImage) onImageCropped;

  const ImageCropperScreen(
      {Key? key, required this.imageData, required this.onImageCropped})
      : super(key: key);

  @override
  _ImageCropperScreenState createState() => _ImageCropperScreenState();
}

class _ImageCropperScreenState extends State<ImageCropperScreen> {
  final CropController _cropController = CropController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop Image'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Crop(
              image: widget.imageData, // Pass the image data
              controller: _cropController,
              onCropped: (croppedImage) {
                widget.onImageCropped(
                    croppedImage); // Return cropped image to the parent widget
                Navigator.pop(context); // Go back after cropping
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                _cropController.crop(); // Trigger the cropping process
              },
              child: Text('Crop and Save'),
            ),
          ),
        ],
      ),
    );
  }
}
