import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/screens/drawer.dart';
import 'package:iit_app/screens/home/home.dart';
import 'package:iit_app/ui/colorPicker.dart';

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
    return SafeArea(
      minimum: const EdgeInsets.all(2.0),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        drawer: SideBar(context: context),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Center(
                child: this._refreshing
                    ? CircularProgressIndicator()
                    : RaisedButton(
                        onPressed: onResetDatabase, child: Text("Reset Data")),
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: RaisedButton(
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ColorPicker())),
                  child: Text('Pick Color for theme')),
            ),
          ],
        ),
      ),
    );
  }
}
