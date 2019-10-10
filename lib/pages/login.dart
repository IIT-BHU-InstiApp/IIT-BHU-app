// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/screens/home.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = "/Login";
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // String _email;
    // String _password;

    // GoogleSignIn googleAuth = new GoogleSignIn();

    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
              child: Text('Welcome to IIT(BHU)\'s Workshops App.',
                  style:
                      TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 15),
            OutlineButton(
              splashColor: Colors.grey,
              onPressed: () => Navigator.of(context).pushReplacementNamed(HomeScreen.routeName),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              highlightElevation: 0,
              borderSide: BorderSide(color: Colors.grey),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                        image: AssetImage("assets/google_logo.png"),
                        height: 25.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Login Using Institute ID.',
                  style: TextStyle(fontFamily: 'Montserrat'),
                ),
                // SizedBox(width: 5.0),
                // InkWell(
                //   // onTap: () {
                //   //   Navigator.of(context).pushNamed('/signup');
                //   // },
                //   child: Text(
                //     'Register',
                //     style: TextStyle(
                //         color: Colors.green,
                //         fontFamily: 'Montserrat',
                //         fontWeight: FontWeight.bold,
                //         decoration: TextDecoration.underline),
                //   ),
                // )
              ],
            )
          ],
        ));
  }
}
