import 'package:flutter/material.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/pages/club/club.dart';
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

  static Future showUnSuccessfulDialog({@required BuildContext context}) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("UnSuccessful :("),
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

  static Future<bool> confirmCalendarOpenDialog(
      {@required BuildContext context}) async {
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
