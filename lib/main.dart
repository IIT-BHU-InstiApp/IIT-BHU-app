import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iit_app/external_libraries/spin_kit.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/pages/map/mapPage.dart';
import 'package:iit_app/pages/mess/mess.dart';
import 'package:iit_app/pages/account/accountPage.dart';
import 'package:iit_app/pages/allWorkshops/allWorkshopsPage.dart';
import 'package:iit_app/screens/complaints.dart';
import 'package:iit_app/pages/Home/homePage.dart';
import 'package:iit_app/pages/login/loginPage.dart';
import 'package:iit_app/pages/about/aboutPage.dart';
import 'package:iit_app/pages/settings/settingsPage.dart';
import 'package:iit_app/services/connectivityCheck.dart';
import 'package:iit_app/services/crud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/post_api_service.dart';
import 'model/appConstants.dart';
import 'package:iit_app/services/pushNotification.dart';

import 'model/sharedPreferenceKeys.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  AppConstants.service = PostApiService.create();
  AppConstants.connectionStatus = ConnectionStatusSingleton.getInstance();
  AppConstants.connectionStatus.initialize();

// TODO: populating the ColorConstants. Use sharedPreference here to find out the correct theme.
  ColorConstants.dark();

  await AppConstants.setDeviceDirectoryForImages();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: <String, WidgetBuilder>{
      // define the routes
      '/': (BuildContext context) => ConnectedMain(),
      '/home': (BuildContext context) => HomePage(),
      '/mess': (BuildContext context) => MessScreen(),
      '/allWorkshops': (BuildContext context) => AllWorkshopsScreen(),
      '/account': (BuildContext context) => AccountPage(),
      '/complaints': (BuildContext context) => ComplaintsScreen(),
      '/settings': (BuildContext context) => SettingsScreen(),
      '/login': (BuildContext context) => LoginPage(),
      '/about': (BuildContext context) => AboutPage(),
      '/mapPage': (BuildContext context) => MapPage(),
    },
  ));
}

class ConnectedMain extends StatefulWidget {
  @override
  _ConnectedMainState createState() => _ConnectedMainState();
}

class _ConnectedMainState extends State<ConnectedMain> {
  bool _isOnline;
  bool _tappable = true;

  @override
  void initState() {
    checkConnection();
    _setTheme();

    super.initState();
    _initFCM();
  }

  _setTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(SharedPreferenceKeys.usertheme) == 'light') {
      ColorConstants.light();
    } else {
      ColorConstants.dark();
    }
  }

  _initFCM() {
    Future.delayed(
      Duration(milliseconds: 300),
      () => PushNotification.initialize(context),
    );
  }

  void checkConnection() async {
    setState(() {
      this._tappable = false;
    });

    this._isOnline = await AppConstants.connectionStatus.checkConnection();

    print('tapped: online = ${this._isOnline.toString()}');

    if (this._isOnline == true && AppConstants.isLoggedIn == false) {
      AppConstants.isLoggedIn = await CrudMethods.isLoggedIn();
    }
    setState(() {
      this._tappable = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return this._isOnline == null
        ? Scaffold(
            body: Center(child: LoadingCircle),
          )
        : (this._isOnline == false
            ? Scaffold(
                body: Center(
                  child: GestureDetector(
                    onTap: this._tappable == false
                        ? null
                        : () {
                            checkConnection();
                          },
                    child: connectionError,
                  ),
                ),
              )
            : ((AppConstants.isLoggedIn || AppConstants.isGuest) ? HomePage() : LoginPage()));
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
        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20),
      ),
    ],
  );
}
