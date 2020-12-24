import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/pages/worshop_detail/workshopDetailPage.dart';
import 'package:built_collection/built_collection.dart';

class PushNotification {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static Future<void> onBackgroundMessageHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  static initialize(BuildContext context) {
    _firebaseMessaging.getToken().then((token) => print("fcm token:$token"));
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Got a message whilst in the background!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        // dynamic workshop = AppConstants.workshopFromDatabase.firstWhere(
        //     (w) => w.id.toString() == message.data['id'],
        //     orElse: () => null);
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) =>
        //         WorkshopDetailPage(workshop: workshop, isPast: false)));
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }
}
