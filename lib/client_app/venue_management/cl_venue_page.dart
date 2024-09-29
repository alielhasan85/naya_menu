//general page for entering venue information it has several tab for general info, deisgn etc

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/client_app/venue_management/cl_location_setting_tab.dart';
import 'package:naya_menu/client_app/venue_management/design_tab.dart';
import 'package:naya_menu/theme/app_theme.dart';
import '../widgets/input_fields.dart';

class VenueInformationPage extends ConsumerWidget {
  const VenueInformationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(children: [
      Expanded(
        flex: 1,
        child: DefaultTabController(
          length: 3, // Number of tabs
          child: Padding(
            padding: const EdgeInsets.only(top: 20, right: 50),
            child: Column(
              children: [
                Text(
                  'Edit Venue Info',
                  style: AppTheme
                      .appBarTheme.titleTextStyle, // Adjust the style as needed
                ),
                const SizedBox(
                    height: 16.0), // Add spacing between title and card
                // Scrollable content within the card
                Expanded(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 600, // Control the width of the card
                      ),
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              TabBar(
                                isScrollable: true,
                                labelStyle: const TextStyle(
                                  fontSize:
                                      14.0, // Font size for the selected tab
                                  fontWeight: FontWeight
                                      .bold, // Font weight for the selected tab
                                ),
                                labelColor: Theme.of(context).primaryColor,
                                indicatorColor: Theme.of(context).primaryColor,
                                unselectedLabelColor: Colors.grey,
                                tabs: const [
                                  Tab(text: 'Location'),
                                  Tab(text: 'Design & Display'),
                                  Tab(text: 'Social Accounts'),
                                ],
                              ),
                              const Divider(
                                color: AppTheme.accentColor,
                                thickness: 0,
                              ),
                              const SizedBox(height: 10),
                              const SizedBox(
                                height:
                                    600, // Set a fixed height for the TabBarView
                                child: TabBarView(
                                  children: [
                                    // Location settings content
                                    LocationSettingsTab(),
                                    DesignTab(),

                                    LanguageOptionsTab(),

                                    // Language options content

                                    // Social accounts content
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      const VerticalDivider(
        color: AppTheme.accentColor,
        thickness: 1,
        width: 0,
      ),
      const Expanded(
          flex: 2, child: Center(child: Text('To show the sample the menu'))),
    ]);
  }
}

// Updated Language Options Tab
class LanguageOptionsTab extends StatelessWidget {
  const LanguageOptionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            //TODO: to check language tab
            [
          DropdownButtonFormField<String>(
            items: const [
              DropdownMenuItem(value: 'English', child: Text('English')),
              DropdownMenuItem(value: 'Spanish', child: Text('Spanish')),
              // Add more language options
            ],
            onChanged: (value) {},
            decoration: const InputDecoration(labelText: 'Select Language'),
          ),
          // Add other language-related options
        ],
      ),
    );
  }
}

// Updated Social Accounts Tab
class SocialAccountsTab extends StatelessWidget {
  const SocialAccountsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputField(
            label: 'Facebook',
            controller: TextEditingController(),
            labelAboveField: true, // Label above the field
          ),
          const SizedBox(height: 10),
          InputField(
            label: 'Twitter',
            controller: TextEditingController(),
            labelAboveField: true, // Label above the field
          ),
          const SizedBox(height: 10),
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
