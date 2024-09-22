//in this page we will upload the design paramter of the venue like logo (upload image and save url in firestore), text color, font style,
//it is part of

import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:naya_menu/client_app/image/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/client_app/venue_management/cl_color.dart';
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

  Color _backgroundColor = AppTheme.background;
  Color _highlightColor = AppTheme.accentColor;
  Color _textColor = AppTheme.primaryColor;

  String _colorToHex(Color color) =>
      '#${color.value.toRadixString(16).substring(2).toUpperCase()}';

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  final FirebaseStorageService _storageService = FirebaseStorageService();
  // @override
  // bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    // super.build(context);
    // Access the venue provider here using ref from ConsumerState
    final venue = ref.watch(venueProvider);
    final Map<String, dynamic> designAndDisplay = venue?.designAndDisplay ?? {};
// Retrieve colors from the designAndDisplay map and convert Hex to Color
    _backgroundColor = designAndDisplay.containsKey('backgroundColor')
        ? _hexToColor(designAndDisplay['backgroundColor'])
        : Colors.blue; // Default color
    _highlightColor = designAndDisplay.containsKey('highlightColor')
        ? _hexToColor(designAndDisplay['highlightColor'])
        : Colors.blue; // Default color
    _textColor = designAndDisplay.containsKey('textColor')
        ? _hexToColor(designAndDisplay['textColor'])
        : Colors.white; // Default color

    final String logoUrl = designAndDisplay['logoUrl'];

    final String backgroundUrl = designAndDisplay['backgroundUrl'];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Design and Display Settings',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ColorPaletteWidget(),

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
                        'Image shall be lessthan 15 MB',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          ImagePickerWidget(
                                  onImageSelected: _onLogoImageSelected)
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
                              : (logoUrl != null)
                                  ? CachedNetworkImage(
                                      imageUrl: logoUrl,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
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
                              : (backgroundUrl != null)
                                  ? Image.network(
                                      backgroundUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, url, error) =>
                                          const Text('not '),
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
      Map<String, dynamic> designAndDisplay = venue?.designAndDisplay ?? {};

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
        final FirestoreVenue firestoreVenue = FirestoreVenue();
        await firestoreVenue.updateDesignAndDisplay(
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
}
