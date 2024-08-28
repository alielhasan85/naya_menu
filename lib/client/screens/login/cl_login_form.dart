import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:naya_menu/client/widgets/input_fields.dart';
import 'package:naya_menu/service/lang/localization.dart';

import '../../widgets/progress_indicator.dart';
import '../platform/cl_main_page.dart';

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
    super.key,
  });

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isLoading = false;

  // Validate email input
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.translate('email_hint');
    }
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(value)) {
      return AppLocalizations.of(context)!.translate('email_hint');
    }
    return null;
  }

  // Validate password input
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.translate('password_hint');
    }
    if (value.length < 6) {
      return AppLocalizations.of(context)!.translate('password_hint');
    }
    return null;
  }

  // Log in process with Firebase authentication
// Log in process with Firebase authentication
  Future<void> _logIn() async {
    if (!widget.formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Sign in with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: widget.emailController.text,
        password: widget.passwordController.text,
      );

      // Retrieve the userId from the authenticated user
      String userId = userCredential.user!.uid;

      // Navigate to MainPage on successful login and pass the userId
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(userId: userId),
        ),
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
            AppLocalizations.of(context)!.translate('log_in_to_your_account'),
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 15.0),
          Text(
            AppLocalizations.of(context)!.translate('welcome_back'),
            style: const TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 20.0),
          InputField(
            label: AppLocalizations.of(context)!.translate('email_label'),
            hintText: AppLocalizations.of(context)!.translate('email_hint'),
            controller: widget.emailController,
            validator: _validateEmail,
          ),
          const SizedBox(height: 20.0),
          InputField(
            label: AppLocalizations.of(context)!.translate('password_label'),
            hintText: AppLocalizations.of(context)!.translate('password_hint'),
            controller: widget.passwordController,
            validator: _validatePassword,
            obscureText: true,
          ),
          const SizedBox(height: 20.0),
          SizedBox(
            width: 400,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _logIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 15.0),
                textStyle: const TextStyle(fontSize: 16.0),
              ),
              child: _isLoading
                  ? CustomProgressIndicator()
                  : Text(
                      AppLocalizations.of(context)!.translate('log_in_button')),
            ),
          ),
          const SizedBox(height: 20.0),
          // Toggle to sign-up form if the user doesn't have an account
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!
                  .translate('dont_have_an_account')),
              TextButton(
                onPressed: widget.onToggle,
                child: Text(
                  AppLocalizations.of(context)!.translate('sign_up'),
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
