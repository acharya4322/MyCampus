import 'package:mycampus/homePage/DisplayTimeTable.dart';
import 'package:flutter/material.dart';

class WelcomeBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      //color: Color.fromARGB(61, 0, 72, 255),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "Welcome to CampusNIET!",
            style: TextStyle(
              fontSize: 24.0,
              //   color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            "Think Placement Think NIET",
            style: TextStyle(
              fontSize: 16.0,
              //  color: Colors.white,
            ),
          ),
          const SizedBox(height: 35.0),
          Displaytimetable(),
        ],
      ),
    );
  }
}
