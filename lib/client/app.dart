import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:naya_menu/client/screens/login/cl_signup_user_data.dart';
import 'package:naya_menu/client/screens/starting_page/cl_home_page.dart';
import 'package:naya_menu/client/screens/platform/cl_main_page.dart';
import 'package:naya_menu/service/lang/localization.dart';
import 'package:naya_menu/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Client Interface',
      theme: AppTheme.themeData(context), // Use your custom theme here
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('ar', ''), // Arabic
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate, // Your custom localization delegate
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) {
          return supportedLocales.first;
        }
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      locale: const Locale('en'), // Set default locale
      home: const GetStartedPage(),
      builder: (context, child) {
        // Apply the text direction based on the selected locale
        return Directionality(
          textDirection: _getTextDirection(
              AppLocalizations.of(context)?.locale.languageCode),
          child: child!,
        );
      },
    );
  }

  // Helper method to determine text direction
  TextDirection _getTextDirection(String? languageCode) {
    if (languageCode == 'ar') {
      return TextDirection.rtl; // Right-to-left for Arabic
    } else {
      return TextDirection.ltr; // Left-to-right for other languages
    }
  }
}
