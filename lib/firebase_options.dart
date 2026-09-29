import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
/// Configured for legaltech-app-35251
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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyByq9jDmsmro_ESGO0LuqhHcYeRtf2ovRk',
    appId: '1:301087791491:ios:bd7046858375f976977eb6',
    messagingSenderId: '301087791491',
    projectId: 'legaltech-app-35251',
    storageBucket: 'legaltech-app-35251.firebasestorage.app',
    iosBundleId: 'com.dario.legaltech',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyByq9jDmsmro_ESGO0LuqhHcYeRtf2ovRk',
    appId: '1:301087791491:web:bd7046858375f976977eb6',
    messagingSenderId: '301087791491',
    projectId: 'legaltech-app-35251',
    storageBucket: 'legaltech-app-35251.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyByq9jDmsmro_ESGO0LuqhHcYeRtf2ovRk',
    appId: '1:301087791491:android:bd7046858375f976977eb6',
    messagingSenderId: '301087791491',
    projectId: 'legaltech-app-35251',
    storageBucket: 'legaltech-app-35251.firebasestorage.app',
  );
}
