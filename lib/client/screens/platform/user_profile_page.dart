import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/client/users.dart';
import '../../widgets/account_menu.dart';

class UserProfilePage extends ConsumerWidget {
  final UserModel user;

  const UserProfilePage({required this.user, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        actions: [],
      ),
      body: _buildUserProfile(user),
    );
  }

  // Example method to view the profile
  void _viewProfile(BuildContext context, UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewProfilePage(user: user),
      ),
    );
  }

  // Example method to edit settings
  void _editSettings(BuildContext context, UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditSettingsPage(user: user),
      ),
    );
  }

  // Example method to logout
  void _logout(BuildContext context) {
    // Handle logout logic here
    Navigator.of(context).pop();
  }

  // Method to build the user profile view
  Widget _buildUserProfile(UserModel user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name: ${user.name}', style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Text('Email: ${user.email}', style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Text('Phone: ${user.phoneNumber}', style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Text('Country: ${user.country}', style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Text('Job Title: ${user.jobTitle}', style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Text('Business: ${user.businessName}',
              style: TextStyle(fontSize: 18)),
          SizedBox(height: 20),
          Text('Subscription: ${user.subscriptionType}',
              style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Text('Total Paid: \$${user.totalPaid}',
              style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}

class ViewProfilePage extends StatelessWidget {
  final UserModel user;

  const ViewProfilePage({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('View Profile')),
      body: Center(child: Text('Profile details for ${user.name}')),
    );
  }
}

class EditSettingsPage extends StatelessWidget {
  final UserModel user;

  const EditSettingsPage({required this.user, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Settings')),
      body: Center(child: Text('Edit settings for ${user.name}')),
    );
  }
}
