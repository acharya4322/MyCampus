import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeaturedAnnouncements extends StatelessWidget {
  const FeaturedAnnouncements({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      height: 200.0,
      child: FutureBuilder<List<String>>(
        future: _fetchAnnouncementImages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No announcements available.'));
          }

          final imageUrls = snapshot.data!;
          return CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              enlargeCenterPage: true,
              viewportFraction: 0.65,
              aspectRatio: 16 / 9,
            ),
            items: imageUrls.map((url) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FullScreenAnnouncement(imageUrl: url),
                    ),
                  );
                },
                child: Container(
                  width: 350,
                  child: Card(
                    elevation: 7,
                    shadowColor: Colors.grey,
                    child: CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Future<List<String>> _fetchAnnouncementImages() async {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection('announcements').get();
    return snapshot.docs.map((doc) => doc['imageUrl'] as String).toList();
  }
}

class FullScreenAnnouncement extends StatelessWidget {
  final String imageUrl;

  FullScreenAnnouncement({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          // Detect downward swipe
          if (details.primaryDelta! > 10) {
            Navigator.pop(context); // Close on swipe down
          }
        },
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }
}

class ViewAnnouncements extends StatefulWidget {
  @override
  _ViewAnnouncementsState createState() => _ViewAnnouncementsState();
}

class _ViewAnnouncementsState extends State<ViewAnnouncements> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Announcements')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('announcements')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData ||
                    snapshot.data?.docs.isEmpty == true) {
                  return const Center(
                      child: Text('No announcements available.'));
                }

                final announcements = snapshot.data!.docs;
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns in the grid
                    crossAxisSpacing: 8.0, // Space between columns
                    mainAxisSpacing: 8.0, // Space between rows
                  ),
                  itemCount: announcements.length,
                  itemBuilder: (context, index) {
                    final doc = announcements[index];
                    final data = doc.data() as Map<String, dynamic>?;

                    if (data == null) {
                      return const SizedBox.shrink();
                    }

                    final imageUrl = data['imageUrl'] as String? ?? '';

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                FullScreenImage(imageUrl: imageUrl),
                          ),
                        );
                      },
                      child: Card(
                        //margin: const EdgeInsets.all(0.0),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          // Detect downward swipe
          if (details.primaryDelta! > 10) {
            Navigator.of(context).pop(); // Close on swipe down
          }
        },
        child: Center(
          child: InteractiveViewer(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }
}
