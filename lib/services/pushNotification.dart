import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// TODO: use this library
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotification {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  static initialize(BuildContext context) {
    _firebaseMessaging.getToken().then((token) => print("fcm token:$token"));
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
      // TODO: Setup required configuration for onBackgroundMessage Handler, code changes would be required in app level build.gradle , AndroidManifest.xml, MainActivity.kt etc.
      onBackgroundMessage: null,
    );
  }
}
