import 'package:flutter/material.dart';
import 'package:iit_app/screens/account.dart';
import 'package:iit_app/screens/allWorkshops.dart';
import 'package:iit_app/screens/complaints.dart';
import 'package:iit_app/screens/home/home.dart';
import 'package:iit_app/screens/mess/mess.dart';
import 'package:iit_app/pages/login.dart';
import 'package:iit_app/screens/settings.dart';
import 'package:iit_app/screens/create.dart';
import 'package:iit_app/services/crud.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CrudMethods.isLoggedIn()
        ? HomeScreen()
        : LoginPage(), // route for home is '/' implicitly
    routes: <String, WidgetBuilder>{
      // define the routes
      '/home': (BuildContext context) => HomeScreen(),
      '/mess': (BuildContext context) => MessScreen(),
      '/allWorkshops': (BuildContext context) => AllWorkshopsScreen(),
      '/account': (BuildContext context) => AccountScreen(),
      '/complaints': (BuildContext context) => ComplaintsScreen(),
      '/settings': (BuildContext context) => SettingsScreen(),

      '/login': (BuildContext context) => LoginPage(),
      '/create': (BuildContext context) => CreateScreen(),
    },
  ));
}
