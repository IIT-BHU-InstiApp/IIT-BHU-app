import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:iit_app/model/appConstants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

final GoogleSignIn googleSignIn = GoogleSignIn();
String photoUrl;
String displayName;
String responseIdToken;
FirebaseUser currentUser;

Future<FirebaseUser> signInWithGoogle() async {
  GoogleSignInAccount googleSignInAccount;
  try {
    googleSignInAccount = await googleSignIn.signIn();
  } catch (e) {
    print('google sign in error: ${e.toString()}');
    return null;
  }

  print(googleSignInAccount);
  if (googleSignInAccount == null) {
    return null;
  }

  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  photoUrl = googleSignInAccount.photoUrl;
  displayName = googleSignInAccount.displayName;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );
  // final FirebaseUser user =
  //     (await FirebaseAuth.instance.signInWithCredential(credential)).user;

  FirebaseUser user;
  try {
    user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
  } catch (e) {
    print('firebase sign in error: ${e.toString()}');
    await signOutGoogle();
    return null;
  }

  assert(!user.isAnonymous);

  String idToken = (await user.getIdToken()).token;

  assert(await user.getIdToken() != null);

  currentUser = await FirebaseAuth.instance.currentUser();

  assert(user.uid == currentUser.uid);

  await verifyToken(idToken);

  return currentUser;
}

verifyToken(String token) async {
  var url = "https://workshops-app-backend.herokuapp.com/login/";
  var client = http.Client();
  var request = http.Request('POST', Uri.parse(url));
  var body = {'id_token': token};
  request.bodyFields = body;
  var response = await client.send(request);
  try {
    var value = await response.stream.bytesToString();
    responseIdToken = json.decode(value)['token'];
    AppConstants.djangoToken = responseIdToken;
    print('DjangoToken: $responseIdToken');
  } catch (e) {
    print('django auth token error: ${e.toString()}');
  }
}

Future<void> signOutGoogle() async {
  if (googleSignIn != null) {
    await googleSignIn.signOut();
    FirebaseAuth.instance.currentUser().then((user) {
      if (user != null) {
        user.delete();
      }
    });
  }
  AppConstants.djangoToken = null;
  print("User Sign Out");
}

void errorDialog(BuildContext context) {
  AppConstants.logInButtonEnabled = true;

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Center(child: Text('OOPS....')),
      titlePadding: EdgeInsets.all(15),
      content: InkWell(
        splashColor: Colors.red,
        onTap: () {
          Navigator.of(context).pushReplacementNamed('/login');
        },
        child: Container(
          height: 175,
          width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/sorry.png'),
              Text('Sign in failed.'),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: true,
  );
}

class _LoginPageState extends State<LoginPage> {
  bool _loading;
  @override
  void initState() {
    this._loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: _loading
            ? Center(
                child: CircularProgressIndicator(backgroundColor: Colors.black))
            : ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                    child: Text('Welcome to IIT(BHU)\'s Workshops App.',
                        style: TextStyle(
                            fontSize: 40.0, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 15),
                  OutlineButton(
                    splashColor: Colors.grey,
                    onPressed: AppConstants.logInButtonEnabled == false
                        ? null
                        : () async {
                            if (AppConstants.logInButtonEnabled == true) {
                              print(
                                  'appConstants.logInButtonEnabled : ${AppConstants.logInButtonEnabled}');
                              AppConstants.logInButtonEnabled = false;

                              setState(() {
                                this._loading = true;
                              });

                              AppConstants.currentUser =
                                  await signInWithGoogle();

                              AppConstants.logInButtonEnabled = true;

                              if (AppConstants.currentUser == null ||
                                  AppConstants.djangoToken == null) {
                                setState(() {
                                  this._loading = false;
                                });

                                await signOutGoogle();

                                return errorDialog(context);
                              } else {
                                // AppConstants.service = PostApiService.create();
                                AppConstants.firstTimeFetching =
                                    await AppConstants
                                        .isWorkshopDatabaseEmpty();

                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/home', (r) => false);
                                // pushReplacementNamed('/home');
                              }
                            }

                            setState(() {});
                          },
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
                    ],
                  )
                ],
              ));
  }
}
