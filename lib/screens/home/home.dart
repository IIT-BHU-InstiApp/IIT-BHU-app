import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/pages/council.dart';
import 'package:iit_app/pages/login.dart';
import 'package:iit_app/screens/home/home_widgets.dart';
import 'package:iit_app/screens/home/search_workshop.dart';
import 'package:iit_app/services/crud.dart';
import 'package:built_collection/built_collection.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  CrudMethods crudObj = new CrudMethods();
  Stream workshops;
  TabController _tabController;

  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  TextEditingController _searchController = TextEditingController();

  bool _isSearching = false;
  var _searchPost;

  Drawer getNavDrawer(BuildContext context) {
    ListTile getNavItem(var icon, String s, String routeName,
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

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    print(this);

    fetchWorkshopsAndCouncilButtons();
    super.initState();
  }

  fetchWorkshopsAndCouncilButtons() async {
    await AppConstants.populateWorkshopsAndCouncilButtons();
    setState(() {
      AppConstants.firstTimeFetching = false;
    });
    fetchUpdatedDetails();
  }

  void fetchUpdatedDetails() async {
    await AppConstants.updateAndPopulateWorkshops();
    await AppConstants.writeCouncilLogosIntoDisk(
        AppConstants.councilsSummaryfromDatabase);
    setState(() {});
  }

  Future<void> refreshHome() async {
    setState(() {
      AppConstants.firstTimeFetching = true;
    });
    await AppConstants.updateAndPopulateWorkshops();
    setState(() {
      AppConstants.firstTimeFetching = false;
    });
  }

  FutureBuilder<Response> _buildWorkshopsFromSearch(BuildContext context) {
    return FutureBuilder<Response<BuiltAllWorkshopsPost>>(
      future: AppConstants.service.searchWorkshop(this._searchPost),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null ||
              (snapshot.data.body.active_workshops.isEmpty &&
                  snapshot.data.body.past_workshops.isEmpty)) {
            return Center(
              child: Text(
                'No Workshops found........',
                textAlign: TextAlign.center,
                textScaleFactor: 3,
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                textAlign: TextAlign.center,
                textScaleFactor: 1.3,
              ),
            );
          }

          final posts = snapshot.data.body;
          print(posts);
          return SearchWorkshopWidgets.buildWorkshopsFromSearchPosts(
              context, posts);
        } else {
          // Show a loading indicator while waiting for the posts
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<bool> _onPopHome() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: Text('Do you really want to exit?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('No'),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () => Navigator.pop(context, true),
                )
              ],
            ));
  }

  FutureBuilder<Response> _buildInterestedWorkshopsBody(BuildContext context) {
    return FutureBuilder<Response<BuiltList<BuiltWorkshopSummaryPost>>>(
      future: AppConstants.service
          .getInterestedWorkshops("token ${AppConstants.djangoToken}"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                textAlign: TextAlign.center,
                textScaleFactor: 1.3,
              ),
            );
          }

          final posts = snapshot.data.body;
          return _buildInterestedWorkshopPosts(context, posts);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  ListView _buildInterestedWorkshopPosts(
      BuildContext context, BuiltList<BuiltWorkshopSummaryPost> posts) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: posts.length,
      padding: EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return HomeWidgets.getWorkshopCard(context, w: posts[index]);
      },
    );
  }

  ListView _buildCurrentWorkshopPosts(
    BuildContext context,
  ) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: AppConstants.workshopFromDatabase.length,
      padding: EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return HomeWidgets.getWorkshopCard(
          context,
          w: AppConstants.workshopFromDatabase[index],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onPopHome,
        child: Scaffold(
          backgroundColor: Colors.blue[200],
          drawer: getNavDrawer(context),
          floatingActionButton: AppConstants.councilsSummaryfromDatabase == null
              ? FloatingActionButton(onPressed: null, child: Icon(Icons.menu))
              : FabCircularMenu(
                  key: fabKey,
                  ringColor: Colors.blue.withOpacity(0.8),
                  ringDiameter: 400,
                  ringWidth: 90,
                  fabSize: 65,
                  // animationDuration: Duration(milliseconds: 500),
                  fabOpenColor: Colors.red,
                  children:
                      AppConstants.councilsSummaryfromDatabase.map((council) {
                    File _imageFile = AppConstants.getImageFile(
                        isCouncil: true, isSmall: true, id: council.id);
                    return InkWell(
                      onTap: () {
                        // setting councilId in AppConstnts
                        AppConstants.currentCouncilId = council.id;
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CouncilPage(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: _imageFile != null
                                ? FileImage(_imageFile)
                                : NetworkImage(council.small_image_url),
                            fit: BoxFit.fill,
                          ),
                        ),
                        height: 50,
                        width: 50,
                      ),
                    );
                  }).toList()),
          appBar: AppBar(
            backgroundColor: Colors.blue[200],
            automaticallyImplyLeading: false,
            elevation: 0,
            actions: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(15, 8, 15, 0),
                child: Card(
                  elevation: 5.0,
                  color: Colors.blue[200],
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 10),
                        height: 35.0,
                        width: 35.0,
                        child: Builder(
                          builder: (context) => GestureDetector(
                              onTap: () => Scaffold.of(context).openDrawer()),
                        ),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AppConstants.currentUser == null
                                    ? AssetImage('assets/profile_test.jpg')
                                    : NetworkImage(
                                        AppConstants.currentUser.photoUrl),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(50.0)),
                      ),
                      //TODO: add the search UI to search_workshop.dart
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            //labelText: 'Search',
                            hintText: 'Search Workshops ...',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                if (this._searchController.text.isEmpty) {
                                  return;
                                }

                                this._isSearching = true;
                                this._searchPost =
                                    BuiltWorkshopSearchByStringPost((b) => b
                                      ..search_by = 'title'
                                      ..search_string =
                                          this._searchController.text);

                                setState(() {});
                              },
                            ),
                          ),
                          onFieldSubmitted: (value) {
                            if (value.isEmpty) return;
                            this._isSearching = true;
                            this._searchPost = BuiltWorkshopSearchByStringPost(
                                (b) => b
                                  ..search_by = 'title'
                                  ..search_string =
                                      this._searchController.text);

                            setState(() {});
                          },
                          controller: this._searchController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 8),
                        child: Container(
                          child: InkWell(
                            child: Icon(Icons.notifications_active,
                                color: Colors.black),
                            onTap: () {},
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
            bottom: this._isSearching
                ? PreferredSize(
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            color: Colors.lightBlueAccent.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0)),
                            elevation: 3,
                            splashColor: Colors.black12,
                            onPressed: () {
                              setState(() {
                                this._searchController.clear();
                                this._isSearching = false;
                              });
                            },
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Clear Search ',
                                ),
                                Icon(
                                  Icons.clear,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    preferredSize: Size.fromHeight(50))
                : null,
          ),
          body: Container(
            margin: EdgeInsets.fromLTRB(12, 10, 12, 0),
            decoration: new BoxDecoration(
                color: Color(0xFF736AB7),
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(40.0),
                    topRight: const Radius.circular(40.0))),

            // color: ,
            child: this._isSearching
                ? _buildWorkshopsFromSearch(context)
                : Column(
                    children: [
                      TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorColor: Colors.deepPurple,
                        // indicatorWeight: 2.5,
                        unselectedLabelColor: Colors.white70,
                        labelColor: Colors.black,
                        tabs: [
                          new Tab(text: 'Latest'),
                          new Tab(text: 'Interested'),
                        ],
                        controller: _tabController,
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: <Widget>[
                            Container(
                              child: AppConstants.firstTimeFetching
                                  ? Center(child: CircularProgressIndicator())
                                  : RefreshIndicator(
                                      displacement: 60,
                                      onRefresh: refreshHome,
                                      // () async {
                                      //   print('refreshed 111');
                                      //   await Future.delayed(
                                      //       Duration(seconds: 1));
                                      // },
                                      child:
                                          _buildCurrentWorkshopPosts(context)),
                            ),
                            Container(
                              child: _buildInterestedWorkshopsBody(context),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ));
  }
}
