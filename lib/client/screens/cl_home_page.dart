import 'package:flutter/material.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:naya_menu/client/screens/cl_auth_page.dart';

// starting page or loading page to be edited
class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CircleAvatar(
        backgroundColor:
            HexColor('#f5f6f8'), //shall be changed to match ui design
        child: Column(
          children: [
            const Spacer(),
            Text(
              'Naya Menu',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Create Your Own Special Menu!',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black26,
                  fontSize: 29),
            ),
            const SizedBox(
              height: 50,
            ),
            TextButton.icon(
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:
                      HexColor('#69639f'), // need to work on the color plate
                  textStyle: const TextStyle(fontSize: 18)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              icon: const Icon(Icons.login_rounded),
              label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  child: Text('Sign to Get Started')),
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }
}
