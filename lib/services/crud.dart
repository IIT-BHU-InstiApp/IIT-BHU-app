import 'package:firebase_auth/firebase_auth.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/sharedPreferenceKeys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iit_app/services/authentication.dart' as authentication;

class CrudMethods {
  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //checking if user has switched on guest mode
    if (prefs.getBool(SharedPreferenceKeys.isGuest) == true) {
      AppConstants.isGuest = true;
      AppConstants.djangoToken = null;
      return false;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      AppConstants.djangoToken =
          prefs.getString(SharedPreferenceKeys.djangoToken);

      if (AppConstants.djangoToken == null) {
        String idToken = (await user.getIdToken());
        await authentication.verifyToken(idToken);
        await prefs.setString(
            SharedPreferenceKeys.djangoToken, AppConstants.djangoToken);
      } else {
        print(
            'DjangoToken from shared preferences: ${AppConstants.djangoToken}');
      }

      await AppConstants.service
          .getProfile(AppConstants.djangoToken)
          .then((snapshot) {
        AppConstants.currentUser = snapshot.body;
      }).catchError((onError) {
        print('unable to fetch user profile $onError');
      });
    }

    if (user != null && AppConstants.djangoToken != null) {
      return true;
    } else
      return false;
  }
}
