import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/client/screens/platform/cl-venueinfo.dart';

// Providers to manage the selected section and text visibility
final selectedSectionProvider = StateProvider<String>((ref) => 'Dashboard');
final isNavigationRailExpandedProvider = StateProvider<bool>((ref) => true);

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSection = ref.watch(selectedSectionProvider);
    final isNavigationRailExpanded =
        ref.watch(isNavigationRailExpandedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Platform Name"),
        actions: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: SizedBox(
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                  labelText: '',
                  hintText: 'Search...',
                ),
              ),
            ),
          ),
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
          // NavigationRail
          NavigationRail(
            extended: isNavigationRailExpanded,
            selectedIndex: _getSelectedIndex(selectedSection),
            onDestinationSelected: (int index) {
              _handleDestinationSelected(index, ref);
            },
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                ref.read(isNavigationRailExpandedProvider.notifier).state =
                    !isNavigationRailExpanded;
              },
            ),
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.report),
                label: Text('Report'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.recommend),
                label: Text('Recommendation'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.shopping_cart),
                label: Text('Orders'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.restaurant),
                label: Text('Reservation'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.group),
                label: Text('Engagement'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.menu),
                label: Text('Menu Management'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.feedback),
                label: Text('Feedback'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.translate),
                label: Text('Translation Center'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.store),
                label: Text('Marketplace'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
            ],
          ),
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

  int _getSelectedIndex(String selectedSection) {
    switch (selectedSection) {
      case 'Dashboard':
        return 0;
      case 'Report':
        return 1;
      case 'Recommendation':
        return 2;
      case 'Orders':
        return 3;
      case 'Reservation':
        return 4;
      case 'Engagement':
        return 5;
      case 'Menu Management':
        return 6;
      case 'Feedback':
        return 7;
      case 'Translation Center':
        return 8;
      case 'Marketplace':
        return 9;
      case 'Settings':
        return 10;
      case 'Settings/Venue Information':
      case 'Settings/Design and Display':
      case 'Settings/Operations':
        return 10;
      default:
        return 0;
    }
  }

  void _handleDestinationSelected(int index, WidgetRef ref) {
    switch (index) {
      case 0:
        ref.read(selectedSectionProvider.notifier).state = 'Dashboard';
        break;
      case 1:
        ref.read(selectedSectionProvider.notifier).state = 'Report';
        break;
      case 2:
        ref.read(selectedSectionProvider.notifier).state = 'Recommendation';
        break;
      case 3:
        ref.read(selectedSectionProvider.notifier).state = 'Orders';
        break;
      case 4:
        ref.read(selectedSectionProvider.notifier).state = 'Reservation';
        break;
      case 5:
        ref.read(selectedSectionProvider.notifier).state = 'Engagement';
        break;
      case 6:
        ref.read(selectedSectionProvider.notifier).state = 'Menu Management';
        break;
      case 7:
        ref.read(selectedSectionProvider.notifier).state = 'Feedback';
        break;
      case 8:
        ref.read(selectedSectionProvider.notifier).state = 'Translation Center';
        break;
      case 9:
        ref.read(selectedSectionProvider.notifier).state = 'Marketplace';
        break;
      case 10:
        ref.read(selectedSectionProvider.notifier).state = 'Settings';
        break;
      default:
        ref.read(selectedSectionProvider.notifier).state = 'Dashboard';
    }
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
