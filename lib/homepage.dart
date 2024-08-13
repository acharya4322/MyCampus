import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mycampus/AdminSection/NavigateToAdminButton.dart';
import 'package:mycampus/homePage/GroupFinder.dart';
import 'package:mycampus/homePage/announcement.dart';
import 'package:mycampus/homePage/campusSafety.dart';
import 'package:mycampus/homePage/footer.dart';
import 'package:mycampus/homePage/mentalHelthSupport.dart';
import 'package:mycampus/quickAccess/QuickAccessTiles.dart';
import 'package:mycampus/homePage/upCommingEvents.dart';
import 'package:mycampus/homePage/virtualNoticeBoard.dart';
import 'package:mycampus/homePage/welcomeBanner.dart';
import 'package:mycampus/homePage/appbar.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  DateTime? lastPressed;

  Future<void> _refreshData() async {
    // Simulate a network request or some async operation
    await Future.delayed(const Duration(seconds: 2));

    // You can refresh your state here if needed
    setState(() {
      // Update your data or UI if needed
    });
  }

  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if (lastPressed == null ||
        now.difference(lastPressed!) > const Duration(seconds: 2)) {
      lastPressed = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Press back again to exit'),
          duration: Duration(seconds: 2),
        ),
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Appbarsec(), // Correct way to include Appbarsec
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: ListView(
            children: <Widget>[
              WelcomeBanner(),
              QuickAccessTiles(),
              const SizedBox(height: 16.0),
              const FeaturedAnnouncements(),
              TextButton(
                onPressed: () {
                  Get.to(() => ViewAnnouncements());
                },
                child: const Text(
                  'View Announcements',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              const SizedBox(height: 16.0),
              CampusEvents(),
              const SizedBox(height: 16.0),
              StudyGroupFinder(),
              const SizedBox(height: 16.0),
              VirtualNoticeBoard(),
              const SizedBox(height: 16.0),
              MentalHealthSupport(),
              const SizedBox(height: 16.0),
              Container(
                color: Colors.black12,
                child: Column(
                  children: [
                    CampusSafety(),
                    const SizedBox(height: 16.0),
                    NavigateToAdminButton(),
                  ],
                ),
              ),
              Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
