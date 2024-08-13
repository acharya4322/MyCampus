import 'package:mycampus/homePage/campusNavigation.dart';
import 'package:mycampus/quickAccess/clubs/Clubs.dart';
import 'package:mycampus/quickAccess/elib/eLibraryHome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class QuickAccessTiles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          QuickAccessTile(
            icon: Icons.location_city_rounded,
            label: 'Campus Navigation',
            onTap: () {
              Get.to(() => CampusNavigation());
              // Navigate to Events
            },
          ),
          QuickAccessTile(
            icon: Icons.home_max_sharp,
            label: 'E-Library',
            onTap: () {
              Get.to(() => ElibHome());
              // Navigate to Resources
            },
          ),
          QuickAccessTile(
            icon: Icons.group,
            label: 'My Groups',
            onTap: () {
              // Navigate to Study Groups
            },
          ),
          QuickAccessTile(
            icon: Icons.groups_sharp,
            label: 'Clubs',
            onTap: () {
              Get.to(() => ClubsPage());
              // Navigate to Marketplace
            },
          ),
        ],
      ),
    );
  }
}

class QuickAccessTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  QuickAccessTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(8.0),
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 48.0, color: Colors.blueAccent),
              const SizedBox(height: 8.0),
              Text(label, style: const TextStyle(fontSize: 16.0)),
            ],
          ),
        ),
      ),
    );
  }
}
