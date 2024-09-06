import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:naya_menu/client_app/landing_page/cl_loading_page.dart';
import 'package:naya_menu/client_app/main_page/cl_main_page.dart';
import 'package:naya_menu/client_app/notifier.dart';
import 'package:naya_menu/service/firebase/firestore_venue.dart';
import 'package:naya_menu/service/lang/localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/service/lang/lang_provider.dart';

import '../theme/app_theme.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool _isLoggedIn = false;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _logInDevelopmentAccount();
  }

  // Log in using development credentials
  Future<void> _logInDevelopmentAccount() async {
    try {
      const String email =
          'elhasan.aliqa@gmail.com'; // Replace with your dev email
      const String password = 'rotation'; // Replace with your dev password

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = userCredential.user!.uid;

      // Fetch and set user data in Riverpod
      await ref.read(userProvider.notifier).fetchUser(userId);

      // Fetch associated venues
      final venueList = await FirestoreVenue().getAllVenues(userId);
      if (venueList.isNotEmpty) {
        ref.read(venueProvider.notifier).setVenue(venueList.first);
      }

      // Update the state when logged in successfully
      setState(() {
        _isLoggedIn = true;
        _userId = userId;
      });
    } catch (e) {
      print('Login failed: $e');
      // Handle login errors, such as showing a Snackbar or dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLanguage = ref.watch(languageProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Client Interface',
      theme: AppTheme.themeData(context), // Apply the custom theme
      supportedLocales: const [
        Locale('en', ''),
        Locale('ar', ''),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Locale(currentLanguage == 'English' ? 'en' : 'ar'),
      builder: (context, child) {
        return Directionality(
          textDirection: currentLanguage == 'Arabic'
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: child!,
        );
      },
      home: Scaffold(
        body:
            // LoadingPage(),

            _isLoggedIn && _userId != null
                ? const MainPage() // Show main page when logged in
                : const Center(
                    child: CircularProgressIndicator()), // Loading state
      ),
    );
  }
}
