import 'package:mycampus/AdminSection/adminAnnouncement.dart';
import 'package:mycampus/AdminSection/adminClubs/manageClub.dart';
import 'package:mycampus/AdminSection/adminDisplay.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Implement logout functionality
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          SectionTile(
            title: 'Manage clubs',
            onTap: () {
              Get.to(() => Manageclub());
              // Navigate to announcement management page
            },
          ),
          SectionTile(
            title: 'Manage Time Table',
            onTap: () {
              Get.to(() => AdminTimeTable());
              // Navigate to announcement management page
            },
          ),
          SectionTile(
            title: 'Manage Announcements',
            onTap: () {
              Get.to(() => AdminAnnouncement());
              // Navigate to announcement management page
            },
          ),
          SectionTile(
            title: 'Manage Events',
            onTap: () {
              // Navigate to events management page
            },
          ),
          SectionTile(
            title: 'Manage Notices',
            onTap: () {
              // Navigate to notice management page
            },
          ),
          SectionTile(
            title: 'Manage Resources',
            onTap: () {
              // Navigate to resources management page
            },
          ),
          SectionTile(
            title: 'Manage Study Groups',
            onTap: () {
              // Navigate to study groups management page
            },
          ),
        ],
      ),
    );
  }
}

class SectionTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  SectionTile({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4.0,
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        title: Text(title,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        trailing: Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }
}


// Similarly, you can create other management pages for events, notices, etc.
