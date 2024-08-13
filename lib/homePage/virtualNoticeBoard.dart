import 'package:flutter/material.dart';

class VirtualNoticeBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "Virtual Notice Board",
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5, // Replace with actual number of notices
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                title: Text('Notice ${index + 1}'),
                subtitle: Text('Details of notice ${index + 1}'),
              );
            },
          ),
          const SizedBox(height: 10.0),
          Center(
            child: TextButton(
              onPressed: () {
                // Navigate to full notice board
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
