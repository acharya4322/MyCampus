import 'package:mycampus/AdminSection/adminDashboadr.dart';
import 'package:flutter/material.dart';

class NavigateToAdminButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminPage()),
          );
        },
        icon: const Icon(Icons.arrow_forward, color: Colors.white),
        label: const Text(
          'Go to Admin Page',
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent, // Background color
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
