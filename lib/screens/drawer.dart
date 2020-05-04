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
              accountName: Text(AppConstants.currentUser.displayName),
              accountEmail: Text(AppConstants.currentUser.email),
              currentAccountPicture: Image(
                  image: AppConstants.currentUser == null
                      ? AssetImage('assets/profile_test.jpg')
                      : NetworkImage(AppConstants.currentUser.photoUrl),
                  fit: BoxFit.cover)),
          getNavItem(Icons.home, "Home", '/home', replacement: true),
          getNavItem(Icons.map, "Map", '/mapScreen'),
          getNavItem(Icons.local_dining, "Mess management", '/mess'),
          getNavItem(Icons.group_work, "All Workshops", '/allWorkshops'),
          getNavItem(Icons.account_box, "Account", '/account'),
          getNavItem(Icons.comment, "Complaints & Suggestions", '/complaints'),
          getNavItem(Icons.settings, "Settings", '/settings'),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('LogOut'),
            onTap: () async {
              await signOutGoogle();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
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
