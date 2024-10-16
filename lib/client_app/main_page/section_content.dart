import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/client_app/notifier.dart';
import 'package:naya_menu/client_app/venue_management/cl_venue_page.dart';

class SectionContent extends ConsumerWidget {
  final String selectedSection;

  const SectionContent({required this.selectedSection, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final venue = ref.watch(venueProvider);

    if (selectedSection.startsWith('Settings')) {
      return _buildSettingsContent(context, ref);
    }

    switch (selectedSection) {
      case 'Dashboard':
        try {
          return Center(
              child: Image.network(venue?.designAndDisplay['logoUrl'] ?? Text('Failed to load logo')));
        } catch (e) {
         
          return Center(child: Text('Failed to load logo'));
        }

      case 'Report':
        return Center(child: Text('Report Content'));
      case 'Recommendation':
        return Center(child: Text('Recommendation Content'));
      case 'Orders':
        return Center(child: Text('Orders Content'));
      case 'Reservation':
        return Center(child: Text('Reservation Content'));
      case 'Engagement':
        return Center(child: Text('Engagement Content'));
      case 'Menu Management':
        return Center(child: Text('Menu Management Content'));
      case 'Feedback':
        return Center(child: Text('Feedback Content'));
      case 'Translation Center':
        return Center(child: Text('Translation Center Content'));
      case 'Marketplace':
        return Center(child: Text('Marketplace Content'));
      default:
        return Center(child: Text('Unknown Section'));
    }
  }

  Widget _buildSettingsContent(BuildContext context, WidgetRef ref) {
    switch (selectedSection) {
      case 'Settings/Venue Information':
        return const VenueInformationPage();
      case 'Settings/Design and Display':
        return Center(child: Text('Design and Display Content'));
      case 'Settings/Operations':
        return Center(child: Text('Operations Content'));
      default:
        return Center(child: Text('Select a Setting'));
    }
  }
}
