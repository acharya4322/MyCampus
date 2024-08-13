import 'package:mycampus/event_card.dart';
import 'package:mycampus/modals/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CulturalClubPage extends StatefulWidget {
  const CulturalClubPage({super.key});

  @override
  State<CulturalClubPage> createState() => _CulturalClubPageState();
}

class _CulturalClubPageState extends State<CulturalClubPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // Show an alert dialog if URL cannot be launched
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Could not launch $url'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cultural Club'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            StreamBuilder<DocumentSnapshot>(
              stream: _firestore
                  .collection('cultural_club')
                  .doc('header')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text('No header data available.'));
                }

                final headerData = snapshot.data!;
                final headerImageUrl = headerData['imageUrl'] ??
                    'https://via.placeholder.com/800x300';
                final headerTitle =
                    headerData['title'] ?? 'Default Header Title';

                return Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        headerImageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: progress.expectedTotalBytes != null
                                  ? progress.cumulativeBytesLoaded /
                                      (progress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(child: Text('Error loading image'));
                        },
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.5),
                            Colors.black.withOpacity(0.2),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          headerTitle,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black.withOpacity(0.5),
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            // Overview Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text(
                  'Welcome to the Cultural Club! Join us to explore various cultural activities and events that celebrate diversity and creativity.',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Upcoming Events Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upcoming Events',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 10),
                  StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('cultural_club')
                        .doc('events')
                        .collection('events_list')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return const Center(
                            child: Text('No events available.'));
                      }

                      final events = snapshot.data!.docs;
                      return Column(
                        children: events.map((doc) {
                          final event = Event.fromDocument(doc);
                          return EventCard(
                            title: event.title,
                            date: event.date,
                            description: event.description,
                            imageUrl: event.imageUrl,
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Footer Section
            StreamBuilder<DocumentSnapshot>(
              stream: _firestore
                  .collection('cultural_club')
                  .doc('footer')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text('No footer data available.'));
                }

                final footerData = snapshot.data!;
                final contactEmail =
                    footerData['email'] ?? 'contact@example.com';
                final facebookUrl = footerData['facebook'] ?? '';
                final twitterUrl = footerData['twitter'] ?? '';
                final linkedinUrl = footerData['linkedin'] ?? '';

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Contact Us: $contactEmail',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (facebookUrl.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.facebook,
                                  color: Colors.blue),
                              onPressed: () => _launchURL(facebookUrl),
                            ),
                          if (twitterUrl.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.tag, color: Colors.blue),
                              onPressed: () => _launchURL(twitterUrl),
                            ),
                          if (linkedinUrl.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.tag, color: Colors.blue),
                              onPressed: () => _launchURL(linkedinUrl),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
