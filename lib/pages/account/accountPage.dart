import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/screens/accountScreen.dart';

class AccountPage extends StatefulWidget {
  static String flag = "Account";
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  BuiltProfilePost profileDetails;

  @override
  void initState() {
    fetchProfileDetails();
    flagmarker();
    super.initState();
  }

  Future<String> _asyncInputDialog(
    BuildContext context,
    String queryName,
    String data,
  ) async {
    final controller = TextEditingController(text: data);
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter $queryName'),
          content: new Row(
            children: <Widget>[
              Expanded(
                  child: TextField(
                autofocus: true,
                controller: controller,
                decoration: InputDecoration(
                    labelText: queryName,
                    hintText: queryName == 'Phone No.' ? '+91987654321' : 'Sheldon Cooper'),
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
            ),
          ],
        );
      },
    );
  }

  Future showUnsuccessfulDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Unsuccessful :("),
          content: new Text("Please try again"),
          actions: <Widget>[
            FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void fetchProfileDetails() async {
    await AppConstants.service.getProfile(AppConstants.djangoToken).catchError((onError) {
      print("Error in fetching profile: ${onError.toString()}");
    }).then((value) {
      profileDetails = value.body;
      setState(() {});
    });
  }

  void updateProfileDetails(String name, String phoneNumber) async {
    final updatedProfile = BuiltProfilePost((b) => b
      ..name = name
      ..phone_number = phoneNumber);
    await AppConstants.service
        .updateProfileByPatch(AppConstants.djangoToken, updatedProfile)
        .then((value) {
      profileDetails = value.body;
      setState(() {});
    }).catchError((onError) {
      print("Error in updating profile: ${onError.toString()}");
      showUnsuccessfulDialog();
    });
  }

  Future<bool> onPop() {
    Navigator.pushNamedAndRemoveUntil(context, '/home', ModalRoute.withName('/'));
    return Future.value(false);
  }

  flagmarker() {
    AccountPage.flag = "Account";
    print(AccountPage.flag);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onPop,
      child: SafeArea(
          minimum: const EdgeInsets.all(2.0),
          child: AccountScreen(
            profileDetails: profileDetails,
            asyncInputDialog: _asyncInputDialog,
            updateProfileDetails: updateProfileDetails,
          )),
    );
  }
}
