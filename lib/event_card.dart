import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String description;
  final String? imageUrl; // Nullable

  const EventCard({
    required this.title,
    required this.date,
    required this.description,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: imageUrl != null
                ? Image.network(
                    imageUrl!,
                    width: 120,
                    height: 80,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 120,
                    height: 80,
                    color: Colors.grey[200],
                    child: Center(
                      child: Text(
                        'No Image',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
