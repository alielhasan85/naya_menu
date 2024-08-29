import 'package:flutter/material.dart';

class VenueInformationPage extends StatelessWidget {
  const VenueInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Basic UI to display venue information and allow updates
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Venue Information',
                // style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Venue Name',
                ),
              ),
              // Other fields for address, city, state, etc.
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Logic to update venue information in Firestore
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
