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
    final selectedSection = ref.watch(selectedSectionProvider);
    final isSettingsExpanded = selectedSection.startsWith('Settings');

    return Drawer(
      width: isDrawerExpanded ? 250 : 80,
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
                DrawerItem(
                  icon: Icons.dashboard,
                  text: 'Dashboard',
                  section: 'Dashboard',
                  ref: ref,
                ),
                DrawerItem(
                  icon: Icons.report,
                  text: 'Report',
                  section: 'Report',
                  ref: ref,
                ),
                DrawerItem(
                  icon: Icons.recommend,
                  text: 'Recommendation',
                  section: 'Recommendation',
                  ref: ref,
                ),
                DrawerItem(
                  icon: Icons.shopping_cart,
                  text: 'Orders',
                  section: 'Orders',
                  ref: ref,
                ),
                DrawerItem(
                  icon: Icons.restaurant,
                  text: 'Reservation',
                  section: 'Reservation',
                  ref: ref,
                ),
                DrawerItem(
                  icon: Icons.group,
                  text: 'Engagement',
                  section: 'Engagement',
                  ref: ref,
                ),
                DrawerItem(
                  icon: Icons.menu,
                  text: 'Menu Management',
                  section: 'Menu Management',
                  ref: ref,
                ),
                DrawerItem(
                  icon: Icons.feedback,
                  text: 'Feedback',
                  section: 'Feedback',
                  ref: ref,
                ),
                DrawerItem(
                  icon: Icons.translate,
                  text: 'Translation Center',
                  section: 'Translation Center',
                  ref: ref,
                ),
                DrawerItem(
                  icon: Icons.store,
                  text: 'Marketplace',
                  section: 'Marketplace',
                  ref: ref,
                ),
                ExpansionTile(
                  leading: Icon(Icons.settings,
                      color: isSettingsExpanded ? Colors.blue : null),
                  title: Text('Settings'),

                  //
                  initiallyExpanded: isSettingsExpanded,
                  children: [
                    DrawerItem(
                      icon: Icons.info,
                      text: 'Venue Information',
                      section: 'Settings/Venue Information',
                      ref: ref,
                    ),
                    DrawerItem(
                      icon: Icons.design_services,
                      text: 'Design and Display',
                      section: 'Settings/Design and Display',
                      ref: ref,
                    ),
                    DrawerItem(
                      icon: Icons.build,
                      text: 'Operations',
                      section: 'Settings/Operations',
                      ref: ref,
                    ),
                  ],
                  onExpansionChanged: (bool expanded) {
                    if (!expanded && selectedSection.startsWith('Settings')) {
                      ref.read(selectedSectionProvider.notifier).state = '';
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final String section;
  final WidgetRef ref;

  const DrawerItem({
    required this.icon,
    required this.text,
    required this.section,
    required this.ref,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDrawerExpanded = ref.watch(isDrawerExpandedProvider);
    final isSelected = ref.watch(selectedSectionProvider) == section;

    return ListTile(
      selected: isSelected,
      leading: Icon(icon, color: isSelected ? Colors.blue : null),
      title: isDrawerExpanded ? Text(text) : null,
      onTap: () {
        ref.read(selectedSectionProvider.notifier).state = section;
      },
    );
  }
}
