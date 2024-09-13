// design_tab.dart

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:naya_menu/client_app/image/image_picker.dart';

class DesignTab extends StatefulWidget {
  const DesignTab({Key? key}) : super(key: key);

  @override
  _DesignTabState createState() => _DesignTabState();
}

class _DesignTabState extends State<DesignTab> {
  Uint8List? _selectedImage;

  // Callback function to receive the selected image data from ImagePickerWidget
  void _onImageSelected(Uint8List? imageData) {
    setState(() {
      _selectedImage = imageData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upload Venue Logo',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Text(
                'Image shall be less than 15 MB',
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Use the ImagePickerWidget and pass the callback
          ImagePickerWidget(onImageSelected: _onImageSelected),

          // Optionally do something with the selected image (_selectedImage)
          if (_selectedImage != null)
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text('Image selected successfully!',
                  style: TextStyle(color: Colors.green)),
            ),
        ],
      ),
    );
  }
}
