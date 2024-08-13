import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CampusSafety extends StatelessWidget {
  // Define the phone number for the emergency call
  final String emergencyNumber = "6201392582";

  // Function to make a call
  Future<void> _makeCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: emergencyNumber,
    );
    try {
      await launchUrl(launchUri);
    } catch (e) {
      // Handle any errors that might occur
      print('Could not launch $launchUri');
    }
  }

  // Function to show confirmation dialog
  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Emergency SOS'),
          content: const Text('Do you want to make an emergency call?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Make Call'),
              onPressed: () {
                Navigator.of(context).pop();
                _makeCall(); // Make the call when confirmed
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "Campus Safety",
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: () {
              _showConfirmationDialog(context); // Show the confirmation dialog
            },
            child: const Text('Emergency SOS'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
          ),
          const SizedBox(height: 10.0),
          const Text(
            "Safety Tips",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          const Text('• Always be aware of your surroundings.'),
          const Text('• Keep your belongings secure.'),
          const Text('• Avoid walking alone at night.'),
        ],
      ),
    );
  }
}
