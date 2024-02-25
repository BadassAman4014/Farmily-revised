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
    apiKey: 'AIzaSyAEmCg5dG6qPjZwwlmrTPweu7cH-8KvMQ8',
    appId: '1:756462817760:web:838ecdf161b6a0a7a1db85',
    messagingSenderId: '756462817760',
    projectId: 'farmilycd',
    authDomain: 'farmilycd.firebaseapp.com',
    databaseURL: 'https://farmilycd-default-rtdb.firebaseio.com',
    storageBucket: 'farmilycd.appspot.com',
    measurementId: 'G-SVJD924S0V',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDhRqEF6IaWfjXfSucMZnqbIYSFK5mwf4g',
    appId: '1:756462817760:android:c5b0a8f50f8fc74fa1db85',
    messagingSenderId: '756462817760',
    projectId: 'farmilycd',
    databaseURL: 'https://farmilycd-default-rtdb.firebaseio.com',
    storageBucket: 'farmilycd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC1cPiV2nynYhxRpX4RzelTlN8hRRoKtEE',
    appId: '1:756462817760:ios:6a50c2c9eccbb561a1db85',
    messagingSenderId: '756462817760',
    projectId: 'farmilycd',
    databaseURL: 'https://farmilycd-default-rtdb.firebaseio.com',
    storageBucket: 'farmilycd.appspot.com',
    iosBundleId: 'com.example.welcome',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC1cPiV2nynYhxRpX4RzelTlN8hRRoKtEE',
    appId: '1:756462817760:ios:2d0a97ae209ae7f1a1db85',
    messagingSenderId: '756462817760',
    projectId: 'farmilycd',
    databaseURL: 'https://farmilycd-default-rtdb.firebaseio.com',
    storageBucket: 'farmilycd.appspot.com',
    iosBundleId: 'com.example.welcome.RunnerTests',
  );
}
