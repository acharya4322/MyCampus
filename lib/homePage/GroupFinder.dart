import 'package:flutter/material.dart';

class StudyGroupFinder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "Group Finder",
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: () {
              // Find and join study groups
            },
            child: const Text('Join a Group'),
          ),
          const SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: () {
              // Create a new study group
            },
            child: const Text('Create a Group'),
          ),
        ],
      ),
    );
  }
}
