import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:naya_menu/client%20app/login/cl_signup_user_data.dart';
import 'package:naya_menu/client%20app/main%20page/cl_main_page.dart';
import 'package:naya_menu/client%20app/loading_page/cl_loading_page.dart';
import 'package:naya_menu/service/lang/localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/service/lang/lang_provider.dart';

import 'menu management/meal_create.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage =
        ref.watch(languageProvider); // Watch the selected language

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Client Interface',
        theme: ThemeData(primarySwatch: Colors.blue),
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
        locale: Locale(currentLanguage == 'English'
            ? 'en'
            : 'ar'), // Set the locale based on the selected language
        builder: (context, child) {
          return Directionality(
            textDirection: currentLanguage == 'Arabic'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: child!,
          );
        },
        home: const LoadingPage()

        //     MainPage(
        //   userId: 'Pt1SYSb4KKOzHLdmQe3WCNO5shy2',
        // ),
        );
  }
}
