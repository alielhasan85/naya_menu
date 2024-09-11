import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:naya_menu/client_app/main_page/cl_main_page.dart';
import 'package:naya_menu/client_app/notifier.dart';
import 'package:naya_menu/client_app/widgets/input_fields.dart';
import 'package:naya_menu/models/client/users.dart';
import 'package:naya_menu/models/venue/venue.dart';
import 'package:naya_menu/service/firebase/firestore_user.dart';
import 'package:naya_menu/service/firebase/firestore_venue.dart';
import 'package:naya_menu/theme/app_theme.dart';
import '../widgets/progress_indicator.dart';

class ClSignUpUserData extends ConsumerStatefulWidget {
  final String userId;
  final String email; // Email passed from the authentication page

  const ClSignUpUserData({
    required this.userId,
    required this.email,
    super.key,
  });

  @override
  _ClSignUpUserDataState createState() => _ClSignUpUserDataState();
}

class _ClSignUpUserDataState extends ConsumerState<ClSignUpUserData> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _businessController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _countryCodeController =
      TextEditingController(); // For storing country code
  final TextEditingController _countryNameController =
      TextEditingController(); // For storing country name

  final TextEditingController _countryDialController =
      TextEditingController(); // For storing country name
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final FirestoreUser _firestoreUser = FirestoreUser(); // Firestore instance
  String country = ''; // To store selected country
  String countryCode = ''; // To store country code
  String dialCode = ''; // To store +961

  Future<void> _submitInfo() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Get phone number and country dial code
        String phoneNumber = _phoneController.text.trim();
        String countryDial = _countryDialController.text
            .trim(); // Only save dial code (e.g., +1)

        String countryCode = _countryCodeController.text
            .trim(); // Only save dial code (e.g., +1)
        String countryName = _countryNameController.text
            .trim(); // Optional if needed for display

        // Check if the phone number already exists
        bool phoneExists = await _firestoreUser.checkIfUserExists(
          email: widget.email,
          phoneNumber: '$countryDial $phoneNumber', // Dial code + phone number
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

        // Create UserModel with the provided information (store countryDial and phoneNumber only)
        UserModel user = UserModel(
          userId: widget.userId,
          name: _nameController.text,
          contact: {
            'email': widget.email,
            'phoneNumber': phoneNumber, // Store phone number only
            'countryCode': countryCode,
            'countryDial': countryDial,
            // Store only the dial code (e.g., +1)
          },
          address: {
            'country':
                countryName, // If you want to store country name for display purposes
            'state': '',
            'city': '',
            'address': '',
          },
          businessName: _businessController.text.trim(),
          notifications: {
            'emailNotification': true,
            'smsNotification': true,
          },
        );

        // Save user information to Firestore
        await _firestoreUser.addUser(user);

        // Create a default venue using the user information
        VenueModel defaultVenue = VenueModel(
          userId: user.userId,
          venueId: '', // Firestore will generate the ID
          venueName: user.businessName,
          address: {
            'country': user.address['country'],
          },
          contact: {
            'email': user.contact['email'],
            'phoneNumber': user.contact['phoneNumber'], // Save phone number
            'countryCode': user.contact['countryCode'], // Save only dial code
            'countryDial': user.contact['countryDial']
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

// Phone Number Input Field using intl_phone_field
                        IntlPhoneField(
                          decoration: InputDecoration(
                            border: AppTheme.inputDecorationTheme.border,
                          ),
                          dropdownDecoration: BoxDecoration(),
                          initialCountryCode: _countryCodeController
                                  .text.isNotEmpty
                              ? _countryCodeController
                                  .text // Pre-fill country code if available
                              : 'US', // Default country
                          initialValue: _phoneController
                              .text, // Pre-fill phone number if available
                          onChanged: (phone) {
                            // Store phone number without dial code
                            _phoneController.text = phone.number;

                            // Store relevant country information in controllers
                          },
                          onCountryChanged: (country) {
                            // Save country details when the country is changed
                            _countryDialController.text = country.dialCode;
                            _countryCodeController.text = country.code;
                            _countryNameController.text = country
                                .name; // Save country name like 'United States'
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
