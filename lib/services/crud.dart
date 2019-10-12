import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CrudMethods {
  static bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null)
      return true;
    else
      return false;
  }

  Future<void> addData(workshopData) async {
    if (isLoggedIn())
      Firestore.instance
          .collection('workshop')
          .add(workshopData)
          .catchError((e) => print(e));
    else
      print('You need to be logged in');
  }

  getData() async {
    return await Firestore.instance.collection('workshop').getDocuments();
  }
}
