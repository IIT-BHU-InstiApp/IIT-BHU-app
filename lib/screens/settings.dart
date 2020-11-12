import 'package:flutter/material.dart';
import 'package:iit_app/external_libraries/spin_kit.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/screens/drawer.dart';
import 'package:iit_app/pages/Home/homePage.dart';
import 'package:iit_app/ui/colorPicker.dart';
import 'package:iit_app/ui/text_style.dart';
import 'package:iit_app/ui/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/colorConstants.dart';
import '../model/sharedPreferenceKeys.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _refreshing = false;

  ValueNotifier<Color> _colorListener;
  ColorPicker _colorPicker;

// TODO: Display a pop up to ask user for confirmation
  onResetDatabase() async {
    setState(() {
      _refreshing = true;
    });
    await AppConstants.deleteAllLocalDataWithImages();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomePage()), ModalRoute.withName('/'));
    // setState(() {
    //   _refreshing = false;
    // });
  }

  setColor(color) {
    ColorConstants.settingBackground = color;
  }

  @override
  void initState() {
    this._colorListener = ValueNotifier(ColorConstants.settingBackground);
    this._colorPicker = ColorPicker(_colorListener);
    super.initState();
  }

  @override
  void dispose() {
    this._colorListener.dispose();
    super.dispose();
  }

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
                        AppTheme.dark();
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
                        AppTheme.light();
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
      child: ValueListenableBuilder(
        valueListenable: _colorListener,
        builder: (bc, currentColor, child) {
          setColor(currentColor);
          return Scaffold(
            backgroundColor: ColorConstants.settingBackground,
            appBar: AppBar(
              backgroundColor: _colorListener.value,
              title: Text(
                "Settings",
                style: Style.baseTextStyle.copyWith(color: Colors.black54),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
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
                  child: RaisedButton(
                      onPressed: () =>
                          _chooseTheme(), //_colorPicker.getColorPickerDialogBox(context),
                      child: Text('Pick theme')), //Text('Pick Color for theme'))
                ),
                /*Container(
                  child: Center(
                    child: RaisedButton(
                        onPressed: () {
                          setState(() {
                            AppConstants.chooseColorPaletEnabled =
                                !AppConstants.chooseColorPaletEnabled;
                          });
                        },
                        child: AppConstants.chooseColorPaletEnabled == true
                            ? Text("Disable Color Customization")
                            : Text("Enable Color Customization")),
                  ),
                ),
                Container(
                  child: Center(
                    child: RaisedButton(
                        onPressed: () {
                          AppConstants.chooseColorPaletEnabled = false;
                          ColorConstants.resetToDefault();
                          _colorListener.value =
                              ColorConstants.settingBackgroundConstant;
                        },
                        child: Text("Reset Colors to Default")),
                  ),
                ),*/
              ],
            ),
          );
        },
      ),
    );
  }
}
