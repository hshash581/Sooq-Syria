import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions are not configured for web.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDLfwr7HUq_RfuciE-ORpHQ1uTqYbJrBoU',
    appId: '1:41028256496:android:374cf8b3f428b1421eb835',
    messagingSenderId: '41028256496',
    projectId: 'sooq-syria-787e6',
    storageBucket: 'sooq-syria-787e6.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDLfwr7HUq_RfuciE-ORpHQ1uTqYbJrBoU',
    appId: '1:41028256496:ios:YOUR_IOS_APP_ID',
    messagingSenderId: '41028256496',
    projectId: 'sooq-syria-787e6',
    storageBucket: 'sooq-syria-787e6.firebasestorage.app',
    iosClientId: 'YOUR_IOS_CLIENT_ID',
    iosBundleId: 'com.sooqsyr.sooqSyria',
  );
}
