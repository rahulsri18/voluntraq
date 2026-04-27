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
    apiKey: 'AIzaSyA6F5T4kIF0fuPEJnQcA7PNEMggF9xwaQ4',
    appId: '1:591571872017:web:d1c481d2038a4009ee84b0',
    messagingSenderId: '591571872017',
    projectId: 'voluntraq-hackathon',
    authDomain: 'voluntraq-hackathon.firebaseapp.com',
    databaseURL: 'https://voluntraq-hackathon-default-rtdb.firebaseio.com',
    storageBucket: 'voluntraq-hackathon.firebasestorage.app',
    measurementId: 'G-01GP2HWEJE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDxOpf9S0QY23A1-9slmtj3ASTXvJAxcag',
    appId: '1:591571872017:android:241a188676dee13fee84b0',
    messagingSenderId: '591571872017',
    projectId: 'voluntraq-hackathon',
    databaseURL: 'https://voluntraq-hackathon-default-rtdb.firebaseio.com',
    storageBucket: 'voluntraq-hackathon.firebasestorage.app',
  );
}
