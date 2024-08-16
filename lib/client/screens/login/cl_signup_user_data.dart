import 'package:flutter/material.dart';
import 'package:naya_menu/client/widgets/input_fields.dart';
import 'package:naya_menu/models/users.dart';
import 'package:naya_menu/service/firebase/firestore_user.dart';
import 'package:naya_menu/client/screens/platform/cl_main_page.dart';

class ClSignUpUserData extends StatefulWidget {
  final String userId;
  final String email; // Email passed from the authentication page

  const ClSignUpUserData({required this.userId, required this.email, Key? key})
      : super(key: key);

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
        // Create UserModel with the provided information
        UserModel user = UserModel(
          id: widget.userId,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: widget.email, // Email from FirebaseAuth
          phoneNumber: _phoneController.text,
          country: _countryController.text,
          businessName: _businessController.text,
          emailNotification: true, // Default value
          smsNotification: true, // Default value
        );

        // Save user information to Firestore using FirestoreUser service
        await _firestoreUser.addUser(user);

        // Navigate to the main page or next step
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      } catch (e) {
        // Handle any errors here
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
            DropdownButton<String>(
              value: 'English',
              icon: const Icon(Icons.language),
              onChanged: (String? newValue) {
                // Handle language change
              },
              items: <String>['English']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Image.asset(
              'assets/images/logo.png', // Path to your logo image
              height: 40,
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Welcome to NayaMenu!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent, // Customize the color
                  ),
                ),
                const SizedBox(height: 10.0),
                const Text(
                  'What is your name?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20.0),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      InputField(
                        label: "First Name",
                        hintText: "Enter your first name",
                        controller: _firstNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      InputField(
                        label: "Last Name",
                        hintText: "Enter your last name",
                        controller: _lastNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      InputField(
                        label: "Business Name",
                        hintText: "Enter your first name",
                        controller: _businessController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your business name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      InputField(
                        label: "Phone Number",
                        hintText: "Enter your phone number",
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      InputField(
                        label: "Country",
                        hintText: "Enter your country",
                        controller: _countryController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your country';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _submitInfo,
                        child: _isLoading
                            ? CircularProgressIndicator()
                            : const Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white, // Customize background color here
    );
  }
}
