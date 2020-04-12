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
}
