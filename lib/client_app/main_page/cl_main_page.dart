import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/client_app/main_page/cl_main_navigation.dart';
import 'package:naya_menu/client_app/main_page/section_content.dart';
import 'package:naya_menu/client_app/notifier.dart';
import 'package:naya_menu/client_app/user_management/utility_functions.dart';
import 'package:naya_menu/client_app/widgets/cl_user_app_bar.dart';
import 'package:naya_menu/theme/app_theme.dart';
import '../widgets/progress_indicator.dart';
import '../user_management/cl_account_menu.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  @override
  void initState() {
    super.initState();
    // Fetch and store user data on init

    // Fetch and store venue data on init
  }

  @override
  Widget build(BuildContext context) {
    final selectedSection = ref.watch(selectedSectionProvider);
    final isNavigationRailExpanded =
        ref.watch(isNavigationRailExpandedProvider);
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: CustomAppBar(
        title: "Aureola Platform",
        actions: [
          _buildSearchField(),
          const SizedBox(width: 20),
          _buildNotificationButton(),
          const SizedBox(width: 20),
          if (user != null)
            ProfileMenu(
              onChange: (index) {
                switch (index) {
                  case 1:
                    viewProfile(context); // Open UserProfilePage
                    break;
                  case 2:
                    openNotifications(context); // Open Notifications
                    break;
                  case 3:
                    changeLanguage(context); // Change Language
                    break;
                  case 4:
                    openHelpCenter(context); // Open Help Center
                    break;
                  case 5:
                    logout(context); // Sign out
                    break;
                }
              },
            )
          else
            SizedBox(
              height: 25,
              width: 25,
              child: CustomProgressIndicator(),
            ),
          const SizedBox(width: 20),
        ],
        centerTitle: false, // Adjust according to your preference
      ),
      body: Row(
        children: [
        const NavigationRailWidget(), // Use NavigationRailWidget
        const VerticalDivider(
          color: AppTheme.accentColor,
          thickness: 1,
          width: 1,
        ), // Separator
        // column to place the icon for expanding of  navigation rail
        SizedBox(
          width: 50,
          child: Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: Icon(
                isNavigationRailExpanded
                    ? Icons.keyboard_arrow_left
                    : Icons.keyboard_arrow_right,
                color: AppTheme.iconTheme.color,
              ),
              onPressed: () {
                ref.read(isNavigationRailExpandedProvider.notifier).state =
                    !isNavigationRailExpanded;
              },
            ),
          ),
        ),

        Expanded(
          child: SectionContent(selectedSection: selectedSection),
        ),
      ]),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: SizedBox(
        width: 300,
        child: TextField(
          decoration: InputDecoration(
            labelText: '',
            hintText: 'Search...',
            labelStyle: AppTheme.inputDecorationTheme.labelStyle,
            hintStyle: AppTheme.inputDecorationTheme.hintStyle,
            border: AppTheme.inputDecorationTheme.border,
            enabledBorder: AppTheme.inputDecorationTheme.enabledBorder,
            focusedBorder: AppTheme.inputDecorationTheme.focusedBorder,
            filled: true,
            fillColor: AppTheme.inputDecorationTheme.fillColor,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationButton() {
    return IconButton(
      icon: Icon(
        Icons.notifications,
        color: AppTheme.iconTheme.color,
      ),
      onPressed: () {
        // Handle notification icon button press (you can move this logic to utility_functions.dart if needed)
      },
    );
  }
}
