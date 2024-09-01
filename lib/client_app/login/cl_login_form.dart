import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/service/firebase/auth_user.dart';
import 'package:naya_menu/client_app/widgets/input_fields.dart';
import 'package:naya_menu/service/firebase/firestore_venue.dart';
import 'package:naya_menu/service/lang/localization.dart';
import '../widgets/progress_indicator.dart';
import '../main_page/cl_main_page.dart';

import 'package:naya_menu/client_app/notifier.dart';

class LoginForm extends ConsumerStatefulWidget {
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

class _LoginFormState extends ConsumerState<LoginForm> {
  bool _isLoading = false;
  final AuthService _authService = AuthService();

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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.translate('password_hint');
    }
    if (value.length < 6) {
      return AppLocalizations.of(context)!.translate('password_hint');
    }
    return null;
  }

  // Future<void> _logIn() async {
  //   if (!widget.formKey.currentState!.validate()) return;

  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     UserCredential userCredential =
  //         await _authService.signInWithEmailAndPassword(
  //       widget.emailController.text,
  //       widget.passwordController.text,
  //     );

  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => MainPage(userId: userCredential.user!.uid),
  //       ),
  //     );
  //   } on AuthException catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(e.message)),
  //     );
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  Future<void> _logIn() async {
    if (!widget.formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Sign in the user
      UserCredential userCredential =
          await _authService.signInWithEmailAndPassword(
        widget.emailController.text,
        widget.passwordController.text,
      );

      final userId = userCredential.user!.uid;

      // Fetch the user data from Firestore
      await ref.read(userProvider.notifier).fetchUser(userId);

      // Assuming you have a method to fetch the venue ID associated with the user
      final user = ref.read(userProvider);
      if (user != null) {
        // Fetch the venue data associated with the user
        final venueList = await FirestoreVenue().getAllVenues(userId);
        if (venueList.isNotEmpty) {
          ref.read(venueProvider.notifier).setVenue(venueList.first);
        }
      }

      // Navigate to the MainPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainPage(),
        ),
      );
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
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
