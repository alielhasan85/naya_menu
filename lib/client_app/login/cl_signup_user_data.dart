import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/client_app/notifier.dart';
import 'package:naya_menu/client_app/widgets/input_fields.dart';
import 'package:naya_menu/client_app/login/cl_signup_phone.dart';
import 'package:naya_menu/models/client/users.dart';
import 'package:naya_menu/models/venue/venue.dart';
import 'package:naya_menu/service/firebase/firestore_user.dart';
import 'package:naya_menu/client_app/main_page/cl_main_page.dart';
import 'package:naya_menu/service/firebase/firestore_venue.dart';
import 'package:naya_menu/theme/app_theme.dart'; // Import your AppTheme
import 'package:dropdown_search/dropdown_search.dart';
import 'package:naya_menu/theme/country_list.dart';

import '../widgets/progress_indicator.dart';

class ClSignUpUserData extends ConsumerStatefulWidget {
  final String userId;
  final String email; // Email passed from the authentication page

  const ClSignUpUserData(
      {required this.userId, required this.email, super.key});

  @override
  _ClSignUpUserDataState createState() => _ClSignUpUserDataState();
}

class _ClSignUpUserDataState extends ConsumerState<ClSignUpUserData> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _businessController = TextEditingController();
  final TextEditingController _countryCodeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final FirestoreUser _firestoreUser =
      FirestoreUser(); // Instance of FirestoreUser

  String country = '';

  void _onCountrySelected(String? selectedCountry) {
    country = selectedCountry ?? '';
    setState(() {
      _countryCodeController.text = countryToCode[country] ?? '';
      _phoneController.text = '${_countryCodeController.text} ';
      _phoneController.selection = TextSelection.fromPosition(
        TextPosition(offset: _phoneController.text.length),
      );
    });
  }

  Future<void> _submitInfo() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Format phone number correctly
        String countryCode = _countryCodeController.text.trim();
        String phoneNumber = _phoneController.text.trim();

        // Combine the final country code and phone number
        String fullPhoneNumber = '$countryCode $phoneNumber';

        // Check if the phone number already exists
        bool phoneExists = await _firestoreUser.checkIfUserExists(
          email: widget.email,
          phoneNumber: fullPhoneNumber,
        );

        if (phoneExists) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'This phone number is already associated with an account. Please use a different phone number.',
              ),
            ),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        // Create UserModel with the provided information
        UserModel user = UserModel(
          userId: widget.userId,
          name: _nameController.text,
          email: widget.email,
          phoneNumber: fullPhoneNumber,
          country: country,
          businessName: _businessController.text.trim(),
          emailNotification: true,
          smsNotification: true,
        );

        // Save user information to Firestore
        await _firestoreUser.addUser(user);

        // Create a default venue using the user information
        VenueModel defaultVenue = VenueModel(
          venueId: '', // Firestore will generate the ID
          venueName: user.businessName,
          logoUrl: '',
          address: {
            'country': user.country,
          },
          contact: {
            'email': user.email,
            'phoneNumber': user.phoneNumber,
          },
        );

        // Add the venue to Firestore
        final venueId =
            await FirestoreVenue().addVenue(user.userId, defaultVenue);

        // Set the UserProvider with the new user data
        ref.read(userProvider.notifier).setUser(user);

        // Set the VenueProvider with the newly created venue data
        await ref.read(venueProvider.notifier).fetchVenue(user.userId, venueId);

        // Navigate to the MainPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
        );
      } catch (e) {
        print('Error during submission: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save user information. Please try again.'),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CircleAvatar(
              backgroundColor: AppTheme.primaryColor,
              backgroundImage: NetworkImage(
                'https://images.pexels.com/photos/1537635/pexels-photo-1537635.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
              ),
              radius: 20.0,
            ),
            LanguageDropdown()
          ],
        ),
        backgroundColor: AppTheme.background,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              width: 450,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize:
                    MainAxisSize.min, // Adjusted to use MainAxisSize.min
                children: <Widget>[
                  Text(
                    'Welcome to Naya Menu!',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Tell us about yourself',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: AppTheme.accentColor),
                  ),
                  const SizedBox(height: 20.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "What is your name?",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 5.0),
                        InputField(
                          labelAboveField: false,
                          label: null, // No label inside the field
                          controller: _nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        Text(
                          "What is your country?",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontSize: 16),
                        ),
                        DropdownSearch<String>(
                          items: countries, // Use the list of countries here
                          selectedItem: null,
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              filled: AppTheme.inputDecorationTheme.filled,
                              fillColor:
                                  AppTheme.inputDecorationTheme.fillColor,
                              border: AppTheme.inputDecorationTheme.border,
                              enabledBorder:
                                  AppTheme.inputDecorationTheme.enabledBorder,
                              focusedBorder:
                                  AppTheme.inputDecorationTheme.focusedBorder,
                              contentPadding: const EdgeInsets.all(10.0),
                              hintText: "Select your country",
                              hintStyle:
                                  AppTheme.inputDecorationTheme.hintStyle,
                            ),
                          ),
                          onChanged: _onCountrySelected,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your country';
                            }
                            return null;
                          },
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(
                              decoration: InputDecoration(
                                filled: AppTheme.inputDecorationTheme.filled,
                                fillColor:
                                    AppTheme.inputDecorationTheme.fillColor,
                                border: AppTheme.inputDecorationTheme.border,
                                enabledBorder:
                                    AppTheme.inputDecorationTheme.enabledBorder,
                                focusedBorder:
                                    AppTheme.inputDecorationTheme.focusedBorder,
                                contentPadding: const EdgeInsets.all(10.0),
                                // hintText: "Search your country",
                                hintStyle:
                                    AppTheme.inputDecorationTheme.hintStyle,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Text(
                          "What is your business name?",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontSize: 16),
                        ),
                        InputField(
                          labelAboveField: false,
                          label: null, // No label inside the field
                          controller: _businessController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your business name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        Text(
                          "What is your phone number?",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontSize: 16),
                        ),
                        PhoneNumberInput(
                          controller: _phoneController,
                          countryCodeController: _countryCodeController,
                          validator: (phone) {
                            if (phone == null || phone.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30.0),
                        Center(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submitInfo,
                            style:
                                AppTheme.buttonStyle, // Consistent button style
                            child: _isLoading
                                ? CustomProgressIndicator()
                                : const Text('Start Your Free Trial'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: AppTheme.background, // Consistent background color
    );
  }
}

class LanguageDropdown extends StatelessWidget {
  final String currentLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      surfaceTintColor: AppTheme.chipBackground,
      onSelected: (String newValue) {
        // Handle language change
      },
      itemBuilder: (BuildContext context) {
        return ['English', 'Arabic', 'Spanish', 'French', 'German']
            .map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
      child: Row(
        children: [
          Icon(Icons.language, color: AppTheme.grey),
          SizedBox(width: 8),
          Text(
            currentLanguage,
            style: TextStyle(color: AppTheme.grey, fontSize: 16),
          ),
          SizedBox(width: 8),
          Icon(Icons.arrow_drop_down, color: AppTheme.grey),
        ],
      ),
    );
  }
}
