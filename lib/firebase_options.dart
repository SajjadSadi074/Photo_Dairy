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
    apiKey: 'AIzaSyDdS0EWtP4Uepwr-CnPr9J4ZLdnmxVMOdU',
    appId: '1:381542234938:web:0379e0c18d3ae89afb2e03',
    messagingSenderId: '381542234938',
    projectId: 'memories-in-frames',
    authDomain: 'memories-in-frames.firebaseapp.com',
    storageBucket: 'memories-in-frames.appspot.com',
    measurementId: 'G-3PLKT8QRL5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCUkesg_LA24Ij72_6v5OhphK0QU7O5aE8',
    appId: '1:381542234938:android:96fecfce2cfecf77fb2e03',
    messagingSenderId: '381542234938',
    projectId: 'memories-in-frames',
    storageBucket: 'memories-in-frames.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAYyPa5FtdjgpHI3qX9KhC04txU_Be6ZnY',
    appId: '1:381542234938:ios:aebc0473b2edd7a7fb2e03',
    messagingSenderId: '381542234938',
    projectId: 'memories-in-frames',
    storageBucket: 'memories-in-frames.appspot.com',
    iosBundleId: 'com.example.memoriesInFrames',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAYyPa5FtdjgpHI3qX9KhC04txU_Be6ZnY',
    appId: '1:381542234938:ios:88056b8c180b4612fb2e03',
    messagingSenderId: '381542234938',
    projectId: 'memories-in-frames',
    storageBucket: 'memories-in-frames.appspot.com',
    iosBundleId: 'com.example.memoriesInFrames.RunnerTests',
  );
}
