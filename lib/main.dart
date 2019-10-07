import 'package:flutter/material.dart';
import 'package:iit_app/screens/account.dart';
import 'package:iit_app/screens/home.dart';
import 'package:iit_app/screens/settings.dart';
import 'package:iit_app/screens/create.dart';


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(), // route for home is '/' implicitly
    routes: <String, WidgetBuilder>{
      // define the routes
      SettingsScreen.routeName: (BuildContext context) => SettingsScreen(),
      AccountScreen.routeName: (BuildContext context) => AccountScreen(),
      CreateScreen.routeName: (BuildContext context) => CreateScreen(),
    },
  ));
}
