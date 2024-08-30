import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/client/users.dart';
import '../../theme/app_theme.dart';
import '../../service/firebase/firestore_user.dart';
import '../widgets/input_fields.dart';
import 'user_notifier.dart';

class ProfileTab extends ConsumerStatefulWidget {
  const ProfileTab({super.key});

  @override
  ConsumerState<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<ProfileTab> {
  late TextEditingController _nameController;
  late TextEditingController _jobTitleController;
  late TextEditingController _businessNameController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    _nameController = TextEditingController(text: user?.name ?? '');
    _jobTitleController = TextEditingController(text: user?.jobTitle ?? '');
    _businessNameController =
        TextEditingController(text: user?.businessName ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _jobTitleController.dispose();
    _businessNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text('Personal Information',
                  style: AppTheme.textTheme.titleSmall
                      ?.copyWith(fontSize: 18, fontWeight: FontWeight.w300)),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 500, // Fixed width of 500 pixels
                child: _buildPersonalInfoCard(context, user),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text('Login Information',
                  style: AppTheme.textTheme.titleSmall
                      ?.copyWith(fontSize: 18, fontWeight: FontWeight.w300)),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 500, // Fixed width of 500 pixels
                child: _buildLoginInfoCard(context, user),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoCard(BuildContext context, UserModel user) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputField(
              label: 'Name',
              controller: _nameController,
              labelAboveField: true,
            ),
            const SizedBox(height: 20),
            InputField(
              label: 'Job Title',
              controller: _jobTitleController,
              labelAboveField: true,
            ),
            const SizedBox(height: 20),
            InputField(
              label: 'Company Name',
              controller: _businessNameController,
              labelAboveField: true,
            ),
            const SizedBox(height: 20),
            _buildSaveButton(context, user),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginInfoCard(BuildContext context, UserModel user) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Email field (non-editable)
            InputField(
              label: 'Email',
              controller: TextEditingController(text: user.email),
              labelAboveField: true,
              keyboardType: TextInputType.emailAddress,
              onChanged: null, // Prevent editing
              validator: null,
              obscureText: false,
              textCapitalization: TextCapitalization.none,
              // Custom decoration to make it look non-editable
              decoration: InputDecoration(
                //labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabled: false, // Disables the input
                fillColor: Colors.grey[300],
                filled: true, // Background color to indicate non-editable
              ),
            ),
            const SizedBox(height: 20),

            // Phone number field with edit and verify buttons
            Row(
              children: [
                Expanded(
                  child: InputField(
                    label: 'Phone Number',
                    controller: TextEditingController(text: user.phoneNumber),
                    labelAboveField: true,
                    keyboardType: TextInputType.phone,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Handle edit phone number
                  },
                  style: AppTheme.buttonStyle,
                  child: const Text('Edit'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Handle verify phone number
                  },
                  style: AppTheme.buttonStyle,
                  child: const Text('Verify'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Password field (hidden) with change password button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InputField(
                    label: 'Password',
                    controller: TextEditingController(text: '********'),
                    labelAboveField: true,
                    obscureText: true,
                    onChanged: null, // Prevent editing
                    validator: null,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      // labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      enabled: false, // Disables the input
                      fillColor: Colors.grey[300],
                      filled: true, // Background color to indicate non-editable
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Handle change password
                  },
                  style: AppTheme.buttonStyle,
                  child: const Text('Change Password'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Save button
            _buildSaveButton(context, user),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, UserModel user) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () async {
          await _saveUserInfo(user);
        },
        style: AppTheme.buttonStyle,
        child: const Text('Save'),
      ),
    );
  }

  Future<void> _saveUserInfo(UserModel user) async {
    final updatedData = {
      'name': _nameController.text,
      'jobTitle': _jobTitleController.text,
      'businessName': _businessNameController.text,
    };

    await FirestoreUser().updateUser(user.id, updatedData);
    ref.read(userProvider.notifier).updateUserData(updatedData);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Changes saved successfully!')),
    );
  }
}
