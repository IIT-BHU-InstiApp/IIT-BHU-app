import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/pages/login/loginPage.dart';
import 'package:iit_app/pages/worshop_detail/workshopDetailPage.dart';

class PushNotification {
  static Future<void> _navigateToDetailPage(
      BuildContext context, RemoteMessage message) async {
    int workshopId = int.tryParse(message.data['id']);
    if (workshopId == null) return;

    if (AppConstants.isLoggedIn != true) {
      await LoginPage.guestLoginSetup();
    }

    Navigator.of(context)
        .push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => WorkshopDetailPage(
          workshopId,
          workshop: null,
          isPast: message.data['isPast'] ?? false,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    )
        .then((value) {
      if (AppConstants.isGuest) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', ModalRoute.withName('/root'));
      }
    });
  }

  static Future _showDialog(
      {BuildContext context, RemoteMessage message}) async {
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
                  Navigator.pop(context, true);
                }),
          ],
        );
      },
    );
  }

  static initialize(BuildContext context) async {
    FirebaseMessaging.instance
        .getToken()
        .then((token) => print("fcm token:$token"));
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
        _showDialog(context: context, message: message).then((value) {
          if (value == true) _navigateToDetailPage(context, message);
        });
      }
    });
  }
}
