import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

AppBar buildUserProfileAppBar(BuildContext context) {
  return AppBar(
    elevation: 0,
    automaticallyImplyLeading: false,
    title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text('Account Settings',
            style: AppTheme.appBarTheme.titleTextStyle)),
    backgroundColor: AppTheme.appBarTheme.backgroundColor,
    actions: [
      IconButton(
        tooltip: 'Close',
        icon: Icon(Icons.close, color: AppTheme.iconTheme.color),
        onPressed: () => Navigator.of(context).pop(),
      ),
      const SizedBox(width: 20),
    ],
  );
}
