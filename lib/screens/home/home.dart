import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/pages/login.dart';
import 'package:iit_app/screens/home/home_widgets.dart';
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

    fetchWorkshopsAndCouncilButtons();
    super.initState();
  }

  void fetchWorkshopsAndCouncilButtons() async {
    await AppConstants.populateWorkshopsAndCouncilButtons();
    setState(() {
      AppConstants.firstTimeFetching = false;
    });
    fetchUpdatedDetails();
  }

  void fetchUpdatedDetails() async {
    await AppConstants.updateAndPopulateWorkshops();
    setState(() {});
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

          return _buildWorkshopsFromSearchPosts(context, posts);
        } else {
          // Show a loading indicator while waiting for the posts
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildWorkshopsFromSearchPosts(
      BuildContext context, BuiltAllWorkshopsPost posts) {
    return ListView(
      children: <Widget>[
        posts.active_workshops.isEmpty
            ? Container()
            : Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Text(
                    'Active Workshops',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
        Container(
          child: ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: posts.active_workshops.length,
            padding: EdgeInsets.all(8),
            itemBuilder: (context, index) {
              return HomeWidgets.getWorkshopCard(context,
                  w: posts.active_workshops[index]);
            },
          ),
        ),
        posts.past_workshops.isEmpty
            ? Container()
            : Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Text(
                    'Past Workshops',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
        Container(
          child: ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: posts.past_workshops.length,
            padding: EdgeInsets.all(8),
            itemBuilder: (context, index) {
              return HomeWidgets.getWorkshopCard(context,
                  w: posts.past_workshops[index]);
            },
          ),
        ),
      ],
    );
  }

  void refresh() async {
    setState(() {
      AppConstants.refreshingHomePage = true;
    });
    await AppConstants.updateAndPopulateWorkshops();
    setState(() {
      AppConstants.refreshingHomePage = false;
    });
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
    // FutureBuilder is perfect for easily building UI when awaiting a Future
    // Response is the type currently returned by all the methods of PostApiService
    return FutureBuilder<Response<BuiltList<BuiltWorkshopSummaryPost>>>(
      // In real apps, use some sort of state management (BLoC is cool)
      // to prevent duplicate requests when the UI rebuilds
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
          // print(posts);
          // print('-------------------------------------');
          return _buildInterestedWorkshopPosts(context, posts);
        } else {
          // Show a loading indicator while waiting for the posts
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
                          image: AppConstants.currentUser == null
                              ? AssetImage('assets/profile_test.jpg')
                              : NetworkImage(AppConstants.currentUser.photoUrl),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
              ),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    //labelText: 'Search',
                    hintText: 'Search by title ...',
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
                              ..search_string = this._searchController.text);

                        setState(() {});
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25.0),
                      ),
                    ),
                  ),
                  onFieldSubmitted: (value) {
                    if (value.isEmpty) return;
                    this._isSearching = true;
                    this._searchPost = BuiltWorkshopSearchByStringPost((b) => b
                      ..search_by = 'title'
                      ..search_string = this._searchController.text);

                    setState(() {});
                  },
                  controller: this._searchController,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 5.0),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Container(
                  child: InkWell(
                    child:
                        Icon(Icons.notifications_active, color: Colors.black),
                    onTap: () {
                      print(AppConstants.currentUser.photoUrl);
                      print(AppConstants.currentUser);
                      // FirebaseAuth.instance.currentUser().then((value) {
                      //   print(value);
                      // });
                    },
                  ),
                ),
              )
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
                : TabBar(
                    unselectedLabelColor: Colors.grey,
                    labelColor: Colors.black,
                    tabs: [
                      new Tab(
                        text: 'Latest',
                      ),
                      new Tab(text: 'Interested'),
                    ],
                    controller: _tabController,
                  ),
          ),
          drawer: getNavDrawer(context),
          body: Stack(
            children: <Widget>[
              Container(
                child: this._isSearching
                    ? _buildWorkshopsFromSearch(context)
                    : TabBarView(
                        controller: _tabController,
                        children: <Widget>[
                          Container(
                            height: 400,
                            child: AppConstants.firstTimeFetching
                                ? Center(child: CircularProgressIndicator())
                                : _buildCurrentWorkshopPosts(context),
                          ),
                          Container(
                            height: 400,
                            child: _buildInterestedWorkshopsBody(context),
                          )
                        ],
                      ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(5, 400, 5, 20),
                child: AppConstants.councilsSummaryfromDatabase == null
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return HomeWidgets.councilButton(context,
                              name: AppConstants
                                  .councilsSummaryfromDatabase[index].name
                                  .toString()
                                  .substring(0, 4),
                              councilId: AppConstants
                                  .councilsSummaryfromDatabase[index].id,
                              imageUrl: AppConstants
                                  .councilsSummaryfromDatabase[index]
                                  .small_image_url);
                        },
                        itemCount:
                            AppConstants.councilsSummaryfromDatabase.length,
                      ),
              ),
            ],
          ),
        ));
  }
}
