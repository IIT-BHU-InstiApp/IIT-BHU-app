import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['profile', 'email', 'openid'],
  hostedDomain: 'itbhu.ac.in',
);

Future<User> signInWithGoogle() async {
  GoogleSignInAccount googleSignInAccount;
  try {
    googleSignInAccount = await _googleSignIn.signIn();
  } catch (e) {
    print('google sign in error: ${e.toString()}');
    return null;
  }
  if (googleSignInAccount == null) {
    return null;
  }

  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  User user;
  try {
    user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
  } catch (e) {
    print('firebase sign in error: ${e.toString()}');
    await signOutGoogle();
    return null;
  }

  assert(!user.isAnonymous);

  String idToken = (await user.getIdToken());

  assert(await user.getIdToken() != null);

  final currentUser = FirebaseAuth.instance.currentUser;

  assert(user.uid == currentUser.uid);

  await verifyToken(idToken);

  return currentUser;
}

verifyToken(String idToken) async {
  final LoginPost logInCredentials = LoginPost(
    (b) => b..id_token = idToken,
  );
  await AppConstants.service.logInPost(logInCredentials).catchError((onError) {
    print('Error in requesting requesting token: $onError');
  }).then((response) {
    if (response.isSuccessful) {
      print('successfully verified token with backend');
      AppConstants.djangoToken = "token ${response.body.token}";
      print(
          'DjangoToken from backend (with "token" added in beginning): ${AppConstants.djangoToken}');
    }
  });
}

Future<void> signOutGoogle() async {
  if (_googleSignIn != null) {
    await _googleSignIn.signOut();
  }
  await FirebaseAuth.instance.signOut();
  AppConstants.djangoToken = null;
  AppConstants.unsubscribeFromAllClubs();
  print("User Sign Out");
}
