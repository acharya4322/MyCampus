// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCE7nqtIpYS9seYckcMe0nzxktnesIUdcc',
    appId: '1:1021493681555:web:7371eece11ec53597edc66',
    messagingSenderId: '1021493681555',
    projectId: 'campus-c2387',
    authDomain: 'campus-c2387.firebaseapp.com',
    storageBucket: 'campus-c2387.appspot.com',
    measurementId: 'G-6X1CFS8W2R',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBdG8ZelvWpMvyO0hhvruODLv7yYJJFsT8',
    appId: '1:1021493681555:android:8ea268456cf163657edc66',
    messagingSenderId: '1021493681555',
    projectId: 'campus-c2387',
    storageBucket: 'campus-c2387.appspot.com',
  );
}
