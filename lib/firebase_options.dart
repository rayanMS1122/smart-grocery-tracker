import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return windows;
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
    apiKey: 'AIzaSyAZ1VX_ZfwGPRbS9QaZfo8oUMaoJTOWo1g',
    appId: '1:741856292620:web:1db943ec4e73c45a52a329',
    messagingSenderId: '741856292620',
    projectId: 'smart-grocery-tracker-7c8a6',
    authDomain: 'smart-grocery-tracker-7c8a6.firebaseapp.com',
    storageBucket: 'smart-grocery-tracker-7c8a6.firebasestorage.app',
    measurementId: 'G-YQ46HP73WR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB3q6FjIfhJr06Q-wdr0YLZ9CE0znbhh-A',
    appId: '1:741856292620:android:c1c4f09e741ac83752a329',
    messagingSenderId: '741856292620',
    projectId: 'smart-grocery-tracker-7c8a6',
    storageBucket: 'smart-grocery-tracker-7c8a6.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAuJ72yOwVk9mAEIs7rs9wwHr4Ez3PG3YY',
    appId: '1:741856292620:ios:d55ff93607c40f5852a329',
    messagingSenderId: '741856292620',
    projectId: 'smart-grocery-tracker-7c8a6',
    storageBucket: 'smart-grocery-tracker-7c8a6.firebasestorage.app',
    iosBundleId: 'com.example.smartGroceryTracker',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAZ1VX_ZfwGPRbS9QaZfo8oUMaoJTOWo1g',
    appId: '1:741856292620:web:6bb861dd862880b752a329',
    messagingSenderId: '741856292620',
    projectId: 'smart-grocery-tracker-7c8a6',
    authDomain: 'smart-grocery-tracker-7c8a6.firebaseapp.com',
    storageBucket: 'smart-grocery-tracker-7c8a6.firebasestorage.app',
    measurementId: 'G-CVS4K4Z1XB',
  );
}
