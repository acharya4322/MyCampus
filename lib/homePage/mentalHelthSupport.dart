import 'package:flutter/material.dart';

class MentalHealthSupport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "Mental Health Support",
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // Mood tracking
                  },
                  child: const Text('Mood Tracking'),
                ),
                const SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: () {
                    // Meditation exercises
                  },
                  child: const Text('Meditation Exercises'),
                ),
                const SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: () {
                    // Contact with counselors
                  },
                  child: const Text('Contact Counselors'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
