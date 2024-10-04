import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:html' as html; // For web platforms

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:naya_menu/service/firebase/firebase_storage_service.dart';
import 'package:naya_menu/client_app/notifier.dart';
import 'package:naya_menu/service/firebase/firestore_venue.dart';

class CropperDialog extends ConsumerStatefulWidget {
  final Widget cropper;
  final void Function() initCropper;
  final Future<String?> Function() crop;
  final void Function(RotationAngle angle) rotate;

  final String imageUrl; // The URL of the image to be cropped
  final CropAspectRatio aspectRatio; // Aspect ratio for cropping
  final String imageKey; // 'logoUrl' or 'backgroundUrl'
  final String userId;
  final String venueId;

  const CropperDialog({
    required this.cropper,
    required this.initCropper,
    required this.crop,
    required this.rotate,
    Key? key,
    required this.imageUrl,
    required this.aspectRatio,
    required this.imageKey,
    required this.userId,
    required this.venueId,
  }) : super(key: key);

  @override
  _CropperDialogState createState() => _CropperDialogState();
}

class _CropperDialogState extends ConsumerState<CropperDialog> {
  Uint8List? _croppedImageData;
  bool _isUploading = false; // To show a loading indicator

  final FirebaseStorageService _storageService = FirebaseStorageService();
  final FirestoreVenue _firestoreVenue = FirestoreVenue();

  @override
  void initState() {
    super.initState();
    widget.initCropper();
  }

  // Function to upload the cropped image and update Firestore
  Future<void> _uploadCroppedImage(BuildContext context) async {
    // Get the cropped image data
    String? croppedFilePath = await widget.crop();
    if (croppedFilePath == null) return;

    // Read and optimize the cropped image
    final croppedImageData = await _readImageData(croppedFilePath);
    final optimizedImage = await _optimizeImage(croppedImageData);

    try {
      setState(() {
        _isUploading = true; // Show loading indicator
      });

      final venue = ref.read(venueProvider); // Access the venue provider
      Map<String, dynamic> designAndDisplay =
          Map.from(venue?.designAndDisplay ?? {});

      // Delete the old image if it exists
      if (designAndDisplay.containsKey(widget.imageKey)) {
        await _storageService.deleteImage(designAndDisplay[widget.imageKey]);
      }

      // Upload the new cropped image to Firebase Storage
      String? imageUrl = await _storageService.uploadImage(
        imageData: optimizedImage,
        userId: widget.userId,
        venueId: widget.venueId,
        imageType: widget.imageKey == 'logoUrl'
            ? 'logo'
            : 'background', // Determine image type
      );

      if (imageUrl != null) {
        // Update Firestore with the new image URL
        designAndDisplay[widget.imageKey] = imageUrl;

        await _firestoreVenue.updateDesignAndDisplay(
            widget.userId, widget.venueId, designAndDisplay);

        // Update the provider with the new image URL
        final updatedVenue =
            venue?.copyWith(designAndDisplay: designAndDisplay);
        ref.read(venueProvider.notifier).state = updatedVenue;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  '${widget.imageKey == 'logoUrl' ? 'Logo' : 'Background'} uploaded successfully!')),
        );
      }
    } catch (e) {
      // Show error feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false; // Hide loading indicator
      });
      Navigator.of(context).pop(); // Close the dialog after upload
    }
  }

  // Function to read image data from file path
  Future<Uint8List> _readImageData(String filePath) async {
    final croppedFile = CroppedFile(filePath);
    return await croppedFile.readAsBytes();
  }

  // Function to optimize the image
  Future<Uint8List> _optimizeImage(Uint8List imageData) async {
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
    return Container(
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
          const SizedBox(height: 16),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.0, // Maintain a square aspect ratio
              child: ClipRect(
                // Clip any overflow outside the container
                child: widget.cropper, // The cropper widget
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!_isUploading) ...[
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
                ElevatedButton(
                  onPressed: () async {
                    await _uploadCroppedImage(context);
                  },
                  child: const Text('Save'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: const Text('Cancel'),
                ),
              ] else
                const CircularProgressIndicator(), // Show loading indicator
            ],
          ),
        ],
      ),
    );
  }
}
