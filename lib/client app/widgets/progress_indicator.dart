import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

// ignore: use_key_in_widget_constructors
class CustomProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
        backgroundColor: AppTheme.lightPeach,
      ),
    );
  }
}
