import 'package:flutter/material.dart';

class Appbarsec extends StatelessWidget {
  const Appbarsec({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // backgroundColor: Colors.blueAccent,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Logo
          Image.asset(
            'images/nietlogo.png', // Ensure you have the logo in this path
            height: 40.0,
          ),
          // Navigation Menu

          // Profile Icon
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Navigate to Profile settings
            },
            tooltip: 'Profile',
          ),
        ],
      ),
      actions: <Widget>[
        // Additional actions can go here if needed
      ],
    );
  }
}
