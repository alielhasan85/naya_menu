import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/client_app/main_page/cl_leading_widget_navigation.dart';
import 'package:naya_menu/client_app/notifier.dart';
import '../../theme/app_theme.dart';

class NavigationRailWidget extends ConsumerWidget {
  const NavigationRailWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSettingsExpanded = ref.watch(isSettingsExpandedProvider);
    final selectedSection = ref.watch(selectedSectionProvider);
    final isNavigationRailExpanded =
        ref.watch(isNavigationRailExpandedProvider);

    final destinations = _buildDestinations(context, isSettingsExpanded);

    return LayoutBuilder(
      builder: (context, constraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
              child: NavigationRail(
                backgroundColor: AppTheme.background,
                leading: isNavigationRailExpanded
                    ? const ClLeadingWidgetNavigation() // Show the custom widget when expanded
                    : IconButton(
                        icon: const Icon(Icons.store),
                        color: AppTheme.primaryColor, // Apply theme color
                        onPressed: () {
                          // Toggle navigation rail expansion state
                          ref
                              .read(isNavigationRailExpandedProvider.notifier)
                              .state = true;
                        },
                      ),
                // to be developped to be dynamics
                extended: isNavigationRailExpanded,
                selectedIndex:
                    _getSelectedIndex(ref, selectedSection, isSettingsExpanded),
                onDestinationSelected: (int index) {
                  _handleDestinationSelected(index, ref, isSettingsExpanded);
                },
                destinations: destinations,
              ),
            ),
          ),
        );
      },
    );
  }

  List<NavigationRailDestination> _buildDestinations(
      context, bool isSettingsExpanded) {
    List<NavigationRailDestination> destinations = [
      NavigationRailDestination(
        icon: Icon(
          Icons.dashboard,
          color: AppTheme.iconTheme.color,
        ),
        label: Text(
          'Dashboard',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
        ),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.report, color: AppTheme.iconTheme.color),
        label: Text('Report',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.recommend, color: AppTheme.iconTheme.color),
        label: Text('Recommendation'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.shopping_cart, color: AppTheme.iconTheme.color),
        label: Text('Orders'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.restaurant, color: AppTheme.iconTheme.color),
        label: Text('Reservation'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.group, color: AppTheme.iconTheme.color),
        label: Text('Engagement'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.menu, color: AppTheme.iconTheme.color),
        label: Text('Menu Management'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.feedback, color: AppTheme.iconTheme.color),
        label: Text('Feedback'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.translate, color: AppTheme.iconTheme.color),
        label: Text('Translation Center'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.store, color: AppTheme.iconTheme.color),
        label: Text('Marketplace'),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.settings),
        label: Row(
          children: [
            const Text('Settings'),
            const SizedBox(width: 5),
            Icon(
              isSettingsExpanded ? Icons.arrow_upward : Icons.arrow_downward,
              size: 15,
            ),
          ],
        ),
      ),
    ];

    if (isSettingsExpanded) {
      destinations.addAll([
        const NavigationRailDestination(
          icon: Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Icon(Icons.info),
          ),
          label: Text('Venue Information'),
        ),
        const NavigationRailDestination(
          icon: Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Icon(Icons.build),
          ),
          label: Text('Operations'),
        ),
        const NavigationRailDestination(
          icon: Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Icon(Icons.design_services),
          ),
          label: Text('Design and Display'),
        ),
      ]);
    }

    return destinations;
  }

  int _getSelectedIndex(
    WidgetRef ref,
    String selectedSection,
    bool isSettingsExpanded,
  ) {
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
        return isSettingsExpanded ? 11 : 10;
      case 'Settings/Operations':
        return isSettingsExpanded ? 12 : 10;
      case 'Settings/Design and Display':
        return isSettingsExpanded ? 13 : 10;
      default:
        return 0;
    }
  }

  void _handleDestinationSelected(
    int index,
    WidgetRef ref,
    bool isSettingsExpanded,
  ) {
    if (index == 10) {
      ref.read(isSettingsExpandedProvider.notifier).state = !isSettingsExpanded;
    } else {
      if (isSettingsExpanded && index >= 11) {
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
            ref.read(selectedSectionProvider.notifier).state =
                'Menu Management';
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
        }
      }
    }
  }
}
