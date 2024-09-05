import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

import 'client_app/app.dart' as clientApp;
import 'guest_app/app.dart' as guestApp;
import 'admin_app/app.dart' as adminApp;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // await dotenv.load(fileName: ".env");

  // String appType = dotenv.env['APP_TYPE'] ?? 'client';

  // Manually set the app type here (choose between 'client', 'guest', or 'admin')
  String appType = 'client'; // Change this manually as needed

  runApp(ProviderScope(child: MyApp(appType: appType)));
}

class MyApp extends StatelessWidget {
  final String appType;

  const MyApp({super.key, required this.appType});

  @override
  Widget build(BuildContext context) {
    if (appType == 'client') {
      return const clientApp.MyApp();
    } else if (appType == 'guest') {
      return const guestApp.MyApp();
    } else if (appType == 'admin') {
      return const adminApp.MyApp();
    } else {
      return Container(); // Or a default app/screen if needed
    }
  }
}
