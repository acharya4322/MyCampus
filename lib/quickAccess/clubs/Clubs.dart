import 'package:mycampus/quickAccess/clubs/techClub.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ClubsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clubs'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          InkWell(
            onTap: () {
              Get.to(() => Techclub());
              // Navigate to Resources
            },
            child: ClubCard(
              clubName: 'Tech Club',
              icon: Icons.computer,
              description: 'Explore the latest in technology and coding.',
            ),
          ),
          InkWell(
            onTap: () {
              //  Get.to(() => const CulturalClubPage());
              // Navigate to Resources
            },
            child: ClubCard(
              clubName: 'Cultural Club',
              icon: Icons.palette,
              description: 'Celebrate and learn about different cultures.',
            ),
          ),
          InkWell(
            onTap: () {
              //  Get.to(() => const SocialClub());
              // Navigate to Resources
            },
            child: ClubCard(
              clubName: 'Social Club',
              icon: Icons.people,
              description: 'Engage with the community and make new friends.',
            ),
          ),
          InkWell(
            onTap: () {
              // Get.to(() => const SportsClub());
              // Navigate to Resources
            },
            child: ClubCard(
              clubName: 'Sports Club',
              icon: Icons.sports,
              description: 'Participate in various sports and stay active.',
            ),
          ),
        ],
      ),
    );
  }
}

class ClubCard extends StatelessWidget {
  final String clubName;
  final IconData icon;
  final String description;

  ClubCard(
      {required this.clubName, required this.icon, required this.description});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 40.0),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clubName,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Text(description),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
