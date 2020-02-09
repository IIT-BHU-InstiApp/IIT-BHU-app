import 'package:flutter/material.dart';
import 'package:iit_app/data/workshop.dart';
import 'package:iit_app/pages/login.dart';
import 'package:iit_app/pages/about.dart';
import 'package:iit_app/screens/home/home_widgets.dart';
import 'package:iit_app/services/crud.dart';
import 'package:chopper/chopper.dart';
import 'package:provider/provider.dart';
import 'package:built_collection/built_collection.dart';

import 'package:iit_app/data/post_api_service.dart';
import 'package:iit_app/model/built_post.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CrudMethods crudObj = new CrudMethods();
  Stream workshops;

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
          DrawerHeader(child: Text("Header")),
          getNavItem(Icons.home, "Home", '/home', replacement: true),
          getNavItem(Icons.local_dining, "Mess management", '/mess'),
          getNavItem(Icons.group_work, "All Workshops", '/allWorkshops'),
          getNavItem(Icons.account_box, "Account", '/account'),
          getNavItem(Icons.comment, "Complaints & Suggestions", '/complaints'),
          getNavItem(Icons.settings, "Settings", '/settings'),
          AboutPageListTile.getAboutPageListTile(),
        ],
      ),
    );
  }

  @override
  void initState() {
    crudObj.getData().then((results) {
      setState(() {
        workshops = results;
      });
    });
    super.initState();
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

  FutureBuilder<Response> _buildBody(BuildContext context) {
    // FutureBuilder is perfect for easily building UI when awaiting a Future
    // Response is the type currently returned by all the methods of PostApiService
    return FutureBuilder<Response<BuiltList<BuiltPost>>>(
      // In real apps, use some sort of state management (BLoC is cool)
      // to prevent duplicate requests when the UI rebuilds
      future: Provider.of<PostApiService>(context).getPosts(),
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
          return _buildPosts(context, posts);
        } else {
          // Show a loading indicator while waiting for the posts
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  ListView _buildPosts(BuildContext context, BuiltList<BuiltPost> posts) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: posts.length,
      padding: EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return HomeWidgets.getWorkshopCard(context,
            w: Workshop.createWorkshopFromMap(posts[index]));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get User Details (for I am going or not?)
    // Get all Workshop JSONS
    // for every json: convert json to workshop object ; List<Widget> cardList = List.append(_buildCard(workshop))

    return WillPopScope(
      onWillPop: _onPopHome,
      child: Scaffold(
        drawer: getNavDrawer(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).pushNamed('/create'),
          child: Icon(Icons.add_box),
        ),
        body: Builder(
          builder: (context) => ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                    Stack(
                      children: <Widget>[
                        Container(height: 60.0, width: 60.0),
                        Container(
                          height: 50.0,
                          width: 50.0,
                          child: GestureDetector(onTap: () {
                            return HomeWidgets.getLogOutDialog(
                                context,
                                googleSignIn.currentUser == null
                                    ? [
                                        AssetImage('assets/profile_test.jpg'),
                                        ''
                                      ]
                                    : [NetworkImage(photoUrl), displayName]);
                          }),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: googleSignIn.currentUser == null
                                      ? AssetImage('assets/profile_test.jpg')
                                      : NetworkImage(photoUrl),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(25.0)),
                        ),
                        Positioned(
                          left: 5.0,
                          top: 40.0,
                          child: Container(
                            height: 15.0,
                            width: 15.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.5),
                                color: Colors.green,
                                border: Border.all(
                                    color: Colors.white,
                                    style: BorderStyle.solid,
                                    width: 1.0)),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 50, 30, 15),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Workshops today:',
                          style: TextStyle(
                            fontFamily: 'Opensans',
                            fontSize: 20.0,
                          )),
                      IconButton(
                          icon: Icon(Icons.more_horiz, color: Colors.black),
                          onPressed: () {}),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Container(
                  height: 300.0,
                  child: _buildBody(context),
                  // (workshops != null)
                  //     ? StreamBuilder(
                  //         stream: workshops,
                  //         builder: (context, snapshot) {
                  //           return ListView.builder(
                  //             scrollDirection: Axis.vertical,
                  //             itemCount: snapshot.data.documents.length,
                  //             itemBuilder: (context, i) {
                  //               return HomeWidgets.getWorkshopCard(context,
                  //                   w: Workshop.createWorkshopFromMap(
                  //                       snapshot.data.documents[i].data));
                  //             },
                  //           );
                  //         },
                  //       )
                  //     : Text('Loading'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
