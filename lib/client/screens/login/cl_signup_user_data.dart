import 'package:flutter/material.dart';
import 'package:naya_menu/client/widgets/input_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:naya_menu/client/screens/platform/cl_main_page.dart'; // Import MainPage

class ClSignUpUserData extends StatefulWidget {
  final String userId;
  final String email; // Receive email passed from the previous page

  const ClSignUpUserData({required this.userId, required this.email, Key? key})
      : super(key: key);

  @override
  _ClSignUpUserDataState createState() => _ClSignUpUserDataState();
}

class _ClSignUpUserDataState extends State<ClSignUpUserData> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _businessController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false; // Flag to indicate loading state during submission

  Future<void> _submitInfo() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      try {
        // Save this information to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .set({
          'name': _nameController.text,
          'email': widget.email, // Use the email passed from FirebaseAuth
          'phoneNumber': _phoneController.text,
          'businessName': _businessController.text,
          'country': _countryController.text,
        });

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
          _isLoading = false; // Hide loading indicator
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Additional Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              InputField(
                label: "Name",
                hintText: "Enter your name",
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
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
                label: "Business Name",
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
                onPressed: _isLoading
                    ? null
                    : _submitInfo, // Disable button if loading
                child: _isLoading
                    ? CircularProgressIndicator() // Show loading indicator if in progress
                    : const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
