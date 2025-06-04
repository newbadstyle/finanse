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
        return macos;
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
    apiKey: 'AIzaSyCwfF7fmA7vvRUySt2Bu96ouRKfVUwGcJU',
    appId: '1:499364003042:web:00a8f1e690e10a570072bb',
    messagingSenderId: '499364003042',
    projectId: 'ninja-b3ffb',
    authDomain: 'ninja-b3ffb.firebaseapp.com',
    storageBucket: 'ninja-b3ffb.firebasestorage.app',
    measurementId: 'G-J42JPRY52B',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAntGd2C8wMO6u1Tg-Szoz8nzjy9RO-0oc',
    appId: '1:499364003042:android:e849e04dc4b27c7c0072bb',
    messagingSenderId: '499364003042',
    projectId: 'ninja-b3ffb',
    storageBucket: 'ninja-b3ffb.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAc5EZHVIslHQ3C4xebX7G8f9TiNbpe2S4',
    appId: '1:499364003042:ios:3f9798f64a7d22c40072bb',
    messagingSenderId: '499364003042',
    projectId: 'ninja-b3ffb',
    storageBucket: 'ninja-b3ffb.firebasestorage.app',
    iosBundleId: 'com.example.finanse',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAc5EZHVIslHQ3C4xebX7G8f9TiNbpe2S4',
    appId: '1:499364003042:ios:3f9798f64a7d22c40072bb',
    messagingSenderId: '499364003042',
    projectId: 'ninja-b3ffb',
    storageBucket: 'ninja-b3ffb.firebasestorage.app',
    iosBundleId: 'com.example.finanse',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCwfF7fmA7vvRUySt2Bu96ouRKfVUwGcJU',
    appId: '1:499364003042:web:068a65cebe19a96d0072bb',
    messagingSenderId: '499364003042',
    projectId: 'ninja-b3ffb',
    authDomain: 'ninja-b3ffb.firebaseapp.com',
    storageBucket: 'ninja-b3ffb.firebasestorage.app',
    measurementId: 'G-59D7F9HZYD',
  );
}
