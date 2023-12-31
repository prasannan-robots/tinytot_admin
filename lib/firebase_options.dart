// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return ios;
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'AIzaSyDDSJHM3AL9xk8fajhtdl3SfQLN6aPTjM8',
    appId: '1:485271178666:web:2c8ae1c5951d27a4622fd3',
    messagingSenderId: '485271178666',
    projectId: 'tinytot-41511',
    authDomain: 'tinytot-41511.firebaseapp.com',
    storageBucket: 'tinytot-41511.appspot.com',
    measurementId: 'G-DYCLWMYEQD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAokBlpEd64pPIszR8wQNUwGzRdG-MxOHs',
    appId: '1:485271178666:android:801e90feebcf0ddd622fd3',
    messagingSenderId: '485271178666',
    projectId: 'tinytot-41511',
    storageBucket: 'tinytot-41511.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBciEMPD4wXHLLU0bogCSiBqZh1N9qSpdg',
    appId: '1:485271178666:ios:5ac99385a3de77d9622fd3',
    messagingSenderId: '485271178666',
    projectId: 'tinytot-41511',
    storageBucket: 'tinytot-41511.appspot.com',
    iosBundleId: 'com.example.tinytotAdmin',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBciEMPD4wXHLLU0bogCSiBqZh1N9qSpdg',
    appId: '1:485271178666:ios:c13a0b517aa5c0cf622fd3',
    messagingSenderId: '485271178666',
    projectId: 'tinytot-41511',
    storageBucket: 'tinytot-41511.appspot.com',
    iosBundleId: 'com.example.tinytotAdmin.RunnerTests',
  );
}
