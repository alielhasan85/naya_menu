import 'package:flutter/material.dart';
import 'package:naya_menu/client%20app/user_management/cl_user_profile_page.dart';

void openNotifications(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Notifications feature is under development.'),
    ),
  );
}

void changeLanguage(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Change Language feature is under development.'),
    ),
  );
}

void openHelpCenter(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Help Center is under development.'),
    ),
  );
}

void logout(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Logging out...'),
    ),
  );
  Navigator.of(context).pop();
}

void viewProfile(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const UserProfilePage(),
    ),
  );
}
