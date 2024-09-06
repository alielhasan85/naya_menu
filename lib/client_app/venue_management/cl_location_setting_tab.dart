import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/service/firebase/firestore_venue.dart';
import 'package:naya_menu/theme/app_theme.dart';
import '../widgets/input_fields.dart';
import 'package:naya_menu/client_app/notifier.dart';

class LocationSettingsTab extends ConsumerStatefulWidget {
  const LocationSettingsTab({super.key});

  @override
  _LocationSettingsTabState createState() => _LocationSettingsTabState();
}

class _LocationSettingsTabState extends ConsumerState<LocationSettingsTab> {
  late TextEditingController _venueNameController;
  late TextEditingController _addressController;
  String countryValue = '';
  String stateValue = '';
  String cityValue = '';
  bool _isLoading = true; // Track whether data is still being loaded

  @override
  void initState() {
    super.initState();
    _initializeVenueData();
  }

  // Initialize data from venueProvider, not Firestore
  void _initializeVenueData() {
    final venue = ref.read(venueProvider);

    if (venue != null) {
      // Initialize the controllers with the current venue data from the provider
      _venueNameController = TextEditingController(text: venue.venueName);
      _addressController =
          TextEditingController(text: venue.address['address'] ?? '');

      // Set initial values for country, state, and city from the venue data
      setState(() {
        countryValue = venue.address['country'] ?? '';
        stateValue = venue.address['state'] ?? '';
        cityValue = venue.address['city'] ?? '';
        _isLoading = false; // Mark data as loaded
      });
    } else {
      // If no venue data is available, initialize with empty fields
      _venueNameController = TextEditingController();
      _addressController = TextEditingController();
      setState(() {
        _isLoading = false; // Mark data as loaded even if empty
      });
    }
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is destroyed
    _venueNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _saveVenueData() async {
    setState(() {
      _isLoading = true; // Show loading indicator while saving
    });

    final venue = ref.read(venueProvider);

    if (venue != null) {
      // Update the venue's name and address in the provider
      final updatedVenue = venue.copyWith(
        venueName: _venueNameController.text,
        address: {
          'country': countryValue,
          'state': stateValue,
          'city': cityValue,
          'address': _addressController.text,
        },
      );
      ref.read(venueProvider.notifier).setVenue(updatedVenue);

      // Update the venue's information in Firestore
      await FirestoreVenue().updateVenue(
        updatedVenue.userId,
        updatedVenue.venueId,
        {
          'venueName': _venueNameController.text,
          'address': {
            'country': countryValue,
            'state': stateValue,
            'city': cityValue,
            'address': _addressController.text,
          },
        },
      );

      setState(() {
        _isLoading = false; // Hide loading indicator
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Venue information saved successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child:
                CircularProgressIndicator()) // Show loading indicator while fetching data
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Venue Name Field
                  InputField(
                    label: 'Venue Name',
                    controller: _venueNameController,
                    labelAboveField: true,
                  ),
                  const SizedBox(height: 20),

                  // Address Field
                  InputField(
                    label: 'Full Address',
                    controller: _addressController,
                    labelAboveField: true,
                  ),
                  const SizedBox(height: 20),

                  // Country, State, and City Picker using csc_picker
                  CSCPicker(
                    showStates: true,
                    showCities: true,
                    flagState: CountryFlag.DISABLE,
                    dropdownDecoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    selectedItemStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    countryDropdownLabel: "*Country",
                    stateDropdownLabel: "*State",
                    cityDropdownLabel: "*City",
                    onCountryChanged: (value) {
                      setState(() {
                        countryValue = value;
                      });
                    },
                    onStateChanged: (value) {
                      setState(() {
                        stateValue = value ?? '';
                      });
                    },
                    onCityChanged: (value) {
                      setState(() {
                        cityValue = value ?? '';
                      });
                    },
                    currentCountry: countryValue,
                    currentState: stateValue,
                    currentCity: cityValue,
                  ),
                  const SizedBox(height: 20),

                  // Save Button
                  ElevatedButton(
                    onPressed: _saveVenueData, // Call the save method
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          );
  }
}
