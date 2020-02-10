import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iit_app/model/appConstants.dart';

class CrudMethods {
  static bool isLoggedIn() {
    if (AppConstants.currentUser != null)
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
