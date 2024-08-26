import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/client/screens/platform/section_content.dart';

import '../../widgets/navigationRail.dart';

final selectedSectionProvider = StateProvider<String>((ref) => 'Dashboard');
final isNavigationRailExpandedProvider = StateProvider<bool>((ref) => true);

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSection = ref.watch(selectedSectionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Platform Name"),
        actions: [
          _buildSearchField(),
          _buildNotificationButton(),
        ],
      ),
      body: Row(
        children: [
          NavigationRailWidget(), // Extracted to its own widget
          const VerticalDivider(thickness: 1, width: 1),
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
