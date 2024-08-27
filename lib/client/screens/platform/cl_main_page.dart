import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/client/screens/platform/section_content.dart';
import 'package:naya_menu/client/screens/platform/user_profile_page.dart';
import 'package:naya_menu/service/firebase/firestore_user.dart';
import '../../../models/client/users.dart';
import '../../widgets/account_menu.dart';
import '../../widgets/navigationRail.dart';

final selectedSectionProvider = StateProvider<String>((ref) => 'Dashboard');
final isNavigationRailExpandedProvider = StateProvider<bool>((ref) => true);

// Update to use FutureProvider.family to accept userId as a parameter
final userProvider =
    FutureProvider.family<UserModel?, String>((ref, userId) async {
  return FirestoreUser().getUserById(userId);
});

class MainPage extends ConsumerWidget {
  final String userId;

  const MainPage({required this.userId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSection = ref.watch(selectedSectionProvider);
    final isNavigationRailExpanded =
        ref.watch(isNavigationRailExpandedProvider);
    final userAsyncValue =
        ref.watch(userProvider(userId)); // Pass userId to provider

    return Scaffold(
      appBar: AppBar(
        title: const Text("Platform Name"),
        actions: [
          _buildSearchField(),
          SizedBox(width: 20),
          _buildNotificationButton(),
          SizedBox(width: 20),
          // Handle the AsyncValue state for the user
          userAsyncValue.when(
            data: (user) => SimpleAccountMenu(
              onChange: (index) {
                switch (index) {
                  case 0:
                    _viewProfile(context, user); // Open UserProfilePage
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
            ),
            loading: () => CircularProgressIndicator(),
            error: (error, stack) => Text('Error loading user'),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Row(
        children: [
          NavigationRailWidget(), // Extracted to its own widget
          const VerticalDivider(thickness: 1, width: 1),
          Column(
            children: [
              IconButton(
                icon: Icon(isNavigationRailExpanded
                    ? Icons.keyboard_arrow_left
                    : Icons.keyboard_arrow_right),
                onPressed: () {
                  ref.read(isNavigationRailExpandedProvider.notifier).state =
                      !isNavigationRailExpanded;
                },
              ),
            ],
          ),
          // Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SectionContent(selectedSection: selectedSection),
            ),
          ),
        ],
      ),
    );
  }

  void _viewProfile(BuildContext context, UserModel? user) {
    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserProfilePage(user: user),
        ),
      );
    }
  }

  void _openSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPage(),
      ),
    );
  }

  void _logout(BuildContext context) {
    // Handle the logout logic here
    Navigator.of(context).pop(); // Example: return to login screen
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
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationButton() {
    return IconButton(
      icon: const Icon(Icons.notifications),
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
        title: Text('Settings'),
      ),
      body: Center(
        child: Text('Settings Details'),
      ),
    );
  }
}

// Opens the Notifications page (to be implemented later)
void _openNotifications(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Notifications feature is under development.'),
    ),
  );
  // Later, you can implement the actual navigation to the Notifications page here.
  // Navigator.push(
  //   context,
  //   MaterialPageRoute(builder: (context) => NotificationsPage()),
  // );
}

// Opens the Change Language dialog or page (to be implemented later)
void _changeLanguage(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Change Language feature is under development.'),
    ),
  );
  // Later, you can implement the actual logic to change the language here.
  // For example, showing a dialog to select the language.
  // showDialog(
  //   context: context,
  //   builder: (context) => ChangeLanguageDialog(),
  // );
}

// Opens the Help Center page (to be implemented later)
void _openHelpCenter(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Help Center is under development.'),
    ),
  );
  // Later, you can implement the actual navigation to the Help Center page here.
  // Navigator.push(
  //   context,
  //   MaterialPageRoute(builder: (context) => HelpCenterPage()),
  // );
}

// Logs out the user (to be implemented later)
void _logout(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Logging out...'),
    ),
  );
  // Implement actual logout logic here. For now, we just pop to simulate logout.
  // In the future, use FirebaseAuth or other authentication methods to sign out.
  Navigator.of(context).pop();
}
