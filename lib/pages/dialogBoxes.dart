import 'package:flutter/material.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/pages/club/club.dart';

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
              child: new Text("yay"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                if (isEditing) {
                  Navigator.pop(context);
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ClubPage(club: club, editMode: true)));
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

  static Future<bool> confirmDialog({
    @required BuildContext context,
    bool isEditing = false,
  }) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: isEditing ? Text("Edit workshop") : Text("Create workshop"),
          content: isEditing
              ? Text("Are you sure to edit this workshop?")
              : Text("Are you sure to create this new workshop?"),
          actions: <Widget>[
            FlatButton(
              child: new Text("Yup!"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            FlatButton(
              child: new Text("nope, let me rethink.."),
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
