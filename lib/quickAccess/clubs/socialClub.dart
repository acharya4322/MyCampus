import 'package:flutter/material.dart';

class SocialClub extends StatefulWidget {
  const SocialClub({super.key});

  @override
  State<SocialClub> createState() => _SocialClubState();
}

class _SocialClubState extends State<SocialClub> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    'https://via.placeholder.com/800x300?text=Social+Club+Header', // Background image
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.pink.withOpacity(0.6),
                        Colors.purple.withOpacity(0.4)
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Social Club',
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
            ),
            const SizedBox(height: 20),
            // Overview Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 9, 78, 110),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    const BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text(
                  'Welcome to the Social Club! Connect with friends, make new acquaintances, and participate in exciting community events. Join us for fun activities and build lasting relationships.',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Upcoming Events Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upcoming Events',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.pinkAccent,
                    ),
                  ),
                  SizedBox(height: 10),
                  EventCard(
                    title: 'Weekend Picnic',
                    date: 'August 30, 2024',
                    description:
                        'Join us for a relaxing picnic at the park. Bring your favorite snacks and enjoy a day of fun and games.',
                    imageUrl:
                        'https://via.placeholder.com/150?text=Picnic', // Placeholder image for event
                  ),
                  EventCard(
                    title: 'Game Night',
                    date: 'September 5, 2024',
                    description:
                        'An evening of board games, video games, and friendly competition. Bring your game face!',
                    imageUrl:
                        'https://via.placeholder.com/150?text=Games', // Placeholder image for event
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Join Us Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Action to navigate to a join page or show more details
                },
                child: const Text('Join Us'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 32.0),
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 10,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Footer Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Contact Us: socialclub@example.com',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.facebook, color: Colors.blue),
                        onPressed: () {
                          // Open Facebook page
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.tag, color: Colors.blue),
                        onPressed: () {
                          // Open Twitter page
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.tag, color: Colors.pink),
                        onPressed: () {
                          // Open Instagram page
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.telegram, color: Colors.blue),
                        onPressed: () {
                          // Open Telegram page
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String description;
  final String imageUrl;

  const EventCard({
    required this.title,
    required this.date,
    required this.description,
    required this.imageUrl,
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
            child: Image.network(
              imageUrl,
              width: 120,
              height: 80,
              fit: BoxFit.cover,
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
