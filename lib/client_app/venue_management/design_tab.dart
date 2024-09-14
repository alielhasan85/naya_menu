import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:naya_menu/client_app/image/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/service/firebase/firebase_storage_service.dart';
import 'package:naya_menu/client_app/notifier.dart';
import 'package:naya_menu/service/firebase/firestore_venue.dart';
import 'package:naya_menu/models/venue/venue.dart';

class DesignTab extends ConsumerStatefulWidget {
  const DesignTab({super.key});

  @override
  _DesignTabState createState() => _DesignTabState();
}

class _DesignTabState extends ConsumerState<DesignTab>
    with AutomaticKeepAliveClientMixin {
  Uint8List? _selectedLogo;
  Uint8List? _selectedBackground;
  String? _logoErrorMessage;
  String? _backgroundErrorMessage;

  final FirebaseStorageService _storageService = FirebaseStorageService();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required when using AutomaticKeepAliveClientMixin

    // Access the venue provider here using ref from ConsumerState
    final venue = ref.watch(venueProvider);

    // Extract designAndDisplay and image URLs
    final Map<String, dynamic> designAndDisplay = venue?.designAndDisplay ?? {};
    final String? logoUrl = designAndDisplay['logoUrl'] as String?;
    final String? backgroundUrl = designAndDisplay['backgroundUrl'] as String?;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Design and Display Settings',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Row for uploading the logo
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Upload Venue Logo',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Image shall be less than 15 MB',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        ImagePickerWidget(onImageSelected: _onLogoImageSelected)
                            .pickImage(context);
                      },
                      child: Container(
                        width: 150,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _selectedLogo != null
                            ? Image.memory(_selectedLogo!, fit: BoxFit.cover)
                            : logoUrl != null
                                ? Image.network(
                                    logoUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Text(
                                          'Failed to load image',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600]),
                                        ),
                                      );
                                    },
                                  )
                                : Center(
                                    child: Text(
                                      'Upload Logo',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600]),
                                    ),
                                  ),
                      ),
                    ),
                    if (_logoErrorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          _logoErrorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Row for uploading the background image
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Upload Background Image',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Image shall be less than 15 MB',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        ImagePickerWidget(
                                onImageSelected: _onBackgroundImageSelected)
                            .pickImage(context);
                      },
                      child: Container(
                        width: 150,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _selectedBackground != null
                            ? Image.memory(_selectedBackground!,
                                fit: BoxFit.cover)
                            : backgroundUrl != null
                                ? Image.network(
                                    backgroundUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Text(
                                          'Failed to load image',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600]),
                                        ),
                                      );
                                    },
                                  )
                                : Center(
                                    child: Text(
                                      'Upload Background',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600]),
                                    ),
                                  ),
                      ),
                    ),
                    if (_backgroundErrorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          _backgroundErrorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Save Button to upload images and update Firestore
          ElevatedButton(
            onPressed: venue != null
                ? () =>
                    _saveDesignSettings(context, venue.userId, venue.venueId)
                : null,
            child: const Text('Save Design Settings'),
          ),
        ],
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

      // Initialize Firestore service
      final FirestoreVenue firestoreVenue = FirestoreVenue();

      // Get the current venue details from Firestore (to check if URLs already exist)
      VenueModel? currentVenue =
          await firestoreVenue.getVenueById(userId, venueId);
      Map<String, dynamic> designAndDisplay =
          currentVenue?.designAndDisplay ?? {};

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
        await firestoreVenue.updateDesignAndDisplay(
            userId, venueId, designAndDisplay);

        // Update the provider
        final updatedVenue = ref.read(venueProvider.notifier).state!.copyWith(
              designAndDisplay: designAndDisplay,
            );
        ref.read(venueProvider.notifier).state = updatedVenue;

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
}
