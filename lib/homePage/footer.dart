import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.blueGrey[800],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Contact Information
          const Text(
            "Contact Us",
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Text(
            "College Name: XYZ College\nPhone: (123) 456-7890\nEmail: support@xyzcollege.edu",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16.0),
          // Social Media Links (Removed)
          // Text(
          //   "Follow Us",
          //   style: TextStyle(
          //     fontSize: 16.0,
          //     color: Colors.white,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          // SizedBox(height: 8.0),
          // Row(
          //   children: <Widget>[
          //     IconButton(
          //       icon: Icon(Icons.facebook, color: Colors.white),
          //       onPressed: () => _launchURL('https://facebook.com/xyzcollege'),
          //     ),
          //     IconButton(
          //       icon: Icon(Icons.twitter, color: Colors.white),
          //       onPressed: () => _launchURL('https://twitter.com/xyzcollege'),
          //     ),
          //     IconButton(
          //       icon: Icon(Icons.instagram, color: Colors.white),
          //       onPressed: () => _launchURL('https://instagram.com/xyzcollege'),
          //     ),
          //     IconButton(
          //       icon: Icon(Icons.linkedin, color: Colors.white),
          //       onPressed: () => _launchURL('https://linkedin.com/company/xyzcollege'),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 16.0),
          // Terms and Privacy Links
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  // Handle Terms of Service link
                },
                child: const Text(
                  "Terms of Service",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Handle Privacy Policy link
                },
                child: const Text(
                  "Privacy Policy",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
