import 'package:firebase_auth/firebase_auth.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CrudMethods {
  static Future<bool> isLoggedIn() async {
    AppConstants.currentUser = await FirebaseAuth.instance.currentUser();

    if (AppConstants.currentUser != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      AppConstants.djangoToken = prefs.getString('djangoToken');

      if (AppConstants.djangoToken == null) {
        String idToken = (await AppConstants.currentUser.getIdToken()).token;
        await verifyToken(idToken);
        await prefs.setString('djangoToken', AppConstants.djangoToken);
      } else {
        print(
            'DjangoToken from shared preferences: ${AppConstants.djangoToken}');
      }
    }

    if (AppConstants.currentUser != null && AppConstants.djangoToken != null) {
      return true;
    } else
      return false;
  }
}
