import 'package:flutter/material.dart';

class CampusEvents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "Upcoming Events",
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5, // Replace with actual number of events
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                title: Text('Event ${index + 1}'),
                subtitle: Text(
                    'Date: ${DateTime.now().add(Duration(days: index)).toLocal()}'),
                trailing: Text('Brief description of event ${index + 1}'),
              );
            },
          ),
          const SizedBox(height: 10.0),
          Center(
            child: TextButton(
              onPressed: () {
                // Navigate to full events calendar
              },
              child: const Text('View All',
                  style: TextStyle(color: Colors.blueAccent)),
            ),
          ),
        ],
      ),
    );
  }
}
