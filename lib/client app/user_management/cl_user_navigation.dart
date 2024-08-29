import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/client%20app/user_management/cl_user_page.dart';
import 'package:naya_menu/client%20app/widgets/cl_navigationrail_widget.dart';

class UserProfileNavigationRail extends ConsumerWidget {
  const UserProfileNavigationRail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSection = ref.watch(selectedProfileSectionProvider);

    final destinations = const [
      NavigationRailDestination(
        icon: Icon(Icons.person),
        label: Text('Profile'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.notifications),
        label: Text('Notifications'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.group),
        label: Text('Teams'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.subscriptions),
        label: Text('Subscriptions'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.receipt),
        label: Text('Invoices & Billing'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.credit_card),
        label: Text('Card'),
      ),
    ];

    return CustomNavigationRail(
      destinations: destinations,
      selectedIndex: _getSelectedIndex(selectedSection),
      onDestinationSelected: (int index) {
        _handleDestinationSelected(index, ref);
      },
    );
  }

  int _getSelectedIndex(String selectedSection) {
    switch (selectedSection) {
      case 'Profile':
        return 0;
      case 'Notifications':
        return 1;
      case 'Teams':
        return 2;
      case 'Subscriptions':
        return 3;
      case 'Invoices & Billing':
        return 4;
      case 'Card':
        return 5;
      default:
        return 0;
    }
  }

  void _handleDestinationSelected(int index, WidgetRef ref) {
    switch (index) {
      case 0:
        ref.read(selectedProfileSectionProvider.notifier).state = 'Profile';
        break;
      case 1:
        ref.read(selectedProfileSectionProvider.notifier).state =
            'Notifications';
        break;
      case 2:
        ref.read(selectedProfileSectionProvider.notifier).state = 'Teams';
        break;
      case 3:
        ref.read(selectedProfileSectionProvider.notifier).state =
            'Subscriptions';
        break;
      case 4:
        ref.read(selectedProfileSectionProvider.notifier).state =
            'Invoices & Billing';
        break;
      case 5:
        ref.read(selectedProfileSectionProvider.notifier).state = 'Card';
        break;
    }
  }
}
