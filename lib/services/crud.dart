import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/pages/login.dart';

class CrudMethods {
  static Future<bool> isLoggedIn() async {
    AppConstants.currentUser = await FirebaseAuth.instance.currentUser();

    if(AppConstants.currentUser != null){
      String idToken = (await AppConstants.currentUser.getIdToken()).token;
      await verifyToken(idToken);
    }
    if (AppConstants.currentUser != null && AppConstants.djangoToken != null) {
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
