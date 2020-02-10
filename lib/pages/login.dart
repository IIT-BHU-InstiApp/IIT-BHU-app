import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

final GoogleSignIn googleSignIn = GoogleSignIn();
String photoUrl;
String displayName;
String responseIdToken;
FirebaseUser currentUser;

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  photoUrl = googleSignInAccount.photoUrl;
  displayName = googleSignInAccount.displayName;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );
  final FirebaseUser user =
      (await FirebaseAuth.instance.signInWithCredential(credential)).user;

  assert(!user.isAnonymous);
  String idToken = (await user.getIdToken()).token;
  assert(await user.getIdToken() != null);

  currentUser = await FirebaseAuth.instance.currentUser();
  assert(user.uid == currentUser.uid);

  verifyToken(idToken);

  return 'signInWithGoogle succeeded: $user';
}

void signOutGoogle() async {
  await googleSignIn.signOut();

  print("User Sign Out");
}

void verifyToken(String token) {
  var url = "https://workshops-app-backend.herokuapp.com/login/";
  var client = http.Client();
  var request = http.Request('POST', Uri.parse(url));
  var body = {'id_token': token};
  request.bodyFields = body;
  client.send(request).then((response) {
    response.stream.bytesToString().then((value) {
      responseIdToken = json.decode(value)['token'];
    }).catchError((error) {
      print(error.toString());
    });
  });
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
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
              onPressed: () {
                signInWithGoogle().whenComplete(() {
                  Navigator.of(context).pushReplacementNamed('/home');
                });
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
