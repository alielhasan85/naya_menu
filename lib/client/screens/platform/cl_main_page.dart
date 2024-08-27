import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/client/screens/platform/section_content.dart';
import 'package:naya_menu/client/screens/platform/cl_user_page.dart';
import 'package:naya_menu/client/screens/platform/user_notifier.dart';
import 'package:naya_menu/theme/app_theme.dart';
import '../../../models/client/users.dart';
import 'account_menu.dart';
import '../../widgets/navigationRail.dart';

final selectedSectionProvider = StateProvider<String>((ref) => 'Dashboard');
final isNavigationRailExpandedProvider = StateProvider<bool>((ref) => true);

class MainPage extends ConsumerStatefulWidget {
  final String userId;

  const MainPage({required this.userId, super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  @override
  void initState() {
    super.initState();
    // Fetch and store user data on init
    ref.read(userProvider.notifier).fetchUser(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final selectedSection = ref.watch(selectedSectionProvider);
    final isNavigationRailExpanded =
        ref.watch(isNavigationRailExpandedProvider);
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Platform Name",
          style: AppTheme
              .appBarTheme.titleTextStyle, // Use AppTheme for title style
        ),
        actions: [
          _buildSearchField(),
          const SizedBox(width: 20),
          _buildNotificationButton(),
          const SizedBox(width: 20),
          if (user != null)
            ProfileMenu(
              onChange: (index) {
                switch (index) {
                  case 0:
                    _viewProfile(
                        context); // Open UserProfilePage without passing user
                    break;
                  case 1:
                    _openNotifications(
                        context); // Open Notifications (to be implemented)
                    break;
                  case 2:
                    _changeLanguage(
                        context); // Change Language (to be implemented)
                    break;
                  case 3:
                    _openHelpCenter(
                        context); // Open Help Center (to be implemented)
                    break;
                  case 4:
                    _logout(context); // Sign out
                    break;
                }
              },
            )
          else
            const CircularProgressIndicator(),
          const SizedBox(width: 20),
        ],
        backgroundColor: AppTheme.appBarTheme.backgroundColor,
      ),
      body: Row(
        children: [
          NavigationRailWidget(), // Use NavigationRailWidget
          const VerticalDivider(thickness: 1, width: 1),
          Column(
            children: [
              IconButton(
                icon: Icon(
                  isNavigationRailExpanded
                      ? Icons.keyboard_arrow_left
                      : Icons.keyboard_arrow_right,
                  color: AppTheme.iconTheme.color,
                ),
                onPressed: () {
                  ref.read(isNavigationRailExpandedProvider.notifier).state =
                      !isNavigationRailExpanded;
                },
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SectionContent(selectedSection: selectedSection),
            ),
          ),
        ],
      ),
      backgroundColor: AppTheme.background,
    );
  }

  void _openSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPage(),
      ),
    );
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
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings',
            style: AppTheme
                .appBarTheme.titleTextStyle), // Use AppTheme for title style
        backgroundColor:
            AppTheme.appBarTheme.backgroundColor, // Use AppTheme for background
      ),
      body: Center(
        child: Text('Settings Details',
            style: AppTheme.textTheme.bodyMedium), // Use AppTheme for body text
      ),
      backgroundColor:
          AppTheme.background, // Use AppTheme for scaffold background
    );
  }
}

void _openNotifications(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Notifications feature is under development.'),
    ),
  );
}

void _changeLanguage(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Change Language feature is under development.'),
    ),
  );
}

void _openHelpCenter(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Help Center is under development.'),
    ),
  );
}

void _logout(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Logging out...'),
    ),
  );
  Navigator.of(context).pop();
}

void _viewProfile(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const UserProfilePage(),
    ),
  );
}
