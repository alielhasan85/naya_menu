import 'package:flutter/material.dart';
import 'package:naya_menu/client/screens/login/cl_signup_user_data.dart';
import 'package:naya_menu/client/screens/starting_page/cl_home_page.dart';
import 'package:naya_menu/client/screens/platform/cl_main_page.dart';
import 'package:naya_menu/theme/app_theme.dart'; // Import your AppTheme

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Client Interface',
      theme: AppTheme.themeData(context), // Use your custom theme here
      home: GetStartedPage(),
    );
  }
}
