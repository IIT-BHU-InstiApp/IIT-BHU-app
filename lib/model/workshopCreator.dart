import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/pages/dialogBoxes.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:built_collection/built_collection.dart';

class WorkshopCreater {
  String title;
  String description;
  int clubId;
  String date;
  String time;
  String location;
  String audience;
  List<int> contactIds = [];
  Map<int, String> contactNameofId = {};
  // TODO: add image_url

  WorkshopCreater({String editingDate, String editingTime}) {
    if (editingDate == null) {
      date = convertDate(DateTime.now());
      time = converTime(TimeOfDay.now());
    } else {
      date = editingDate;
      time = editingTime;
    }
  }
  String convertDate(DateTime date) {
    return date.toString().substring(0, 10);
  }

  String converTime(TimeOfDay time) {
    return time.toString().substring(10, 15);
  }

  static String nameOfContact(String fullName) {
    print(fullName);
    var name = fullName.trim().split(' ');
    if (name.length < 2) return fullName;
    name = name.sublist(0, 2);
    return (name[0] + ' ' + name[1]);
  }

  static create({
    @required BuildContext context,
    @required WorkshopCreater workshop,
    @required ClubListPost club,
  }) async {
    final newWorkshop = BuiltWorkshopCreatePost((b) => b
      ..title = workshop.title
      ..description = workshop.description
      ..club = club.id
      ..date = workshop.date
      ..time = workshop.time
      ..location = workshop.location
      ..audience = workshop.audience
      ..contacts = workshop.contactIds.build().toBuilder());

    await AppConstants.service
        .postNewWorkshop("token ${AppConstants.djangoToken}", newWorkshop)
        .catchError((onError) {
      print('Error creating workshop: ${onError.toString()}');
      CreatePageDialogBoxes.showUnSuccessfulDialog(context: context);
    }).then((value) {
      if (value.isSuccessful) {
        print('Created!');
        CreatePageDialogBoxes.showSuccesfulDialog(context: context, club: club);
      }
    }).catchError((onError) {
      print('Error printing CREATED workshop: ${onError.toString()}');
    });
  }

  static edit(
      {@required BuildContext context,
      @required WorkshopCreater workshop,
      @required ClubListPost club,
      @required BuiltWorkshopDetailPost widgetWorkshopData}) async {
    final editedWorkshop = BuiltWorkshopDetailPost((b) => b
      ..title = workshop.title
      ..description = workshop.description
      ..date = workshop.date
      ..time = workshop.time
      ..location = workshop.location
      ..audience = workshop.audience);

    await AppConstants.service
        .updateWorkshopByPatch(widgetWorkshopData.id,
            "token ${AppConstants.djangoToken}", editedWorkshop)
        .catchError((onError) {
      print('Error editing workshop: ${onError.toString()}');
      CreatePageDialogBoxes.showUnSuccessfulDialog(context: context);
    }).then((value) {
      if (value.isSuccessful) {
        print('Edited!');
        CreatePageDialogBoxes.showSuccesfulDialog(
            context: context, club: club, isEditing: true);
      }
    }).catchError((onError) {
      print('Error printing EDITED workshop: ${onError.toString()}');
    });

    await AppConstants.service
        .updateContacts(
      widgetWorkshopData.id,
      "token ${AppConstants.djangoToken}",
      BuiltContacts(
        (b) => b..contacts = workshop.contactIds.build().toBuilder(),
      ),
    )
        .catchError((onError) {
      print('Error editing contacts in edited workshop: ${onError.toString()}');
      //  CreatePageDialogBoxes.showUnSuccessfulDialog(
      //     context: context);
    });
  }
}
