import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/client/screens/platform/cl-venueinfo.dart';
import 'package:naya_menu/client/screens/platform/cl_drawer.dart';
import 'package:naya_menu/client/widgets/account_menu.dart';
import 'package:naya_menu/client/widgets/input_fields.dart';

// Providers to manage the selected section and text visibility
final selectedSectionProvider = StateProvider<String>((ref) => 'Dashboard');
final isDrawerExpandedProvider = StateProvider<bool>((ref) => true);

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final isDrawerExpanded = ref.watch(isDrawerExpandedProvider);
    final selectedSection = ref.watch(selectedSectionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Platform Name"),
        actions: [
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
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification icon button press
            },
          ),

          /// nice drop down menu to be used for account setting control
          SimpleAccountMenu(
              onChange: (index) {
                print(index);
              },
              icons: const [
                Icon(Icons.person),
                Icon(Icons.settings),
                Icon(Icons.credit_card),
              ]),
        ],
      ),
      body: Row(
        children: [
          // Drawer
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            // width: 200, //isDrawerExpanded ? 250 : 70,
            child: const ClDrawer(),
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
}

class SectionContent extends StatelessWidget {
  final String selectedSection;

  const SectionContent({required this.selectedSection, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (selectedSection.startsWith('Settings')) {
      return _buildSettingsContent();
    }

    switch (selectedSection) {
      case 'Dashboard':
        return Center(child: Text('Dashboard Content'));
      case 'Report':
        return Center(child: Text('Report Content'));
      // Other cases...
      default:
        return Center(child: Text('Unknown Section'));
    }
  }

  Widget _buildSettingsContent() {
    switch (selectedSection) {
      case 'Settings/Venue Information':
        return VenueInformationPage();
      case 'Settings/Design and Display':
        return Center(child: Text('Design and Display Content'));
      case 'Settings/Operations':
        return Center(child: Text('Operations Content'));
      default:
        return Center(child: Text('Select a Setting'));
    }
  }
}
