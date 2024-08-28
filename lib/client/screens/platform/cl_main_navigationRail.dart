import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cl_main_page.dart';

// State provider to manage the expansion of the Settings dropdown
final isSettingsExpandedProvider = StateProvider<bool>((ref) => false);

class NavigationRailWidget extends ConsumerWidget {
  const NavigationRailWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNavigationRailExpanded =
        ref.watch(isNavigationRailExpandedProvider);
    final isSettingsExpanded = ref.watch(isSettingsExpandedProvider);

    return NavigationRail(
      extended: isNavigationRailExpanded,
      selectedIndex: _getSelectedIndex(ref),
      onDestinationSelected: (int index) {
        if (index == 10) {
          // Assuming 10 is the index of the "Settings"
          ref.read(isSettingsExpandedProvider.notifier).state =
              !isSettingsExpanded;
        } else {
          _handleDestinationSelected(index, ref);
        }
      },
      destinations: _buildDestinations(ref, isSettingsExpanded),
    );
  }

  List<NavigationRailDestination> _buildDestinations(
      WidgetRef ref, bool isSettingsExpanded) {
    List<NavigationRailDestination> destinations = [
      const NavigationRailDestination(
        icon: Icon(Icons.dashboard),
        label: Text('Dashboard'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.report),
        label: Text('Report'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.recommend),
        label: Text('Recommendation'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.shopping_cart),
        label: Text('Orders'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.restaurant),
        label: Text('Reservation'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.group),
        label: Text('Engagement'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.menu),
        label: Text('Menu Management'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.feedback),
        label: Text('Feedback'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.translate),
        label: Text('Translation Center'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.store),
        label: Text('Marketplace'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.settings),
        label: Row(children: [
          Text('Settings'),
          SizedBox(
            width: 5,
          ),
          isSettingsExpanded
              ? Icon(
                  Icons.arrow_downward_outlined,
                  size: 15,
                )
              : Icon(
                  Icons.arrow_upward_outlined,
                  size: 15,
                )
        ]),
      ),
    ];

    if (isSettingsExpanded) {
      destinations.addAll([
        const NavigationRailDestination(
          icon: Padding(
              padding: EdgeInsets.only(left: 20.0), child: Icon(Icons.info)),
          label: Text('Venue Information'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.build),
          label: Text('Operations'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.design_services),
          label: Text('Design and Display'),
        ),
      ]);
    }

    return destinations;
  }

  int _getSelectedIndex(WidgetRef ref) {
    final selectedSection = ref.watch(selectedSectionProvider);
    final isSettingsExpanded = ref.watch(isSettingsExpandedProvider);

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
        return 10; // The base Settings item
      case 'Settings/Venue Information':
        return isSettingsExpanded
            ? 11
            : 10; // Adjust based on whether Settings is expanded
      case 'Settings/Operations':
        return isSettingsExpanded ? 12 : 10;
      case 'Settings/Design and Display':
        return isSettingsExpanded ? 13 : 10;
      default:
        return 0;
    }
  }

  void _handleDestinationSelected(int index, WidgetRef ref) {
    final isSettingsExpanded = ref.read(isSettingsExpandedProvider);

    if (isSettingsExpanded && index >= 11 && index <= 13) {
      switch (index) {
        case 11:
          ref.read(selectedSectionProvider.notifier).state =
              'Settings/Venue Information';
          break;
        case 12:
          ref.read(selectedSectionProvider.notifier).state =
              'Settings/Operations';
          break;
        case 13:
          ref.read(selectedSectionProvider.notifier).state =
              'Settings/Design and Display';
          break;
      }
    } else {
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
          ref.read(selectedSectionProvider.notifier).state =
              'Translation Center';
          break;
        case 9:
          ref.read(selectedSectionProvider.notifier).state = 'Marketplace';
          break;
        case 10:
          ref.read(selectedSectionProvider.notifier).state = 'Settings';
          break;
      }
    }
  }
}
