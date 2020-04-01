import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iit_app/model/appConstants.dart';

class CrudMethods {
  static Future<bool> isLoggedIn() async {
    AppConstants.currentUser = await FirebaseAuth.instance.currentUser();
    // print(AppConstants.currentUser);
    if (AppConstants.currentUser != null && AppConstants.djangoToken != null) {
      // AppConstants.service = PostApiService.create();
      return true;
    } else
      return false;
  }

  Future<void> addData(workshopData) async {
    bool isLoggedin = await isLoggedIn();
    if (isLoggedin) {
      // Firestore.instance
      //     .collection('workshop')
      //     .add(workshopData)
      //     .catchError((e) => print(e));
      Firestore.instance.runTransaction((Transaction crudTransaction) async {
        CollectionReference reference =
            Firestore.instance.collection('workshop');
        reference.add(workshopData);
      });
    } else
      print('You need to be logged in');
  }

  getData() async {
    return Firestore.instance.collection('workshop').snapshots();
  }
}
