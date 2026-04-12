import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;

/// Firebase options (Android + iOS only)
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Web is disabled in this project.',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;

      case TargetPlatform.iOS:
        return ios;

      default:
        throw UnsupportedError(
          'This platform is not supported (only Android & iOS).',
        );
    }
  }

  // ======================
  // iOS CONFIG
  // ======================
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDbw52ZHxQ7h-rvu0dR12tQ-OoSrFwFUoU',
    appId: '1:450132003254:ios:1659a96cafd0e18e7fd917',
    messagingSenderId: '450132003254',
    projectId: 'skill-swap-e1a3d',
    storageBucket: 'skill-swap-e1a3d.firebasestorage.app',
    iosBundleId: 'com.example.skillSwap',
  );

  // ======================
  // ANDROID CONFIG
  // ======================
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBW555ItYCcgqhrr5yykce_It88xve92Ho',
    appId: '1:450132003254:android:0e71a57fcc1a25297fd917',
    messagingSenderId: '450132003254',
    projectId: 'skill-swap-e1a3d',
    storageBucket: 'skill-swap-e1a3d.firebasestorage.app',
  );
}
