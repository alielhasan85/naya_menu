import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:naya_menu/client_app/venue_management/cl_currency_control.dart';
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
  late TextEditingController _phoneNumberController;

  late TextEditingController _countryCodeController; // For country code 'us'
  late TextEditingController _countryNameController; // For country name
  late TextEditingController _countryDialController; // '+1'

  late TextEditingController _websiteController; //

  String countryValue = '';
  String stateValue = '';
  String cityValue = '';
  bool _isLoading = true; // Track whether data is still being loaded

  late String _selectedCurrency;

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

      _phoneNumberController =
          TextEditingController(text: venue.contact['phoneNumber'] ?? '');
      _countryCodeController = TextEditingController(
          text: venue.contact['countryCode'] ?? ''); // Initialize country code
      _countryNameController = TextEditingController(
          text: venue.address['country'] ?? ''); // Initialize country name

      _countryDialController =
          TextEditingController(text: venue.contact['countryDial'] ?? '');

      _websiteController =
          TextEditingController(text: venue.contact['website'] ?? '');

      _selectedCurrency = venue.priceOptions['currency'] ?? 'USD';

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
      _phoneNumberController = TextEditingController();
      _countryCodeController = TextEditingController();
      _countryNameController = TextEditingController();
      _countryDialController = TextEditingController();
      _websiteController = TextEditingController();
      _selectedCurrency = 'USD';

      setState(() {
        _isLoading = false; // Mark data as loaded even if empty
      });
    }
  }

  @override
  void dispose() {
    _venueNameController.dispose();
    _countryDialController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    _countryCodeController.dispose(); // Dispose country code controller
    _countryNameController.dispose(); // Dispose country name controller
    _websiteController.dispose();

    super.dispose();
  }

  Future<void> _saveVenueData() async {
    setState(() {
      _isLoading = true; // Show loading indicator while saving
    });

    final venue = ref.read(venueProvider);

    if (venue != null) {
      // Update the venue's name, address, and contact (including phone number) in the provider
      final updatedVenue = venue.copyWith(
        venueName: _venueNameController.text,
        address: {
          'country': countryValue,
          'state': stateValue,
          'city': cityValue,
          'address': _addressController.text,
        },
        contact: {
          'countryCode': _countryCodeController.text,
          'countryDial': _countryDialController.text,
          'email': venue.contact['email'], // Keep the existing email
          'phoneNumber': _phoneNumberController.text, // Update the phone number
          if (_websiteController.text.isNotEmpty)
            'website': _websiteController.text
        },
        priceOptions: {
          ...venue.priceOptions,
          'currency': venue.priceOptions['currency'],
          'currencySymbol': venue.priceOptions['currencySymbol'],
          'priceDisplay': venue.priceOptions['priceDisplay'],
          'displayCurrencySign': venue.priceOptions['displayCurrencySign'],
          'displayCurrencyFraction':
              venue.priceOptions['displayCurrencyFraction'],
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
          'contact': {
            'email': venue.contact['email'], // Keep the existing email
            'countryCode': _countryCodeController.text,
            'countryDial': _countryDialController.text,
            'phoneNumber': _phoneNumberController.text,
            if (_websiteController.text.isNotEmpty)
              'website': _websiteController.text // Save updated phone number
          },
          'priceOptions': {
            'currency': venue.priceOptions['currency'],
            'currencySymbol': venue.priceOptions['currencySymbol'],
            'priceDisplay': venue.priceOptions['priceDisplay'],
            'displayCurrencySign': venue.priceOptions['displayCurrencySign'],
            'displayCurrencyFraction':
                venue.priceOptions['displayCurrencyFraction'],
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
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Venue Name Field
                  Text(
                    'Venu Name',
                    textAlign: TextAlign.left,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium, // Use theme text style
                  ),
                  const SizedBox(height: 10),
                  InputField(
                    controller: _venueNameController,
                    labelAboveField: true,
                  ),
                  const SizedBox(height: 20),
// TODO: change the ui of the phone picker especially the drop down menu to be same as other input field

// Phone Number Input Field using intl_phone_field

                  Text(
                    'Phone Number',
                    textAlign: TextAlign.left,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium, // Use theme text style
                  ),

                  const SizedBox(height: 10),

                  IntlPhoneField(
                    decoration: InputDecoration(
                      border: AppTheme.inputDecorationTheme.border,
                    ),
                    dropdownDecoration: BoxDecoration(),
                    initialCountryCode: _countryCodeController.text.isNotEmpty
                        ? _countryCodeController
                            .text // This should be the country ISO code like 'US'
                        : 'US', // Default country if no data is available
                    initialValue: _phoneNumberController
                        .text, // Pre-fill phone number if available
                    onChanged: (phone) {
                      // Store phone number without dial code
                      _phoneNumberController.text = phone.number;

                      // Store country information in controllers
                      // Save dial code like '+1'
                    },
                    onCountryChanged: (country) {
                      _countryNameController.text = country.name;
                      _countryCodeController.text = country.code;
                      _countryDialController.text = country.dialCode;

                      // Save country name like 'United States'
                      // Save country name like 'United States'
                    },
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    color: AppTheme.accentColor,
                    thickness: 0.5,
                  ),
                  const SizedBox(height: 10),

                  CurrencyControl(),

                  const SizedBox(height: 10),
                  const Divider(
                    color: AppTheme.accentColor,
                    thickness: 0,
                  ),

                  const SizedBox(height: 10),
// TODO: change the ui of the address icker to be same as other input field
// TODO: to add feature to add location from map

                  // Country, State, and City Picker using csc_picker

                  Text(
                    'Address',
                    textAlign: TextAlign.left,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium, // Use theme text style
                  ),

                  const SizedBox(height: 10),

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

                  // Address Field
                  InputField(
                    label: 'Full Address',
                    controller: _addressController,
                    labelAboveField: true,
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    color: AppTheme.accentColor,
                    thickness: 0,
                  ),

                  const SizedBox(height: 10),
                  InputField(
                    label: 'Website',
                    controller: _websiteController,
                    labelAboveField: true,
                  ),
                  const SizedBox(height: 10),

                  const Divider(
                    color: AppTheme.accentColor,
                    thickness: 0,
                  ),

                  const SizedBox(height: 10),
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
