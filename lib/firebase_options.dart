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
        return ios;
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
    apiKey: 'AIzaSyC6KxTNvTSn0d6AmL2_KWTguGu7mjJNUwE',
    appId: '1:452611860027:web:1c94a20a0392680c4c1e1e',
    messagingSenderId: '452611860027',
    projectId: 'bongbaeboho',
    authDomain: 'bongbaeboho.firebaseapp.com',
    storageBucket: 'bongbaeboho.firebasestorage.app',
    measurementId: 'G-BGN5XMEGGN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAp4jZnsEjaaX29_XoAgm4XRGveKjGnxKs',
    appId: '1:452611860027:android:9156a2a64b5257574c1e1e',
    messagingSenderId: '452611860027',
    projectId: 'bongbaeboho',
    storageBucket: 'bongbaeboho.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAeqXML-jaZwT1Hew6eOMyPJxrXk7LTiCU',
    appId: '1:452611860027:ios:066089bbf8658a9a4c1e1e',
    messagingSenderId: '452611860027',
    projectId: 'bongbaeboho',
    storageBucket: 'bongbaeboho.firebasestorage.app',
    iosBundleId: 'com.example.bongBae',
  );
}
