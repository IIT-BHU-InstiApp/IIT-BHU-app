import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iit_app/external_libraries/spin_kit.dart';
import 'package:iit_app/screens/map.dart';
import 'package:iit_app/screens/account.dart';
import 'package:iit_app/screens/allWorkshops.dart';
import 'package:iit_app/screens/complaints.dart';
import 'package:iit_app/screens/home/home.dart';
import 'package:iit_app/screens/home/home_widgets.dart';
import 'package:iit_app/screens/mess/mess.dart';
import 'package:iit_app/pages/login.dart';
import 'package:iit_app/screens/about.dart';
import 'package:iit_app/screens/settings.dart';
import 'package:iit_app/services/connectivityCheck.dart';
import 'package:iit_app/services/crud.dart';
import 'package:iit_app/ui/theme.dart';
import 'data/post_api_service.dart';
import 'model/appConstants.dart';
import 'package:iit_app/services/pushNotification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  AppConstants.service = PostApiService.create();
  AppConstants.connectionStatus = ConnectionStatusSingleton.getInstance();
  AppConstants.connectionStatus.initialize();

// TODO: populating the ColorConstants. Use sharedPreference here to find out the correct theme.
  AppTheme.dark();

  await AppConstants.setDeviceDirectoryForImages();
  // bool logStatus = await CrudMethods.isLoggedIn();
  // print('log status: $logStatus');

  runApp(
      // Provider(
      //   builder: (_) => PostApiService.create(),
      //   dispose: (_, PostApiService service) => service.client.dispose(),
      //   create: (BuildContext context) {},
      // child:

      MaterialApp(
    debugShowCheckedModeBanner: false,
    // home: AppConstants.isLoggedIn ? HomeScreen() : LoginPage(),
    initialRoute: '/',
    routes: <String, WidgetBuilder>{
      // define the routes
      '/': (BuildContext context)=> ConnectedMain(),
      '/home': (BuildContext context) => HomeScreen(),
      '/mess': (BuildContext context) => MessScreen(),
      '/allWorkshops': (BuildContext context) => AllWorkshopsScreen(),
      '/account': (BuildContext context) => AccountScreen(),
      '/complaints': (BuildContext context) => ComplaintsScreen(),
      '/settings': (BuildContext context) => SettingsScreen(),
      '/login': (BuildContext context) => LoginPage(),
      '/about': (BuildContext context) => AboutPage(),
      '/mapScreen': (BuildContext context) => MapScreen(),
    },
  )

      // ),
      );
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

    super.initState();
    _initFCM();
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
                    child: HomeWidgets.connectionError,
                  ),
                ),
              )
            : ((AppConstants.isLoggedIn || AppConstants.isGuest) ? HomeScreen() : LoginPage()));
  }
}
