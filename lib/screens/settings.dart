import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/colorConstants.dart';
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

  ValueNotifier<Color> _colorListener;
  ColorPicker _colorPicker;

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
              title: Text("Settings"),
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
                        ? CircularProgressIndicator()
                        : RaisedButton(
                            onPressed: onResetDatabase,
                            child: Text("Reset Saved Data")),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: RaisedButton(
                      onPressed: () =>
                          _colorPicker.getColorPickerDialogBox(context),
                      child: Text('Pick Color for theme')),
                ),
                Container(
                  child: Center(
                    child: RaisedButton(
                        onPressed: () {
                          setState(() {
                            AppConstants.chooseColorPaletEnabled = true;
                          });
                        },
                        child: Text("Enable Color Customization")),
                  ),
                ),
                Container(
                  child: Center(
                    child: RaisedButton(
                        onPressed: () {
                          setState(() {
                            AppConstants.chooseColorPaletEnabled = false;
                            ColorConstants.resetToDefault();
                          });
                        },
                        child: Text("Reset Colors to Default")),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
