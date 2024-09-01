import 'package:flutter/material.dart';
import 'package:naya_menu/theme/app_theme.dart';

class VenueInformationPage extends StatelessWidget {
  const VenueInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Venue Information',
                //style: ,
              ),
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
    );
  }
}

// Placeholder for Location Settings Tab
class LocationSettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Address'),
          ),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(labelText: 'City'),
          ),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(labelText: 'State'),
          ),
          // Add other location-related fields
        ],
      ),
    );
  }
}

// Placeholder for Language Options Tab
class LanguageOptionsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}

// Placeholder for Social Accounts Tab
class SocialAccountsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: InputDecoration(labelText: 'Facebook'),
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(labelText: 'Twitter'),
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(labelText: 'Instagram'),
        ),
        // Add other social account fields
      ],
    );
  }
}
