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

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  CrudMethods crudObj = new CrudMethods();
  Stream workshops;
  TabController _tabController;

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
              accountName: Text("nishantkr.ece18"),
              accountEmail: Text("nishantkr.ece18@itbhu.ac.in"),
              currentAccountPicture: Image(
                  image: googleSignIn.currentUser == null
                      ? AssetImage('assets/profile_test.jpg')
                      : NetworkImage(photoUrl),
                  fit: BoxFit.cover)),
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
    _tabController = new TabController(length: 2, vsync: this);
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
      scrollDirection: Axis.vertical,
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
        backgroundColor: Colors.white70,
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8),
                child: Container(
                      height: 30.0,
                      width: 40.0,
                      child: Builder(
                        builder: (context) => GestureDetector(
                            onTap: () => Scaffold.of(context).openDrawer()),
                      ),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: googleSignIn.currentUser == null
                                  ? AssetImage('assets/profile_test.jpg')
                                  : NetworkImage(photoUrl),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                      //labelText: 'Search',
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0)))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 5.0),
              ),
              SizedBox(
                child: IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.notifications_active),
                  onPressed: () {},
                ),
              )
            ],
            bottom: TabBar(
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.black,
              tabs: [
                new Tab(text: 'Latest', ),
                new Tab(text: 'Interested'),
              ],
              controller: _tabController,
            ),
          ),
          drawer: getNavDrawer(context),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.of(context).pushNamed('/create'),
            child: Icon(Icons.add_box),
          ),
          body: TabBarView(
            children: <Widget>[
              Container(
                height: 400,
                child: _buildBody(context),
              ),
              Container(
                height: 400,
                child: _buildBody(context),
              ),
            ],
            controller: _tabController,
          )),
    );
  }
}
