import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotification {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  static initialize(BuildContext context) {
    _firebaseMessaging.getToken().then((token) => print("fcm token:$token"));
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        _popNotification(message["notification"]["title"], context);
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

// TODO: add routing here (user should be lead to required screen (mostly it will be detail screen of some workshop for which we will get data in notification itself))
  static Future<void> _popNotification(String note, BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        title: Text(note),
        actions: <Widget>[
          FlatButton(
            child: Text('Show'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
