import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Providers to manage the selected section and text visibility
final selectedSectionProvider = StateProvider<String>((ref) => 'Dashboard');
final isDrawerExpandedProvider = StateProvider<bool>((ref) => true);

class ClDrawer extends ConsumerWidget {
  const ClDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDrawerExpanded = ref.watch(isDrawerExpandedProvider);

    return Drawer(
      width: isDrawerExpanded ? 250 : 80, // Adjust the width of the drawer
      child: Column(
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isDrawerExpanded)
                  const Text(
                    'Navigation',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.menu),
                  color: Colors.white,
                  onPressed: () {
                    ref.read(isDrawerExpandedProvider.notifier).state =
                        !isDrawerExpanded;
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _createDrawerItem(
                    icon: Icons.dashboard,
                    text: 'Dashboard',
                    onTap: () => ref
                        .read(selectedSectionProvider.notifier)
                        .state = 'Dashboard',
                    isSelected:
                        ref.watch(selectedSectionProvider) == 'Dashboard',
                    isTextVisible: isDrawerExpanded),
                _createDrawerItem(
                    icon: Icons.report,
                    text: 'Report',
                    onTap: () => ref
                        .read(selectedSectionProvider.notifier)
                        .state = 'Report',
                    isSelected: ref.watch(selectedSectionProvider) == 'Report',
                    isTextVisible: isDrawerExpanded),
                _createDrawerItem(
                    icon: Icons.recommend,
                    text: 'Recommendation',
                    onTap: () => ref
                        .read(selectedSectionProvider.notifier)
                        .state = 'Recommendation',
                    isSelected:
                        ref.watch(selectedSectionProvider) == 'Recommendation',
                    isTextVisible: isDrawerExpanded),
                _createDrawerItem(
                    icon: Icons.shopping_cart,
                    text: 'Orders',
                    onTap: () => ref
                        .read(selectedSectionProvider.notifier)
                        .state = 'Orders',
                    isSelected: ref.watch(selectedSectionProvider) == 'Orders',
                    isTextVisible: isDrawerExpanded),
                _createDrawerItem(
                    icon: Icons.restaurant,
                    text: 'Reservation',
                    onTap: () => ref
                        .read(selectedSectionProvider.notifier)
                        .state = 'Reservation',
                    isSelected:
                        ref.watch(selectedSectionProvider) == 'Reservation',
                    isTextVisible: isDrawerExpanded),
                _createDrawerItem(
                    icon: Icons.group,
                    text: 'Engagement',
                    onTap: () => ref
                        .read(selectedSectionProvider.notifier)
                        .state = 'Engagement',
                    isSelected:
                        ref.watch(selectedSectionProvider) == 'Engagement',
                    isTextVisible: isDrawerExpanded),
                _createDrawerItem(
                    icon: Icons.menu,
                    text: 'Menu Management',
                    onTap: () => ref
                        .read(selectedSectionProvider.notifier)
                        .state = 'Menu Management',
                    isSelected:
                        ref.watch(selectedSectionProvider) == 'Menu Management',
                    isTextVisible: isDrawerExpanded),
                _createDrawerItem(
                    icon: Icons.feedback,
                    text: 'Feedback',
                    onTap: () => ref
                        .read(selectedSectionProvider.notifier)
                        .state = 'Feedback',
                    isSelected:
                        ref.watch(selectedSectionProvider) == 'Feedback',
                    isTextVisible: isDrawerExpanded),
                _createDrawerItem(
                    icon: Icons.translate,
                    text: 'Translation Center',
                    onTap: () => ref
                        .read(selectedSectionProvider.notifier)
                        .state = 'Translation Center',
                    isSelected: ref.watch(selectedSectionProvider) ==
                        'Translation Center',
                    isTextVisible: isDrawerExpanded),
                _createDrawerItem(
                    icon: Icons.store,
                    text: 'Marketplace',
                    onTap: () => ref
                        .read(selectedSectionProvider.notifier)
                        .state = 'Marketplace',
                    isSelected:
                        ref.watch(selectedSectionProvider) == 'Marketplace',
                    isTextVisible: isDrawerExpanded),
                _createDrawerItem(
                    icon: Icons.settings,
                    text: 'Settings',
                    onTap: () => ref
                        .read(selectedSectionProvider.notifier)
                        .state = 'Settings',
                    isSelected:
                        ref.watch(selectedSectionProvider) == 'Settings',
                    isTextVisible: isDrawerExpanded),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required VoidCallback onTap,
      required bool isSelected,
      required bool isTextVisible}) {
    return ListTile(
      selected: isSelected,
      leading: Icon(icon, color: isSelected ? Colors.blue : null),
      title: isTextVisible ? Text(text) : null,
      onTap: onTap,
    );
  }
}
