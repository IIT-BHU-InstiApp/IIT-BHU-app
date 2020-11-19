import 'package:flutter/material.dart';
import 'package:iit_app/external_libraries/spin_kit.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/ui/drawer.dart';
import 'package:iit_app/pages/Home/homePage.dart';
import 'package:iit_app/ui/text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/colorConstants.dart';
import '../../model/sharedPreferenceKeys.dart';

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
    await AppConstants.deleteAllLocalDataWithImages();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomePage()), ModalRoute.withName('/'));
  }

// TODO: Remove this dialog box, instead create buttons directly (like      Pick Theme:           Light   Dark)
  _chooseTheme() {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 50,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    child: RaisedButton(
                      onPressed: () async {
                        ColorConstants.dark();
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setString(SharedPreferenceKeys.usertheme, 'dark');
                        Navigator.pop(context);
                      },
                      child: Text('dark'),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    child: RaisedButton(
                      onPressed: () async {
                        ColorConstants.light();
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setString(SharedPreferenceKeys.usertheme, 'light');
                        Navigator.pop(context);
                      },
                      child: Text('light'),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(2.0),
      child: Scaffold(
        backgroundColor: ColorConstants.homeBackground,
        appBar: AppBar(
          backgroundColor: ColorConstants.homeBackground,
          title: Text(
            "Settings",
            style: Style.baseTextStyle.copyWith(color: Colors.white),
          ),
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
                    ? LoadingCircle
                    : RaisedButton(onPressed: onResetDatabase, child: Text("Reset Saved Data")),
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: RaisedButton(onPressed: () => _chooseTheme(), child: Text('Pick theme')),
            ),
          ],
        ),
      ),
    );
  }
}
