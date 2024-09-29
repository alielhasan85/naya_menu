//in this page we will upload the design paramter of the venue like logo (upload image and save url in firestore), text color, font style,
//it is part of

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/client_app/venue_management/cl_color.dart';
import 'package:naya_menu/client_app/venue_management/cl_image_picker_card.dart';
import 'package:naya_menu/service/firebase/firebase_storage_service.dart';
import 'package:naya_menu/client_app/notifier.dart';
import 'package:naya_menu/service/firebase/firestore_venue.dart';
import 'package:naya_menu/theme/app_theme.dart';

class DesignTab extends ConsumerStatefulWidget {
  const DesignTab({super.key});

  @override
  _DesignTabState createState() => _DesignTabState();
}

class _DesignTabState extends ConsumerState<DesignTab> {
  Uint8List? _selectedLogo;
  Uint8List? _selectedBackground;

  String? _logoErrorMessage;
  String? _backgroundErrorMessage;

  final Color _backgroundColor = AppTheme.background;
  final Color _highlightColor = AppTheme.accentColor;
  final Color _textColor = AppTheme.primaryColor;

  final FirebaseStorageService _storageService = FirebaseStorageService();
  final FirestoreVenue _firestoreVenue = FirestoreVenue();

  @override
  Widget build(BuildContext context) {
    // Access the venue provider here using ref from ConsumerState
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

            const ColorPaletteWidget(),
            const SizedBox(height: 40),

            // Logo Upload Section
            ImageUploadCard(
              title: 'Upload Venue Logo',
              subtitle: 'Image should be less than 15 MB',
              imageData: _selectedLogo,
              imageUrl: logoUrl,
              errorMessage: _logoErrorMessage,
              onImageSelected: _onLogoImageSelected,
              onDeleteImage: _onLogoImageDeleted, // Added this line
            ),

            const SizedBox(height: 40),

            // Background Image Upload Section
            ImageUploadCard(
              title: 'Upload Background Image',
              subtitle: 'Image should be less than 15 MB',
              imageData: _selectedBackground,
              imageUrl: backgroundUrl,
              errorMessage: _backgroundErrorMessage,
              onImageSelected: _onBackgroundImageSelected,
              onDeleteImage: _onBackgroundImageDeleted, // Added this line
            ),

            const SizedBox(height: 40),

            // Save Button to upload images and update Firestore
            ElevatedButton(
              onPressed: () =>
                  _saveDesignSettings(context, venue!.userId, venue.venueId),
              child: const Text('Save Design Settings'),
            ),
          ],
        ),
      ),
    );
  }

  // Callback function for logo image
  void _onLogoImageSelected(Uint8List? imageData) {
    setState(() {
      if (imageData != null) {
        _selectedLogo = imageData;
        _logoErrorMessage = null;
      } else {
        _logoErrorMessage =
            'Image selection failed or file size exceeds 15 MB.';
        _selectedLogo = null;
      }
    });
  }

  // Callback function for background image
  void _onBackgroundImageSelected(Uint8List? imageData) {
    setState(() {
      if (imageData != null) {
        _selectedBackground = imageData;
        _backgroundErrorMessage = null;
      } else {
        _backgroundErrorMessage =
            'Image selection failed or file size exceeds 15 MB.';
        _selectedBackground = null;
      }
    });
  }

  Future<void> _onLogoImageDeleted() async {
    bool confirmDelete = await _showDeleteConfirmationDialog('logo image');
    if (confirmDelete) {
      await _deleteImage('logoUrl');
    }
  }

  // Function to handle background image deletion
  Future<void> _onBackgroundImageDeleted() async {
    bool confirmDelete =
        await _showDeleteConfirmationDialog('background image');
    if (confirmDelete) {
      await _deleteImage('backgroundUrl');
    }
  }

  // Helper function to show a confirmation dialog
  Future<bool> _showDeleteConfirmationDialog(String imageType) async {
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

  Future<void> _deleteImage(String imageKey) async {
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
        await _storageService.deleteImage(designAndDisplay[imageKey]);

        // Remove the image URL from the designAndDisplay map
        designAndDisplay.remove(imageKey);

        // Update Firestore: Use dot notation to delete the specific field
        await _firestoreVenue.deleteDesignAndDisplayField(
          userId,
          venueId,
          imageKey,
        );

        // Update the provider state
        final updatedVenue = venue.copyWith(designAndDisplay: designAndDisplay);
        ref.read(venueProvider.notifier).state = updatedVenue;

        // Clear the local image data
        setState(() {
          if (imageKey == 'logoUrl') {
            _selectedLogo = null;
            _logoErrorMessage = null;
          } else if (imageKey == 'backgroundUrl') {
            _selectedBackground = null;
            _backgroundErrorMessage = null;
          }
        });

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

  // Function to handle image upload, Firestore update, and provider update
  Future<void> _saveDesignSettings(
      BuildContext context, String userId, String venueId) async {
    try {
      // Show a loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Access the venue provider directly
      final venue = ref.read(venueProvider);
      Map<String, dynamic> designAndDisplay =
          Map.from(venue?.designAndDisplay ?? {});

      // Save the selected colors to the designAndDisplay map
      designAndDisplay['backgroundColor'] = _colorToHex(_backgroundColor);
      designAndDisplay['highlightColor'] = _colorToHex(_highlightColor);
      designAndDisplay['textColor'] = _colorToHex(_textColor);

      // Upload logo if selected and update the designAndDisplay map
      if (_selectedLogo != null) {
        if (designAndDisplay.containsKey('logoUrl')) {
          // Delete the existing logo before uploading a new one
          await _storageService.deleteImage(designAndDisplay['logoUrl']);
        }

        // Upload the new logo
        String? logoUrl = await _storageService.uploadImage(
          imageData: _selectedLogo!,
          userId: userId,
          venueId: venueId,
          imageType: 'logo',
        );
        if (logoUrl != null) {
          designAndDisplay['logoUrl'] = logoUrl;
        }
      }

      // Upload background if selected and update the designAndDisplay map
      if (_selectedBackground != null) {
        if (designAndDisplay.containsKey('backgroundUrl')) {
          // Delete the existing background before uploading a new one
          await _storageService.deleteImage(designAndDisplay['backgroundUrl']);
        }

        // Upload the new background
        String? backgroundUrl = await _storageService.uploadImage(
          imageData: _selectedBackground!,
          userId: userId,
          venueId: venueId,
          imageType: 'background',
        );
        if (backgroundUrl != null) {
          designAndDisplay['backgroundUrl'] = backgroundUrl;
        }
      }

      // If any changes were made, update Firestore and the provider
      if (designAndDisplay.isNotEmpty) {
        // Update Firestore using FirestoreVenue
        await _firestoreVenue.updateDesignAndDisplay(
            userId, venueId, designAndDisplay);

        // Update the provider directly with new values
        final updatedVenue =
            venue!.copyWith(designAndDisplay: designAndDisplay);
        ref.read(venueProvider.notifier).state = updatedVenue;

        // Clear the selected images
        setState(() {
          _selectedLogo = null;
          _selectedBackground = null;
        });

        // Show success feedback
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Design settings saved successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No design changes were made.')),
        );
      }
    } catch (e) {
      // Show error feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving design settings: $e')),
      );
    } finally {
      // Remove the loading indicator
      Navigator.of(context).pop();
    }
  }

  // Utility method to convert a Color to a hex string
  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  // Utility method to convert a hex string to a Color object
  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
