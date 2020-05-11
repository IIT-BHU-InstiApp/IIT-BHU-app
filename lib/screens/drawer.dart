import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iit_app/pages/login.dart';

// TODO: when user click on list tile, navigation stack keeps filling,

class SideBar extends Drawer {
  final BuildContext context;
  SideBar({@required this.context});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: AppConstants.isGuest
                ? Text('Welcome')
                : Text(AppConstants.currentUser.displayName),
            accountEmail: AppConstants.isGuest
                ? Text('Guest User')
                : Text(AppConstants.currentUser.email),
            currentAccountPicture: Image(
                image: (AppConstants.currentUser == null ||
                        AppConstants.isGuest == true)
                    ? AssetImage('assets/guest.png')
                    : NetworkImage(AppConstants.currentUser.photoUrl),
                fit: BoxFit.cover),
          ),
          getNavItem(Icons.home, "Home", '/home', replacement: true),
          getNavItem(Icons.map, "Map", '/mapScreen'),
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
            title: AppConstants.isGuest ? Text('Log In') : Text('LogOut'),
            onTap: () async {
              await signOutGoogle();
              await AppConstants.deleteLocalDatabaseOnly();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
          getNavItem(Icons.info, "About", '/about'),
        ],
      ),
    );
  }

  ListTile getNavItem(IconData icon, String s, String routeName,
      {bool replacement = false}) {
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
