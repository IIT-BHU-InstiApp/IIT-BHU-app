import 'package:flutter/material.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/pages/club/clubPage.dart';
import 'package:iit_app/model/appConstants.dart';

class CreatePageDialogBoxes {
  static showSuccesfulDialog({
    @required BuildContext context,
    @required ClubListPost club,
    bool isEditing = false,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Successful!"),
          content: isEditing
              ? Text("Workshop edited succesfully!")
              : Text("Workshop succesfully created!"),
          actions: <Widget>[
            FlatButton(
              child: Text("yay"),
              onPressed: () async {
                await AppConstants.updateAndPopulateWorkshops();
                Navigator.pop(context);
                if (isEditing) {
                  Navigator.pop(context);
                  return;
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  static Future showUnsuccessfulDialog({@required BuildContext context}) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Unsuccessful :("),
          content: Text("Please try again"),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  static Future<bool> confirmDialog({
    @required BuildContext context,
    String action,
  }) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(action + " workshop"),
          content: Text("Are you sure to " + action + " this?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Yup!"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            FlatButton(
              child: Text("Nope!"),
              onPressed: () {
                Navigator.of(context).pop(false);
                return false;
              },
            ),
          ],
        );
      },
    );
  }

  static Future<bool> confirmCalendarOpenDialog({@required BuildContext context}) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Open Calendar"),
          content: new Text(
              "You have expressed Interest!\nDo you want to save this event to your Google Calendar?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Yup!"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            FlatButton(
              child: Text("Nope."),
              onPressed: () {
                Navigator.of(context).pop(false);
                return false;
              },
            ),
          ],
        );
      },
    );
  }
}

Future<bool> getLogoutDialog(context, details) => showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
              height: 350.0,
              width: 200.0,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(height: 150.0),
                      Container(
                        height: 100.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                            color: Colors.teal),
                      ),
                      Positioned(
                          top: 50.0,
                          left: 94.0,
                          child: Container(
                            height: 90.0,
                            width: 90.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(45.0),
                                border: Border.all(
                                    color: Colors.white, style: BorderStyle.solid, width: 2.0),
                                image: DecorationImage(image: details[0], fit: BoxFit.cover)),
                          ))
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        details[1],
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 14.0,
                          fontWeight: FontWeight.w300,
                        ),
                      )),
                  SizedBox(height: 15.0),
                  FlatButton(
                      child: Center(
                        child: Text(
                          'Log Out',
                          style: TextStyle(
                              fontFamily: 'Montserrat', fontSize: 14.0, color: Colors.teal),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      color: Colors.transparent)
                ],
              )));
    });
