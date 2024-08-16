import 'package:flutter/material.dart';
import 'package:naya_menu/client/screens/login/cl_auth_page.dart';
import 'package:naya_menu/theme/app_theme.dart'; // Import your AppTheme

// starting page or loading page to be edited
class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CircleAvatar(
        backgroundColor: AppTheme.nearlyWhite, // Use your theme color
        child: Column(
          children: [
            const Spacer(),
            Text(
              'Naya Menu',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium, // Use themed text style
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Create Your Own Special Menu!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.lightText,
                  ), // Use themed text style with custom modifications
            ),
            const SizedBox(
              height: 50,
            ),
            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.white, // Use your theme color
                backgroundColor: AppTheme.grey, // Use your theme color
                textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 18,
                      color: AppTheme.white,
                    ), // Use themed text style with custom modifications
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              icon: const Icon(Icons.login_rounded),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                child: Text('Sign to Get Started'),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
