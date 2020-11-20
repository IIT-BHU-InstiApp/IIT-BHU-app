import 'package:chopper/chopper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/ui/dialogBoxes.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:built_collection/built_collection.dart';
import 'package:uuid/uuid.dart';

class WorkshopCreater {
  String title;
  String description;
  int clubId;
  String date;
  String time;
  String location;
  String latitude;
  String longitude;
  String audience;
  List<int> contactIds = [];
  Map<int, String> contactNameofId = {};
  Map<int, String> tagNameofId = {};
  String link;

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

  create({
    @required BuildContext context,
    @required ClubListPost club,
    MemoryImage image,
  }) async {
    var newWorkshop = BuiltWorkshopCreatePost((b) => b
      ..title = title
      ..description = description
      ..club = club.id
      ..date = date
      ..time = time
      ..location = location
      ..latitude = latitude
      ..longitude = longitude
      ..audience = audience
      ..contacts = contactIds.build().toBuilder()
      ..tags = tagNameofId.keys.toList().build().toBuilder()
      ..link = link);

    await AppConstants.service
        .postNewWorkshop(AppConstants.djangoToken, newWorkshop)
        .then((value) async {
      if (value.isSuccessful) {
        print('Created!');
        final imageUrl = await _uploadImageToFirestore(image);
        if (imageUrl != null) {
          await AppConstants.service.updateWorkshopByPatch(value.body.id, AppConstants.djangoToken,
              BuiltWorkshopDetailPost((b) => b..image_url = imageUrl));
        }
        CreatePageDialogBoxes.showSuccesfulDialog(context: context, club: club);
      }
    }).catchError((onError) {
      print('Error printing CREATED workshop: ${onError.toString()}');
    });
  }

  static Future<String> _uploadImageToFirestore(MemoryImage memoryImage) async {
    if (memoryImage == null) return null;

    final uuid = Uuid().v4();
    final storageRef = FirebaseStorage.instance.ref().child('workshops');
    final uploadTask = storageRef.child(uuid).putData(memoryImage.bytes);
    return await uploadTask.then((val) async => await val.ref.getDownloadURL(), onError: () {
      print('image could not be uploaded');
      return null;
    });
  }

  static Future<void> deleteImageFromFirestore(String imageUrl) async {
    if (imageUrl == null) return;
    try {
      await FirebaseStorage.instance.refFromURL(imageUrl).delete();
    } catch (e) {
      print('image could not be deleted: ${e.toString()}');
    }
  }

  edit({
    @required BuildContext context,
    @required ClubListPost club,
    @required BuiltWorkshopDetailPost widgetWorkshopData,
    NetworkImage oldImage,
    MemoryImage newImage,
  }) async {
    final editedWorkshop = BuiltWorkshopDetailPost((b) => b
      ..title = title
      ..description = description
      ..date = date
      ..time = time
      ..location = location
      ..latitude = latitude
      ..longitude = longitude
      ..audience = audience
      ..link = link);

    await AppConstants.service
        .updateWorkshopByPatch(widgetWorkshopData.id, AppConstants.djangoToken, editedWorkshop)
        .catchError((onError) {
      print('Error editing workshop: ${onError.toString()}');
      CreatePageDialogBoxes.showUnsuccessfulDialog(context: context);
    }).then((value) async {
      if (value.isSuccessful) {
        print('Edited!');
        if (widgetWorkshopData.image_url != null && oldImage == null) {
          await deleteImageFromFirestore(widgetWorkshopData.image_url);
        }
        if (newImage != null) {
          final imageUrl = await _uploadImageToFirestore(newImage);
          if (imageUrl != null) {
            await AppConstants.service.updateWorkshopByPatch(value.body.id,
                AppConstants.djangoToken, BuiltWorkshopDetailPost((b) => b..image_url = imageUrl));
          }
        }
        CreatePageDialogBoxes.showSuccesfulDialog(context: context, club: club, isEditing: true);
      }
    }).catchError((onError) {
      print('Error printing EDITED workshop: ${onError.toString()}');
    });

    await AppConstants.service
        .updateContacts(
      widgetWorkshopData.id,
      AppConstants.djangoToken,
      BuiltContacts(
        (b) => b..contacts = contactIds.build().toBuilder(),
      ),
    )
        .catchError((onError) {
      print('Error editing contacts in edited workshop: ${onError.toString()}');
      //  CreatePageDialogBoxes.showUnsuccessfulDialog(
      //     context: context);
    });

    await AppConstants.service
        .updateTags(
            widgetWorkshopData.id,
            AppConstants.djangoToken,
            BuiltTags(
              (b) => b..tags = tagNameofId.keys.toList().build().toBuilder(),
            ))
        .catchError((onError) {
      print('Error editing contacts in edited workshop: ${onError.toString()}');
    });
  }
}
