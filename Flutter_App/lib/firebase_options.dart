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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCND69bmNL0KFkSnz4nmWE4TJhYnX3DZHQ',
    appId: '1:489160485172:android:71cc2d61781b53ab1a1d61',
    messagingSenderId: '489160485172',
    projectId: 'gpstracker-84fdb',
    databaseURL: 'https://gpstracker-84fdb-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'gpstracker-84fdb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDDNVNRsDXEYsg_4esC41PXKB2vrxZoxfA',
    appId: '1:489160485172:ios:2c750f6dcf0b383c1a1d61',
    messagingSenderId: '489160485172',
    projectId: 'gpstracker-84fdb',
    databaseURL: 'https://gpstracker-84fdb-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'gpstracker-84fdb.appspot.com',
    iosBundleId: 'com.example.mapDemo',
  );
}