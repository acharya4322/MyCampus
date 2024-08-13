import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String date;
  final String description;
  final String imageUrl;

  Event({
    required this.id,
    required this.title,
    required this.date,
    required this.description,
    required this.imageUrl,
  });

  factory Event.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      title: data['title'] ?? '',
      date: data['date'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
