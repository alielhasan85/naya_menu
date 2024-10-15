import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/client_app/user_management/cl_profile_tab.dart';
import 'package:naya_menu/client_app/user_management/cl_user_profile_navigation.dart';
import 'package:naya_menu/client_app/widgets/cl_user_app_bar.dart';
import 'package:naya_menu/models/client/users.dart';
import '../../theme/app_theme.dart';
import '../notifier.dart';

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final isNavigationRailExpanded =
        ref.watch(isNavigationRailExpandedProvider);
    final selectedSection = ref.watch(selectedProfileSectionProvider);

    if (user == null) {
      return Scaffold(
        appBar: CustomAppBar(
          title: 'User Profile',
          actions: [
            IconButton(
              tooltip: 'Close',
              icon: Icon(Icons.close, color: AppTheme.iconTheme.color),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'User Profile',
        actions: [
          IconButton(
            tooltip: 'Close',
            icon: Icon(Icons.close, color: AppTheme.iconTheme.color),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Row(
        children: [
          const UserProfileNavigationRail(), // Moved to separate file
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    tooltip: isNavigationRailExpanded ? 'Collapse' : 'Expand',
                    icon: Icon(
                      isNavigationRailExpanded
                          ? Icons.keyboard_arrow_left
                          : Icons.keyboard_arrow_right,
                      color: AppTheme.iconTheme.color,
                    ),
                    onPressed: () {
                      ref
                          .read(isNavigationRailExpandedProvider.notifier)
                          .state = !isNavigationRailExpanded;
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildSectionContent(selectedSection, user),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContent(String selectedSection, UserModel user) {
    switch (selectedSection) {
      case 'Profile':
        return const ProfileTab(); // Keep ProfileTab as a separate widget
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
        return const ProfileTab();
    }
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
