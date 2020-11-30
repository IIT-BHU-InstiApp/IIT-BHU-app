import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/pages/Home/homePage.dart';
import 'package:iit_app/pages/login/loginPage.dart';
import 'package:iit_app/services/pushNotification.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  void initState() {
    super.initState();
    _initFCM();
  }

  _initFCM() {
    Future.delayed(
      Duration(milliseconds: 300),
      () {
        final Map arguments = ModalRoute.of(context).settings.arguments as Map;
        // to ensure that this function is not called unnecessarily.
        if (arguments['initFCM'] == true) PushNotification.initialize(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return (AppConstants.isLoggedIn || AppConstants.isGuest)
        ? HomePage()
        : LoginPage();
  }
}
