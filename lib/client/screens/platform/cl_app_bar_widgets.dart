import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/client/screens/platform/user_management/cl_user_page.dart';
import 'package:naya_menu/theme/app_theme.dart';
import '../../../models/client/users.dart';
import 'account_menu.dart';
import 'package:naya_menu/client/screens/platform/utility_functions.dart';

List<Widget> buildAppBarActions(
    BuildContext context, UserModel? user, WidgetRef ref) {
  return [
    _buildSearchField(),
    const SizedBox(width: 20),
    _buildNotificationButton(),
    const SizedBox(width: 20),
    if (user != null)
      ProfileMenu(
        onChange: (index) {
          switch (index) {
            case 0:
              _viewProfile(context, user); // Open UserProfilePage
              break;
            case 1:
              openNotifications(context);
              break;
            case 2:
              changeLanguage(context);
              break;
            case 3:
              openHelpCenter(context);
              break;
            case 4:
              logout(context);
              break;
          }
        },
      )
    else
      const CircularProgressIndicator(),
    const SizedBox(width: 20),
  ];
}

Widget _buildSearchField() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    child: SizedBox(
      width: 300,
      child: TextField(
        decoration: InputDecoration(
          labelText: '',
          hintText: 'Search...',
          labelStyle: AppTheme.inputDecorationTheme.labelStyle,
          hintStyle: AppTheme.inputDecorationTheme.hintStyle,
          border: AppTheme.inputDecorationTheme.border,
          enabledBorder: AppTheme.inputDecorationTheme.enabledBorder,
          focusedBorder: AppTheme.inputDecorationTheme.focusedBorder,
          filled: true,
          fillColor: AppTheme.inputDecorationTheme.fillColor,
        ),
      ),
    ),
  );
}

Widget _buildNotificationButton() {
  return IconButton(
    icon: Icon(
      Icons.notifications,
      color: AppTheme.iconTheme.color,
    ),
    onPressed: () {
      // Handle notification icon button press
    },
  );
}

void _viewProfile(BuildContext context, UserModel? user) {
  if (user != null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfilePage(),
      ),
    );
  }
}
