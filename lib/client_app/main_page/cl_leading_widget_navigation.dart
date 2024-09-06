import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/client_app/notifier.dart';
import 'package:naya_menu/models/venue/venue.dart';
import 'package:naya_menu/theme/app_theme.dart'; // Import your theme file

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
      color: AppTheme.background,
      width: 130,
      child: InputDecorator(
        decoration: InputDecoration(
          filled: true,
          fillColor: AppTheme.background,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,

          // OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(8),
          //   borderSide: const BorderSide(color: AppTheme.accentColor),
          // ),
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(8),
          //   borderSide: const BorderSide(color: AppTheme.accentColor),
          // ),
          labelStyle: const TextStyle(
            fontFamily: AppTheme.fontName,
            color: AppTheme.darkText,
            fontSize: 16,
          ),

          contentPadding:
              const EdgeInsets.all(10.0), // Adjust content padding here
        ),
        child: Container(
          color: AppTheme.background, // Set the background color for the text
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Color(0xFFFFF4EE), // Remove splash color
              highlightColor: Color(0xFFFFF4EE), // Remove highlight color
              hoverColor: Color(0xFFFFF4EE), // Remove hover color
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
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
                style: AppTheme.subtitle.copyWith(
                    color: AppTheme.textPrimary), // Text style for dropdown
                items: [
                  // Map all venues to the dropdown items
                  ...venueList.map((venue) {
                    return DropdownMenuItem<String>(
                      value: venue.venueName,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          venue.venueName,
                          style:
                              AppTheme.body1.copyWith(color: AppTheme.darkText),
                        ),
                      ),
                    );
                  }).toList(),
                  const DropdownMenuItem<String>(
                    enabled: false,
                    child: Divider(), // Optional divider
                  ),
                  DropdownMenuItem<String>(
                    value: 'add_venue',
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        children: const [
                          Icon(Icons.add,
                              color: AppTheme.accentColor,
                              size: 16), // Accent color for "Add" button
                          SizedBox(width: 4), // Reduce spacing
                          Text(
                            'Add',
                            style: TextStyle(
                              color: AppTheme.accentColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ), // Smaller text with accent color
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                selectedItemBuilder: (BuildContext context) {
                  return venueList.map((venue) {
                    return FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        currentVenue?.venueName ?? venue.venueName,
                        style: AppTheme.body1.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ), // Apply primary color and bold style
                      ),
                    );
                  }).toList();
                },
                isExpanded:
                    false, // Set to false to keep dropdown width minimal
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Handle venue selection logic
  void _handleVenueSelection(String venueName, WidgetRef ref) {
    if (venueName == 'add_venue') {
      _showAddVenueDialog(ref, ref.context); // Directly pass the context
    } else {
      // Find the selected venue in the list and update the provider
      final venueList = ref.read(venueListProvider).maybeWhen(
            data: (venues) => venues,
            orElse: () => <VenueModel>[],
          );
      final selectedVenue =
          venueList.firstWhere((venue) => venue.venueName == venueName);

      // Set the selected venue in the venue provider
      ref.read(venueProvider.notifier).setVenue(selectedVenue);
    }
  }

  // Show the "Add Venue" dialog
  void _showAddVenueDialog(WidgetRef ref, BuildContext context) {
    // Use the context from the ConsumerWidget to show the dialog
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
