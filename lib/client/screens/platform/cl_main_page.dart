import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

// SectionContent widget remains the same
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
