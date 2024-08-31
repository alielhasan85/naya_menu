import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:naya_menu/client_app/notifier.dart';
import '../../theme/app_theme.dart'; // Import your theme

class ProfileMenu extends ConsumerWidget {
  final ValueChanged<int> onChange; // Callback for item selection

  const ProfileMenu({super.key, required this.onChange});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access the user data
    final user = ref.watch(userProvider);

    return PopupMenuButton<int>(
      icon: Icon(
        Icons.account_circle, // Profile icon
        color: AppTheme.iconTheme.color, // Use icon color from AppTheme
      ),
      color: AppTheme.chipBackground, // Menu background color from AppTheme
      onSelected: onChange, // Trigger the callback when an item is selected
      offset: const Offset(-10, 50), // Adjust the position of the popup
      itemBuilder: (context) => [
        if (user != null)
          PopupMenuItem<int>(
            value: 0,
            child: Text('Hello, ${user.name}',
                style: AppTheme.textTheme.bodyMedium),
          ),
        ..._buildMenuItems(), // Build other menu items
      ],
    );
  }

  // Method to build the list of menu items
  List<PopupMenuEntry<int>> _buildMenuItems() {
    return [
      _buildMenuItem(1, Icons.person, 'Account Settings'),
      _buildMenuItem(2, Icons.notifications, 'Notifications'),
      _buildMenuItem(3, Icons.language, 'Change Language'),
      _buildMenuItem(4, Icons.help_center, 'Help Center'),
      _buildMenuItem(5, Icons.exit_to_app, 'Sign Out'),
    ];
  }

  // Method to build a single menu item
  PopupMenuItem<int> _buildMenuItem(int value, IconData icon, String text) {
    return PopupMenuItem<int>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: AppTheme.iconTheme.color),
          const SizedBox(width: 10),
          Text(text, style: AppTheme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
