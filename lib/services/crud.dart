import 'package:firebase_auth/firebase_auth.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/sharedPreferenceKeys.dart';
import 'package:iit_app/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CrudMethods {
  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //checking if user has switched on guest mode
    if (prefs.getBool(SharedPreferenceKeys.isGuest) == true) {
      AppConstants.isGuest = true;
      AppConstants.djangoToken = null;
      return false;
    }

    AppConstants.currentUser = FirebaseAuth.instance.currentUser;

    if (AppConstants.currentUser != null) {
      AppConstants.djangoToken =
          prefs.getString(SharedPreferenceKeys.djangoToken);

      if (AppConstants.djangoToken == null) {
        String idToken = (await AppConstants.currentUser.getIdToken());
        await verifyToken(idToken);
        await prefs.setString(
            SharedPreferenceKeys.djangoToken, AppConstants.djangoToken);
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
