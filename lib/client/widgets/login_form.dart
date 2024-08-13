import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:naya_menu/client/screens/main_screen.dart';
import 'package:naya_menu/client/widgets/input_fields.dart';

// TODO: add forget passworld page
// TODO: add and check google login steps
// TODO: add otp request with phone number

class LoginForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onToggle;

  const LoginForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.onToggle,
    Key? key,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
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

  Future<void> _logIn() async {
    if (!widget.formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: widget.emailController.text,
        password: widget.passwordController.text,
      );

      // Navigate to MainPage on successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreenPage()),
      );
    } on FirebaseAuthException catch (e) {
      // Handle error (e.g., show a dialog or Snackbar)
      print(e.message);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
            'Log In to Your Account',
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 15.0),
          const Text(
            'Welcome back!',
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
          ),
          const SizedBox(height: 20.0),
          InputField(
            label: "Password",
            hintText: "Enter your password",
            controller: widget.passwordController,
            validator: _validatePassword,
            obscureText: true,
          ),
          const SizedBox(height: 20.0),
          SizedBox(
            width: 400,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _logIn,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : const Text('Log In'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                textStyle: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account? "),
              TextButton(
                onPressed: widget.onToggle,
                child: const Text(
                  "Sign Up",
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
