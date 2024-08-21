import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:naya_menu/client/widgets/input_fields.dart';
import 'package:naya_menu/client/widgets/phone_number.dart';
import 'package:naya_menu/models/client/users.dart';
import 'package:naya_menu/service/firebase/firestore_user.dart';
import 'package:naya_menu/client/screens/platform/cl_main_page.dart';
import 'package:naya_menu/service/firebase/firestore_venue.dart';
import 'package:naya_menu/theme/app_theme.dart'; // Import your AppTheme
import 'package:dropdown_search/dropdown_search.dart';
import 'package:naya_menu/theme/country_list.dart';
import 'package:naya_menu/models/venue/venue_index.dart';

class ClSignUpUserData extends StatefulWidget {
  final String userId;
  final String email; // Email passed from the authentication page

  const ClSignUpUserData(
      {required this.userId, required this.email, super.key});

  @override
  _ClSignUpUserDataState createState() => _ClSignUpUserDataState();
}

class _ClSignUpUserDataState extends State<ClSignUpUserData> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _businessController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final FirestoreUser _firestoreUser =
      FirestoreUser(); // Instance of FirestoreUser

  Future<void> _submitInfo() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Check if the phone number already exists
        bool phoneExists = await _firestoreUser.checkIfUserExists(
          email: widget.email,
          phoneNumber: _phoneController.text.trim(),
        );

        if (phoneExists) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'This phone number is already associated with an account. Please use a different phone number.')),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        // Create UserModel with the provided information
        UserModel user = UserModel(
          id: widget.userId,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: widget.email,
          phoneNumber: _phoneController.text.trim(),
          country: _countryController.text.trim(),
          businessName: _businessController.text.trim(),
          emailNotification: true,
          smsNotification: true,
        );

        // Save user information to Firestore using FirestoreUser service
        await _firestoreUser.addUser(user);

        // Create the venue in Firestore
        FirestoreVenueService venueService = FirestoreVenueService();

        Venue venue = Venue(
          id: '', // Empty id, Firestore will generate it
          ownerId: widget.userId,
          name: _businessController.text.trim(),
        );

        // Add the venue using the service
        String venueId = await venueService.addVenue(venue);

        print('Venue created successfully with ID: $venueId');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      } catch (e) {
        print('Error during submission: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to save user information. Please try again.')),
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
            CircleAvatar(
              backgroundColor: Colors.black87,
              backgroundImage: NetworkImage(
                'https://images.pexels.com/photos/1537635/pexels-photo-1537635.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
              ),
              radius: 20.0,
            ),
            LanguageDropdown()
          ],
        ),
        backgroundColor: Colors.transparent,
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
              width: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Welcome to Naya Menu!',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: Colors.indigo),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Tell us about yourself',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: const Color.fromARGB(255, 181, 63, 161)),
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
                        Row(
                          children: [
                            Expanded(
                              child: InputField(
                                labelAboveField: false,
                                label: null, // No label inside the field
                                hintText: "Enter your first name",
                                controller: _firstNameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your first name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: InputField(
                                labelAboveField: false,
                                label: null, // No label inside the field
                                hintText: "Enter your last name",
                                controller: _lastNameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your last name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
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
                          validator: (phone) {
                            if (phone == null) {
                              return 'Please enter your phone number';
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
                          hintText: "Enter your business name",
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
                          "What is your country?",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontSize: 16),
                        ),
                        DropdownSearch<String>(
                          items: countries, // Use the list of countries here
                          selectedItem: _countryController.text.isNotEmpty
                              ? _countryController.text
                              : null,
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
                          onChanged: (String? newValue) {
                            _countryController.text = newValue ?? '';
                          },
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
                                hintText: "Search your country",
                                hintStyle:
                                    AppTheme.inputDecorationTheme.hintStyle,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        Center(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submitInfo,
                            child: _isLoading
                                ? CircularProgressIndicator()
                                : const Text('Submit'),
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
      backgroundColor: Colors.white, // Customize background color here
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
