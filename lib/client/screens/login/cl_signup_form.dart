import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:naya_menu/client/widgets/input_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:naya_menu/client/screens/cl_main_page.dart'; // Import MainPage

class SignUpForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onToggle;

  const SignUpForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onToggle,
    Key? key,
  }) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _showConfirmPassword =
      false; // Flag to toggle the confirm password field
  bool _isLoading = false; // Flag to indicate loading state during sign-up

  // Method to validate email input
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    }
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Method to validate password input
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Check if the email and password fields are valid before showing the confirm password field
  void _checkFields() {
    final isEmailValid = _validateEmail(widget.emailController.text) == null;
    final isPasswordValid =
        _validatePassword(widget.passwordController.text) == null;

    setState(() {
      _showConfirmPassword = isEmailValid && isPasswordValid;
    });
  }

  // Method to handle sign-up process with Firebase authentication
  Future<void> _signUp() async {
    if (!widget.formKey.currentState!.validate())
      return; // Validate form fields

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      // Create a new user with FirebaseAuth
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.emailController.text,
        password: widget.passwordController.text,
      );

      // Navigate to MainPage on successful sign-up
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    } on FirebaseAuthException catch (e) {
      // Handle errors during sign-up
      String errorMessage;

      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'An account already exists for that email.';
      } else {
        errorMessage = 'An error occurred. Please try again.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double titleFontSize =
        screenWidth < 600 ? 20.0 : 30.0; // Responsive font size

    return Form(
      key: widget.formKey, // Form key for validation
      child: Column(
        mainAxisSize: MainAxisSize.min, // Adjusts to the size of its children
        crossAxisAlignment:
            CrossAxisAlignment.center, // Center-align the content
        children: <Widget>[
          Text(
            'Create Your Free Account',
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w900, // Bold text
            ),
          ),
          const SizedBox(height: 15.0),
          const Text(
            'No Credit Card required.',
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic, // Italicized text
            ),
          ),
          const SizedBox(height: 20.0),
          InputField(
            label: "Email",
            hintText: "Enter your email",
            controller: widget.emailController,
            validator: _validateEmail,
            onChanged: (value) => _checkFields(), // Check fields on change
          ),
          const SizedBox(height: 20.0),
          InputField(
            label: "Password",
            hintText: "Enter your password",
            controller: widget.passwordController,
            validator: _validatePassword,
            onChanged: (value) => _checkFields(), // Check fields on change
            obscureText: true, // Hide password input
          ),
          if (_showConfirmPassword) const SizedBox(height: 20.0),
          if (_showConfirmPassword)
            InputField(
              label: "Confirm Password",
              hintText: "Confirm your password",
              controller: widget.confirmPasswordController,
              validator: (value) {
                if (value != widget.passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
              obscureText: true, // Hide confirm password input
            ),
          const SizedBox(height: 20.0),
          SizedBox(
            width: 400,
            child: ElevatedButton(
              onPressed:
                  _isLoading ? null : _signUp, // Disable button if loading
              child: _isLoading
                  ? CircularProgressIndicator() // Show loading indicator if in progress
                  : const Text('Create Account'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent, // Button background color
                foregroundColor: Colors.white, // Button text color
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                textStyle: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          const Row(
            children: <Widget>[
              Expanded(child: Divider(color: Colors.black)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text('or',
                    style: TextStyle(color: Color.fromARGB(255, 85, 85, 85))),
              ),
              Expanded(child: Divider(color: Color.fromARGB(255, 85, 85, 85))),
            ],
          ),
          const SizedBox(height: 20.0),
          SizedBox(
            width: 400,
            child: ElevatedButton.icon(
              onPressed: () {
                // Handle Google sign-up
              },
              icon: const FaIcon(
                FontAwesomeIcons.google,
                color: Colors.red,
                size: 16,
              ),
              label: const Text('Sign Up with Google'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Button background color
                foregroundColor: Colors.black, // Button text color
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                textStyle: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          // Toggle to login form if the user already has an account
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  "Already have an account? ",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                onPressed: widget.onToggle, // Trigger form toggle
                child: const Text(
                  "Log in",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
