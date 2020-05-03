import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/screens/home/home.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _refreshing = false;
// TODO: Display a pop up to ask user for confirmation
  onResetDatabase() async {
    setState(() {
      _refreshing = true;
    });
    await AppConstants.deleteAllLocalData();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeScreen()), (r) => false);
    // setState(() {
    //   _refreshing = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Container(
          child: Center(
        child: this._refreshing
            ? CircularProgressIndicator()
            : RaisedButton(
                onPressed: onResetDatabase, child: Text("Reset Data")),
      )),
    );
  }
}
