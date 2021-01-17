import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iit_app/data/post_api_service.dart';
import 'package:iit_app/external_libraries/spin_kit.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/model/sharedPreferenceKeys.dart';
import 'package:iit_app/services/connectivityCheck.dart';
import 'package:iit_app/services/crud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Initiation extends StatefulWidget {
  @override
  _InitiationState createState() => _InitiationState();
}

Future<void> onBackgroundMessageHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class _InitiationState extends State<Initiation> {
  bool _isOnline = false;
  bool _tappable = true;
  DateTime _initTime;

  _initServices() async {
    _initTime = DateTime.now();

    await Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage(onBackgroundMessageHandler);
    AppConstants.service = PostApiService.create();
    AppConstants.connectionStatus = ConnectionStatusSingleton.getInstance();
    AppConstants.connectionStatus.initialize();

    await AppConstants.setDeviceDirectoryForImages();
    await _initTheme();

    _checkConnection();
  }

  Future _checkConnection({bool tryAgain = false}) async {
    if (tryAgain) {
      setState(() {
        this._tappable = false;
      });
    }

    this._isOnline = await AppConstants.connectionStatus.checkConnection();
    if (this._isOnline == true) {
      AppConstants.isLoggedIn = await CrudMethods.isLoggedIn();
      final timePassed = DateTime.now().difference(_initTime);
      if (timePassed.inMilliseconds < 1500) {
        await Future.delayed(
            Duration(milliseconds: 1500 - timePassed.inMilliseconds));
      }
      await Navigator.of(context).popAndPushNamed('/root',
          arguments: {'initFCM': true, 'initLink': true});
    } else {
      setState(() {
        this._tappable = true;
      });
    }
  }

  _initTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(SharedPreferenceKeys.usertheme) == 'light') {
      ColorConstants.setLight();
    } else {
      ColorConstants.setDark();
    }
  }

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xfffffffc),
        body: this._isOnline
            ? Center(
                child: this._tappable == false
                    ? LoadingCircle
                    : GestureDetector(
                        onTap: () {
                          _checkConnection(tryAgain: true);
                        },
                        child: connectionError,
                      ),
              )
            : Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/iitLogo.png'),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Loading',
                        style: TextStyle(
                          color: Color(0xff956178),
                          fontSize: 24,
                        ),
                      ),
                      SpinKitThreeBounce(
                        size: 40,
                        color: Color(0xff956178),
                      ),
                      SizedBox(height: 100),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

Widget get connectionError {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Text("Could not find active internet connection"),
      Text(
        'Try again',
        style: TextStyle(
            color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20),
      ),
    ],
  );
}
