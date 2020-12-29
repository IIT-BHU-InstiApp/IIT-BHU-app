import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/pages/worshop_detail/workshopDetailPage.dart';

class PushNotification {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static Future<void> _navigateToDetailPage(
      BuildContext context, RemoteMessage message) async {
    await AppConstants.populateWorkshopsAndCouncilAndEntityButtons();
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => WorkshopDetailPage(
            workshop: AppConstants.workshopFromDatabase.singleWhere(
                (w) => w?.id?.toString() == message.data['id'],
                orElse: () => null)),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  static _showDialog({BuildContext context, RemoteMessage message}) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("${message.notification.title}"),
          content: Text("${message.notification.body}"),
          actions: <Widget>[
            FlatButton(
                child: Text("Click here to view the details"),
                onPressed: () {
                  Navigator.pop(context);
                  _navigateToDetailPage(context, message);
                }),
          ],
        );
      },
    );
  }

  static initialize(BuildContext context) async {
    _firebaseMessaging.getToken().then((token) => print("fcm token:$token"));
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        _navigateToDetailPage(context, message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('Got a message whilst in the background!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');

        _navigateToDetailPage(context, message);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        _showDialog(context: context, message: message);
      }
    });
  }
}
