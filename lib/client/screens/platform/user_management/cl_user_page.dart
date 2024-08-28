import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/client/users.dart';
import '../../../../theme/app_theme.dart';
import 'user_notifier.dart';

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('User Profile', style: AppTheme.textTheme.headlineSmall),
          backgroundColor: AppTheme.appBarTheme.backgroundColor,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile', style: AppTheme.textTheme.headlineSmall),
        backgroundColor: AppTheme.appBarTheme.backgroundColor,
      ),
      body: _buildUserProfile(user),
    );
  }

  Widget _buildUserProfile(UserModel user) {
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
          const SizedBox(height: 20),
          Text('Subscription: ${user.subscriptionType}',
              style: AppTheme.textTheme.bodyLarge),
          const SizedBox(height: 10),
          Text('Total Paid: \$${user.totalPaid}',
              style: AppTheme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
