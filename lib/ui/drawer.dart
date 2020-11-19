import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/ui/dialogBoxes.dart';
import 'package:iit_app/ui/text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iit_app/services/authentication.dart' as authentication;

// TODO: when user click on list tile, navigation stack keeps filling,

class SideBar extends Drawer {
  final BuildContext context;
  SideBar({@required this.context});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Material(
            elevation: 2,
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 70.0,
                    width: 70.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: (AppConstants.currentUser == null || AppConstants.isGuest == true)
                            ? AssetImage('assets/guest.png')
                            : NetworkImage(AppConstants.currentUser.photoUrl),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      border: Border.all(color: Colors.blueGrey, width: 2.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: AppConstants.isGuest
                        ? Text(
                            'Welcome',
                            style: Style.titleTextStyle,
                          )
                        : Text(
                            AppConstants.currentUser.displayName,
                            style: Style.titleTextStyle,
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: AppConstants.isGuest
                        ? Text(
                            'Guest User',
                            style: Style.baseTextStyle.copyWith(color: Colors.white),
                          )
                        : Text(
                            AppConstants.currentUser.email,
                            style: Style.baseTextStyle.copyWith(color: Colors.white),
                          ),
                  ),
                ],
              ),
            ),
          ),
          getNavItem(Icons.home, "Home", '/home', replacement: true),
          getNavItem(Icons.map, "Map", '/mapPage'),
          getNavItem(Icons.local_dining, "Mess management", '/mess'),
          getNavItem(Icons.group_work, "All Workshops", '/allWorkshops'),
          AppConstants.isGuest
              ? ListTile(
                  title: Text("Account"),
                  leading: Icon(Icons.account_box),
                  // TODO: ask user to log in , may be in a dialog box

                  onTap: () {
                    Navigator.pop(context);
                    return Scaffold.of(context).showSnackBar(SnackBar(
                      elevation: 10,
                      content: Text('You must be logged in'),
                      duration: Duration(seconds: 2),
                    ));
                  },
                )
              : getNavItem(Icons.account_box, "Account", '/account'),
          getNavItem(Icons.comment, "Complaints & Suggestions", '/complaints'),
          getNavItem(Icons.settings, "Settings", '/settings'),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: AppConstants.isGuest ? Text('Log In') : Text('Logout'),
            onTap: () async {
              if (!AppConstants.isGuest) {
                bool result = await getLogoutDialog(context, [
                  NetworkImage(AppConstants.currentUser.photoUrl),
                  AppConstants.currentUser.displayName,
                ]);
                if (result == true) {
                  await authentication.signOutGoogle();
                  await AppConstants.deleteLocalDatabaseOnly();
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  AppConstants.isGuest = false;
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              } else {
                await AppConstants.deleteLocalDatabaseOnly();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                AppConstants.isGuest = false;
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
          getNavItem(Icons.info, "About", '/about'),
        ],
      ),
    );
  }

  ListTile getNavItem(IconData icon, String s, String routeName, {bool replacement = false}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(s),
      onTap: () {
        // pop closes the drawer
        Navigator.of(context).pop();
        // navigate to the route
        if (replacement)
          Navigator.of(context).pushReplacementNamed(routeName);
        else
          Navigator.of(context).pushNamed(routeName);
      },
    );
  }
}
