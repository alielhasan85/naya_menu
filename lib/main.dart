import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'client_app/app.dart' as clientApp;
import 'guest_app/app.dart' as guestApp;
import 'admin_app/app.dart' as adminApp;
import 'package:flutter/services.dart';

// Entry point of the application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Load any additional assets or localization data
  await loadLocalizationAssets();

  // Define the app type here ('client', 'guest', 'admin')
  const String appType =
      'client'; // Manually set to 'client', 'guest', or 'admin'

  // Ensure the app doesn't rotate if not intended
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(ProviderScope(child: MyApp(appType: appType)));
  });
}

// Helper function to load localization assets
Future<void> loadLocalizationAssets() async {
  try {
    // Example of loading a localization asset
    await rootBundle.loadString('assets/lang/en.json');
  } catch (e) {
    print('Error loading localization assets: $e');
  }
}

class MyApp extends StatelessWidget {
  final String appType;

  const MyApp({super.key, required this.appType});

  @override
  Widget build(BuildContext context) {
    switch (appType) {
      case 'client':
        return const clientApp.MyApp();
      case 'guest':
        return const guestApp.MyApp();
      case 'admin':
        return const adminApp.MyApp();
      default:
        return Container(); // Or a default app screen if no appType is matched
    }
  }
}
