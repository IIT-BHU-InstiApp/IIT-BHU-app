import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iit_app/pages/login.dart';

class CrudMethods {
  static bool isLoggedIn() {
    signInWithGoogle();
    if (FirebaseAuth.instance.currentUser() != null)
      return true;
    else
      return false;
  }

  Future<void> addData(workshopData) async {
    if (isLoggedIn()) {
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
