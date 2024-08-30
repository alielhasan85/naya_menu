import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_notifier.dart';
import '../../theme/app_theme.dart';

class UserProfileNavigationRail extends ConsumerWidget {
  const UserProfileNavigationRail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSection = ref.watch(selectedProfileSectionProvider);

    return Row(
      children: [
        NavigationRail(
          backgroundColor: AppTheme.background,
          extended: ref.watch(isNavigationRailExpandedProvider),
          selectedIndex: _getSelectedIndex(selectedSection),
          onDestinationSelected: (int index) {
            _handleDestinationSelected(index, ref);
          },
          destinations: [
            NavigationRailDestination(
              icon: Icon(Icons.person, color: AppTheme.iconTheme.color),
              label: Text('Profile', style: AppTheme.textTheme.bodyLarge),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.notifications, color: AppTheme.iconTheme.color),
              label: Text('Notifications', style: AppTheme.textTheme.bodyLarge),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.group, color: AppTheme.iconTheme.color),
              label: Text('Teams', style: AppTheme.textTheme.bodyLarge),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.subscriptions, color: AppTheme.iconTheme.color),
              label: Text('Subscriptions', style: AppTheme.textTheme.bodyLarge),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.receipt, color: AppTheme.iconTheme.color),
              label: Text('Invoices & Billing',
                  style: AppTheme.textTheme.bodyLarge),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.credit_card, color: AppTheme.iconTheme.color),
              label: Text('Card', style: AppTheme.textTheme.bodyLarge),
            ),
          ],
        ),
        const VerticalDivider(
          color: AppTheme.accentColor,
          thickness: 1,
          width: 1,
        )
      ],
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
