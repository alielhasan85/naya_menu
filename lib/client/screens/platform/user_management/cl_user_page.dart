import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/client/screens/platform/user_management/cl_user_navigation.dart';
import '../../../../models/client/users.dart';
import '../../../../theme/app_theme.dart';
import 'user_notifier.dart';

final selectedProfileSectionProvider =
    StateProvider<String>((ref) => 'Profile');

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final selectedSection = ref.watch(selectedProfileSectionProvider);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title:
              Text('Account Settings', style: AppTheme.textTheme.headlineSmall),
          backgroundColor: AppTheme.appBarTheme.backgroundColor,
          actions: [
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title:
            Text('Account Settings', style: AppTheme.textTheme.headlineSmall),
        backgroundColor: AppTheme.appBarTheme.backgroundColor,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Row(
        children: [
          const UserProfileNavigationRail(), // Use the new widget here
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _buildSectionContent(selectedSection, user),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationRail(WidgetRef ref) {
    final selectedSection = ref.watch(selectedProfileSectionProvider);

    return NavigationRail(
      selectedIndex: _getSelectedIndex(selectedSection),
      onDestinationSelected: (int index) {
        _handleDestinationSelected(index, ref);
      },
      destinations: const [
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

  Widget _buildSectionContent(String selectedSection, UserModel user) {
    switch (selectedSection) {
      case 'Profile':
        return _buildProfileTab(user);
      case 'Notifications':
        return _buildNotificationsTab();
      case 'Teams':
        return _buildTeamsTab();
      case 'Subscriptions':
        return _buildSubscriptionsTab();
      case 'Invoices & Billing':
        return _buildInvoicesBillingTab();
      case 'Card':
        return _buildCardTab();
      default:
        return _buildProfileTab(user);
    }
  }

  Widget _buildProfileTab(UserModel user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name: ${user.name}', style: AppTheme.textTheme.bodyLarge),
          const SizedBox(height: 10),
          Text('Email: ${user.email}', style: AppTheme.textTheme.bodyLarge),
          const SizedBox(height: 10),
          Text('Phone: ${user.phoneNumber}',
              style: AppTheme.textTheme.bodyLarge),
          const SizedBox(height: 10),
          Text('Country: ${user.country}', style: AppTheme.textTheme.bodyLarge),
          const SizedBox(height: 10),
          Text('Job Title: ${user.jobTitle}',
              style: AppTheme.textTheme.bodyLarge),
          const SizedBox(height: 10),
          Text('Business: ${user.businessName}',
              style: AppTheme.textTheme.bodyLarge),
        ],
      ),
    );
  }

  Widget _buildNotificationsTab() {
    return Center(
        child: Text('Notifications Settings',
            style: AppTheme.textTheme.headlineSmall));
  }

  Widget _buildTeamsTab() {
    return Center(
        child:
            Text('Teams Management', style: AppTheme.textTheme.headlineSmall));
  }

  Widget _buildSubscriptionsTab() {
    return Center(
        child: Text('Subscription Details',
            style: AppTheme.textTheme.headlineSmall));
  }

  Widget _buildInvoicesBillingTab() {
    return Center(
        child: Text('Invoices & Billing',
            style: AppTheme.textTheme.headlineSmall));
  }

  Widget _buildCardTab() {
    return Center(
        child:
            Text('Card Management', style: AppTheme.textTheme.headlineSmall));
  }
}
