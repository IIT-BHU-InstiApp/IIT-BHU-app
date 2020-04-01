import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
      ),
      body: Container(
          child: Center(
        child: Text("My Token: ${AppConstants.djangoToken}"),
      )),
    );
  }
}
