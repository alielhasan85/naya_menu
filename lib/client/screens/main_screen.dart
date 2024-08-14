import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/client/widgets/input_fields.dart';

// State provider to manage the current selected section
final selectedSectionProvider = StateProvider<String>((ref) => 'Dashboard');

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSection = ref.watch(selectedSectionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Platform Name"), // Replace with your platform name
        actions: [
          // Search Field
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: SizedBox(
              width: 300,
              child: InputField(
                label: '',
                hintText: 'Search...',
                controller: TextEditingController(),
              ),
            ),
          ),
          // Icon Button
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification icon button press
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Navigation Drawer
          NavigationDrawer(ref: ref),

          // Content Area
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
}

class NavigationDrawer extends StatelessWidget {
  final WidgetRef ref;

  const NavigationDrawer({required this.ref, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Navigation',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          _createDrawerItem(
              icon: Icons.dashboard,
              text: 'Dashboard',
              onTap: () => ref.read(selectedSectionProvider.notifier).state =
                  'Dashboard'),
          _createDrawerItem(
              icon: Icons.report,
              text: 'Report',
              onTap: () =>
                  ref.read(selectedSectionProvider.notifier).state = 'Report'),
          _createDrawerItem(
              icon: Icons.recommend,
              text: 'Recommendation',
              onTap: () => ref.read(selectedSectionProvider.notifier).state =
                  'Recommendation'),
          _createDrawerItem(
              icon: Icons.shopping_cart,
              text: 'Orders',
              onTap: () =>
                  ref.read(selectedSectionProvider.notifier).state = 'Orders'),
          _createDrawerItem(
              icon: Icons.restaurant,
              text: 'Reservation',
              onTap: () => ref.read(selectedSectionProvider.notifier).state =
                  'Reservation'),
          _createDrawerItem(
              icon: Icons.group,
              text: 'Engagement',
              onTap: () => ref.read(selectedSectionProvider.notifier).state =
                  'Engagement'),
          _createDrawerItem(
              icon: Icons.menu,
              text: 'Menu Management',
              onTap: () => ref.read(selectedSectionProvider.notifier).state =
                  'Menu Management'),
          _createDrawerItem(
              icon: Icons.feedback,
              text: 'Feedback',
              onTap: () => ref.read(selectedSectionProvider.notifier).state =
                  'Feedback'),
          _createDrawerItem(
              icon: Icons.translate,
              text: 'Translation Center',
              onTap: () => ref.read(selectedSectionProvider.notifier).state =
                  'Translation Center'),
          _createDrawerItem(
              icon: Icons.store,
              text: 'Marketplace',
              onTap: () => ref.read(selectedSectionProvider.notifier).state =
                  'Marketplace'),
          _createDrawerItem(
              icon: Icons.settings,
              text: 'Settings',
              onTap: () => ref.read(selectedSectionProvider.notifier).state =
                  'Settings'),
        ],
      ),
    );
  }

  ListTile _createDrawerItem(
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}

class SectionContent extends StatelessWidget {
  final String selectedSection;

  const SectionContent({required this.selectedSection, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (selectedSection) {
      case 'Dashboard':
        return Center(child: Text('Dashboard Content'));
      case 'Report':
        return Center(child: Text('Report Content'));
      case 'Recommendation':
        return Center(child: Text('Recommendation Content'));
      case 'Orders':
        return Center(child: Text('Orders Content'));
      case 'Reservation':
        return Center(child: Text('Reservation Content'));
      case 'Engagement':
        return Center(child: Text('Engagement Content'));
      case 'Menu Management':
        return Center(child: Text('Menu Management Content'));
      case 'Feedback':
        return Center(child: Text('Feedback Content'));
      case 'Translation Center':
        return Center(child: Text('Translation Center Content'));
      case 'Marketplace':
        return Center(child: Text('Marketplace Content'));
      case 'Settings':
        return Center(child: Text('Settings Content'));
      default:
        return Center(child: Text('Unknown Section'));
    }
  }
}
