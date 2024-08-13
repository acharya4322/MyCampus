import 'package:mycampus/firebase_options.dart';
import 'package:mycampus/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.testMode = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        // Light theme
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.blue,
          hintColor: const Color.fromARGB(255, 145, 145, 145),
          // Add more customizations
        ),

// Dark theme
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.blueGrey,
          hintColor: const Color.fromARGB(255, 122, 122, 122),
          // Add more customizations
        ),
        themeMode: ThemeMode.system, //

        home: SplashScreen());
  }
}
