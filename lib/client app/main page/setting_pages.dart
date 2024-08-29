import 'package:flutter/material.dart';
import 'package:naya_menu/theme/app_theme.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: AppTheme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: AppTheme.appBarTheme.backgroundColor,
      ),
      body: Center(
        child: Text(
          'Settings Details',
          style: AppTheme.textTheme.bodyMedium,
        ),
      ),
      backgroundColor: AppTheme.background,
    );
  }
}
