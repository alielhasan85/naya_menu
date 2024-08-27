import 'package:flutter/material.dart';

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
