import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/data/post_api_service.dart';
import 'package:iit_app/external_libraries/spin_kit.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/model/sharedPreferenceKeys.dart';
import 'package:iit_app/services/connectivityCheck.dart';
import 'package:iit_app/services/crud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class Initiation extends StatefulWidget {
  @override
  _InitiationState createState() => _InitiationState();
}

class _InitiationState extends State<Initiation> {
  VideoPlayerController _controller;
  bool _isOnline = false;
  bool _tappable = true;

  _initVideo() {
    _controller = VideoPlayerController.asset('assets/animated_logo.mp4')
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        // Ensure the first frame is shown after the video is initialized
        setState(() {});
        _initServices();
      });
  }

  _initServices() async {
    await Firebase.initializeApp();

    AppConstants.service = PostApiService.create();
    AppConstants.connectionStatus = ConnectionStatusSingleton.getInstance();
    AppConstants.connectionStatus.initialize();

    await AppConstants.setDeviceDirectoryForImages();
    await _initTheme();

    _checkConnection();
  }

  Future _checkConnection({bool tryAgain = false}) async {
    if (tryAgain) {
      setState(() {
        this._tappable = false;
      });
    }

    this._isOnline = await AppConstants.connectionStatus.checkConnection();
    if (this._isOnline == true) {
      AppConstants.isLoggedIn = await CrudMethods.isLoggedIn();
      await Future.delayed(
          Duration(milliseconds: AppConstants.isLoggedIn == true ? 500 : 1500));
      await Navigator.of(context)
          .popAndPushNamed('/root', arguments: {'initFCM': true});
    } else {
      setState(() {
        this._tappable = true;
      });
    }
  }

  _initTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(SharedPreferenceKeys.usertheme) == 'light') {
      ColorConstants.setLight();
    } else {
      ColorConstants.setDark();
    }
  }

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: this._isOnline
            ? Center(
                child: this._tappable == false
                    ? LoadingCircle
                    : GestureDetector(
                        onTap: () {
                          _checkConnection(tryAgain: true);
                        },
                        child: connectionError,
                      ),
              )
            :
            // Center(child: Text('hesdklfjsf')),
            SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: SizedBox(
                    width: _controller.value.size?.width ?? 0,
                    height: _controller.value.size?.height ?? 0,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
      ),
    );
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
        style: TextStyle(
            color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20),
      ),
    ],
  );
}
