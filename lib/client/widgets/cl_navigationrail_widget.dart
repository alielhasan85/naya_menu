import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/client/screens/platform/user_management/user_notifier.dart';

class CustomNavigationRail extends ConsumerWidget {
  final List<NavigationRailDestination> destinations;
  final int selectedIndex;
  final Function(int) onDestinationSelected;
  final bool isSettingsSection;
  final bool isSettingsExpanded;
  final Function()? onToggleSettingsExpansion;

  const CustomNavigationRail({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.isSettingsSection = false,
    this.isSettingsExpanded = false,
    this.onToggleSettingsExpansion,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NavigationRail(
      extended: ref.watch(isNavigationRailExpandedProvider),
      selectedIndex: selectedIndex,
      onDestinationSelected: (int index) {
        if (isSettingsSection && index == selectedIndex) {
          if (onToggleSettingsExpansion != null) {
            onToggleSettingsExpansion!();
          }
        } else {
          onDestinationSelected(index);
        }
      },
      destinations: destinations,
    );
  }
}
