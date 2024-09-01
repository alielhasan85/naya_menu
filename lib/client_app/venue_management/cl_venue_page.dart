import 'package:flutter/material.dart';
import 'package:naya_menu/theme/app_theme.dart';
import '../widgets/input_fields.dart';

class VenueInformationPage extends StatelessWidget {
  const VenueInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Column(
        children: [
          Text(
            'Venue Information',
            style: AppTheme
                .appBarTheme.titleTextStyle, // Adjust the style as needed
          ),
          const SizedBox(height: 16.0), // Add spacing between title and card

          Expanded(
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    TabBar(
                      labelColor: Theme.of(context).primaryColor,
                      indicatorColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: 'Location'),
                        Tab(text: 'Language'),
                        Tab(text: 'Social Accounts'),
                      ],
                    ),
                    const Divider(
                      color: AppTheme.accentColor,
                      thickness: 1,
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Location settings content
                          LocationSettingsTab(),
                          // Language options content
                          LanguageOptionsTab(),
                          // Social accounts content
                          SocialAccountsTab(),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Logic to update venue information in Firestore
                      },
                      child: Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Updated Location Settings Tab
class LocationSettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputField(
            label: 'Address',
            controller: TextEditingController(),
            labelAboveField: true, // Label above the field
          ),
          SizedBox(height: 10),
          InputField(
            label: 'City',
            controller: TextEditingController(),
            labelAboveField: true, // Label above the field
          ),
          SizedBox(height: 10),
          InputField(
            label: 'State',
            controller: TextEditingController(),
            labelAboveField: true, // Label above the field
          ),
          // Add other location-related fields
        ],
      ),
    );
  }
}

// Updated Language Options Tab
class LanguageOptionsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            items: [
              DropdownMenuItem(value: 'English', child: Text('English')),
              DropdownMenuItem(value: 'Spanish', child: Text('Spanish')),
              // Add more language options
            ],
            onChanged: (value) {},
            decoration: InputDecoration(labelText: 'Select Language'),
          ),
          // Add other language-related options
        ],
      ),
    );
  }
}

// Updated Social Accounts Tab
class SocialAccountsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputField(
            label: 'Facebook',
            controller: TextEditingController(),
            labelAboveField: true, // Label above the field
          ),
          SizedBox(height: 10),
          InputField(
            label: 'Twitter',
            controller: TextEditingController(),
            labelAboveField: true, // Label above the field
          ),
          SizedBox(height: 10),
          InputField(
            label: 'Instagram',
            controller: TextEditingController(),
            labelAboveField: true, // Label above the field
          ),
          // Add other social account fields
        ],
      ),
    );
  }
}
