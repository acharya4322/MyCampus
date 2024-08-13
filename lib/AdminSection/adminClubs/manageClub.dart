import 'package:mycampus/AdminSection/adminClubs/adminTech.dart';
import 'package:mycampus/quickAccess/clubs/socialClub.dart';
import 'package:mycampus/quickAccess/clubs/sportsClub.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Manageclub extends StatelessWidget {
  const Manageclub({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Clubs'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          InkWell(
            onTap: () {
              Get.to(() => AdminTechClub());
              // Navigate to Resources
            },
            child: ClubCard(
              clubName: 'Manage Tech Club',
              icon: Icons.computer,
            ),
          ),
          InkWell(
            onTap: () {
              //Get.to(() => AdminCulturalClubPage());
              // Navigate to Resources
            },
            child: ClubCard(
              clubName: 'Manage Cultural Club',
              icon: Icons.palette,
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() => const SocialClub());
              // Navigate to Resources
            },
            child: ClubCard(
              clubName: 'Social Club',
              icon: Icons.people,
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() => const SportsClub());
              // Navigate to Resources
            },
            child: ClubCard(
              clubName: 'Sports Club',
              icon: Icons.sports,
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

  ClubCard({
    required this.clubName,
    required this.icon,
  });

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
