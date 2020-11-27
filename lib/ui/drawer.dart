import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/ui/dialogBoxes.dart';
import 'package:iit_app/pages/club_entity/entityPage.dart';
import 'package:iit_app/ui/text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:built_collection/built_collection.dart';
import 'package:iit_app/services/authentication.dart' as authentication;

// TODO: when user click on list tile, navigation stack keeps filling,

class SideBar extends Drawer {
  final BuildContext context;
  SideBar({@required this.context});

  ListTile getNavItem(IconData icon, String s, String routeName,
      {bool replacement = false}) {
    return ListTile(
      leading: Icon(icon, color: ColorConstants.textColor),
      title: Text(s,
          style: Style.baseTextStyle.copyWith(color: ColorConstants.textColor)),
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: ColorConstants.backgroundThemeColor,
        child: ListView(
          children: <Widget>[
            Material(
              elevation: 2,
              color: ColorConstants.shimmerSkeletonColor,
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
                          image: (AppConstants.currentUser == null ||
                                  AppConstants.isGuest == true)
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
                              style: Style.titleTextStyle
                                  .copyWith(color: ColorConstants.textColor),
                            )
                          : Text(
                              AppConstants.currentUser.displayName,
                              style: Style.titleTextStyle
                                  .copyWith(color: ColorConstants.textColor),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: AppConstants.isGuest
                          ? Text(
                              'Guest User',
                              style: Style.baseTextStyle
                                  .copyWith(color: ColorConstants.textColor),
                            )
                          : Text(
                              AppConstants.currentUser.email,
                              style: Style.baseTextStyle
                                  .copyWith(color: ColorConstants.textColor),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            getNavItem(Icons.home, "Home", '/home', replacement: true),
            getNavItem(Icons.map, "Map", '/mapPage'),
            // getNavItem(Icons.local_dining, "Mess management", '/mess'),
            getNavItem(
                Icons.group_work, "All workshops and events", '/allWorkshops'),
            getNavItem(Icons.work_rounded, 'All Entities', '/allEntities'),
            _getActiveEntities(),
            AppConstants.isGuest
                ? ListTile(
                    title: Text("Account",
                        style: Style.baseTextStyle
                            .copyWith(color: ColorConstants.textColor)),
                    leading: Icon(Icons.account_box,
                        color: ColorConstants.textColor),
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
            // getNavItem(Icons.comment, "Complaints & Suggestions", '/complaints'),
            getNavItem(Icons.settings, "Settings", '/settings'),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: ColorConstants.textColor),
              title: AppConstants.isGuest
                  ? Text('Log In',
                      style: Style.baseTextStyle
                          .copyWith(color: ColorConstants.textColor))
                  : Text('Logout',
                      style: Style.baseTextStyle
                          .copyWith(color: ColorConstants.textColor)),
              onTap: () async {
                if (!AppConstants.isGuest) {
                  bool result = await getLogoutDialog(context, [
                    NetworkImage(AppConstants.currentUser.photoUrl),
                    AppConstants.currentUser.displayName,
                  ]);
                  if (result == true) {
                    await authentication.signOutGoogle();
                    await AppConstants.deleteLocalDatabaseOnly();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.clear();
                    AppConstants.isGuest = false;
                    Navigator.of(context).pushReplacementNamed('/login');
                  }
                } else {
                  await AppConstants.deleteLocalDatabaseOnly();
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.clear();
                  AppConstants.isGuest = false;
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              },
            ),
            getNavItem(Icons.info, "About", '/about'),
          ],
        ),
      ),
    );
  }

  Widget _getActiveEntities() {
    BuiltList<EntityListPost> entities =
        AppConstants.entitiesSummaryFromDatabase;
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: entities.length,
        itemBuilder: (context, index) {
          // if (!entities[index].is_permanent && entities[index].is_active){
          return ListTile(
            leading: Icon(
              Icons.new_releases,
              color: Colors.yellow,
            ),
            title: Text(
              entities[index].name,
              style:
                  Style.baseTextStyle.copyWith(color: ColorConstants.textColor),
            ),
            onTap: () {
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) =>
                      EntityPage(entity: entities[index])));
            },
          );
          // }
        });
  }
}
