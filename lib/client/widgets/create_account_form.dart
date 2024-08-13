import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:naya_menu/client/widgets/input_fields.dart';

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
  bool _showConfirmPassword = false;
  bool _isLoading = false;

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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _checkFields() {
    final isEmailValid = _validateEmail(widget.emailController.text) == null;
    final isPasswordValid =
        _validatePassword(widget.passwordController.text) == null;

    setState(() {
      _showConfirmPassword = isEmailValid && isPasswordValid;
    });
  }

// function for firebase authentication
  Future<void> _signUp() async {
    if (!widget.formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double titleFontSize = screenWidth < 600 ? 20.0 : 30.0;

    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Create Your Free Account',
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 15.0),
          const Text(
            'No Credit Card required.',
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 20.0),
          InputField(
            label: "Email",
            hintText: "Enter your email",
            controller: widget.emailController,
            validator: _validateEmail,
            onChanged: (value) => _checkFields(),
          ),
          const SizedBox(height: 20.0),
          InputField(
            label: "Password",
            hintText: "Enter your password",
            controller: widget.passwordController,
            validator: _validatePassword,
            onChanged: (value) => _checkFields(),
            obscureText: true,
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
              obscureText: true,
            ),
          const SizedBox(height: 20.0),
          SizedBox(
            width: 400,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _signUp,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : const Text('Create Account'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.white,
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
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                textStyle: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
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
                onPressed: widget.onToggle,
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
