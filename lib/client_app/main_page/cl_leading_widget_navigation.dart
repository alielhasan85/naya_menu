import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/client_app/notifier.dart';
import 'package:naya_menu/models/venue/venue.dart';
import 'package:naya_menu/theme/app_theme.dart';

class ClLeadingWidgetNavigation extends ConsumerWidget {
  const ClLeadingWidgetNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch the current selected venue from the provider
    final currentVenue = ref.watch(venueProvider);

    // Fetch the list of venues (assuming you have a venueListProvider)
    final venueList = ref.watch(venueListProvider).maybeWhen(
          data: (venues) => venues,
          orElse: () => <VenueModel>[],
        );

    // Ensure that the current value is part of the venue list
    final dropdownValue = venueList.isNotEmpty &&
            currentVenue != null &&
            venueList.any((venue) => venue.venueName == currentVenue.venueName)
        ? currentVenue.venueName
        : (venueList.isNotEmpty ? venueList.first.venueName : null);

    return Container(
      width: 180, // Adjust as per the required width
      padding: const EdgeInsets.symmetric(
          horizontal: 10.0), // Add horizontal padding
      decoration: BoxDecoration(
        color: AppTheme.background, // Set background color
        borderRadius: BorderRadius.circular(8), // Add border radius
      ),
      child: DropdownButtonHideUnderline(
        child: Row(children: [
          const Icon(Icons.store),
          const SizedBox(width: 10),
          DropdownButton<String>(
            isDense:
                true, // Reduce the dropdown height to align the text with the icon
            value: dropdownValue,
            onChanged: (String? newValue) {
              if (newValue != null) {
                _handleVenueSelection(newValue, ref);
              }
            },
            icon: const Icon(Icons.arrow_drop_down),
            iconEnabledColor:
                AppTheme.primaryColor, // Apply primary color for icon
            dropdownColor: AppTheme.white, // Set dropdown background color
            style: AppTheme.display1.copyWith(
                color: AppTheme.textPrimary), // Text style for dropdown items
            items: [
              ...venueList.map((venue) {
                return DropdownMenuItem<String>(
                  value: venue.venueName,
                  child: Text(
                    venue.venueName,
                    style: AppTheme.body1.copyWith(color: AppTheme.darkText),
                  ),
                );
              }).toList(),
              const DropdownMenuItem<String>(
                enabled: false,
                child: Divider(), // Optional divider
              ),
              DropdownMenuItem<String>(
                value: 'add_venue',
                child: Row(
                  children: const [
                    Icon(Icons.add, color: AppTheme.accentColor, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Add',
                      style: TextStyle(
                        color: AppTheme.accentColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            selectedItemBuilder: (BuildContext context) {
              return venueList.map((venue) {
                return Align(
                  alignment: Alignment.centerLeft, // Align text to the left
                  child: Text(
                    currentVenue?.venueName ?? venue.venueName,
                    style: AppTheme.body1.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                );
              }).toList();
            },
          ),
        ]),
      ),
    );
  }

  // Handle venue selection logic
  void _handleVenueSelection(String venueName, WidgetRef ref) {
    if (venueName == 'add_venue') {
      _showAddVenueDialog(ref, ref.context); // Directly pass the context
    } else {
      final venueList = ref.read(venueListProvider).maybeWhen(
            data: (venues) => venues,
            orElse: () => <VenueModel>[],
          );
      final selectedVenue =
          venueList.firstWhere((venue) => venue.venueName == venueName);

      ref.read(venueProvider.notifier).setVenue(selectedVenue);
    }
  }

  // Show the "Add Venue" dialog
  void _showAddVenueDialog(WidgetRef ref, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Venue'),
          content: const Text('Enter venue details here'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Add logic to add a new venue using FirestoreVenue service
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
