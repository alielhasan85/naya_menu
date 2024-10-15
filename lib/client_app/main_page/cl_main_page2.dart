import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/client_app/main_page/cl_main_navigation.dart';
import 'package:naya_menu/client_app/main_page/section_content.dart';
import 'package:naya_menu/client_app/notifier.dart';
import 'package:naya_menu/client_app/user_management/utility_functions.dart';
import 'package:naya_menu/client_app/widgets/cl_user_app_bar.dart';
import 'package:naya_menu/models/venue/venue.dart';
import 'package:naya_menu/theme/app_theme.dart';
import '../widgets/progress_indicator.dart';
import '../user_management/cl_account_menu.dart';

class MainPage2 extends ConsumerStatefulWidget {
  const MainPage2({super.key});

  @override
  _MainPage2State createState() => _MainPage2State();
}

class _MainPage2State extends ConsumerState<MainPage2> {
  @override
  void initState() {
    super.initState();
    // Fetch and store user data on init

    // Fetch and store venue data on init
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final venue = ref.watch(venueProvider);

    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 60,
          title: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Aureola ', // Style for the first part of the text
                    style: AppTheme.titleAureola,
                  ),
                  TextSpan(
                    text: 'Platform', // Style for the word 'Platform'
                    style: AppTheme.titlePlatform,
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: AppTheme.background,
          automaticallyImplyLeading: true,
          actions: [
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
                height: 30,
                width: 30,
                child: CustomProgressIndicator(),
              ),
            const SizedBox(width: 20),
          ],
          bottom: PreferredSize(
            preferredSize:
                const Size.fromHeight(2.0), // Set height of the divider
            child: Container(
              color: AppTheme.grey2, // Set the divider color to #DAD5CF
              height: 2.0, // Set the height of the divider
            ),
          )),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Align(
            alignment: Alignment.topCenter,
            child: GetCardVenue(),
          ),
        ),
      ),
    );
  }
}

class GetCardVenue extends ConsumerWidget {
  const GetCardVenue({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Assuming venueProvider provides the current venue's data
    final venue = ref.watch(venueProvider);

    if (venue == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 326,
          height: 398,
          decoration: BoxDecoration(
            color: AppTheme.white,
            boxShadow: [
              BoxShadow(
                color: AppTheme.grey,
                blurRadius: 7.60,
                offset: Offset(4, 4),
                spreadRadius: 2,
              ),
            ],
          ),

          // ShapeDecoration(
          //   gradient: RadialGradient(
          //     center: Alignment(0.81, 0.88),
          //     radius: 0.34,
          //     colors: [Color(0xFF856666), Color(0xFFEBB3B3)],
          //   ),
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(33),
          //   ),
          //   shadows: [
          //     BoxShadow(
          //       color: Color(0x3F000000),
          //       blurRadius: 7.60,
          //       offset: Offset(4, 4),
          //       spreadRadius: 2,
          //     )
          //   ],
          // ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Venue Name
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  venue.venueName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Logo
              if (venue.designAndDisplay['logoUrl'] != null)
                Image.network(
                  venue.designAndDisplay['logoUrl'],
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),

              const SizedBox(height: 10),

              // Address
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  venue.address['country'] ?? 'No Address',
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 10),

              // Phone Number
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  venue.contact['phoneNumber'] ?? 'No Phone Number',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),

              // Two Buttons (Billing and Contact)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Billing Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Text('data'),
                        ),
                      );
                    },
                    child: const Text('Billing'),
                  ),

                  // Contact Button
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Example of a function that can be used for dialing a phone number
  void dialPhone(String phoneNumber) {
    // Implementation to dial phone number using appropriate platform-specific code
    print('Dialing: $phoneNumber');
  }
}
