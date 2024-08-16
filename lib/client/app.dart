import 'package:flutter/material.dart';
import 'package:naya_menu/client/screens/starting_page/cl_home_page.dart';
import 'package:naya_menu/client/screens/platform/cl_main_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Client interface',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 154, 197, 228)),
        useMaterial3: true,
      ),
      home: //const GetStartedPage(),

          GetStartedPage(),
    );
  }
}
