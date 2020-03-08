import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/pages/login.dart';
import 'package:iit_app/pages/about.dart';
import 'package:iit_app/screens/home/home_widgets.dart';
import 'package:iit_app/services/crud.dart';

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
          getNavItem(Icons.add, "Create Workshop", '/create'),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('LogOut'),
            onTap: () async => {
              await signOutGoogle(),
              Navigator.of(context).pushReplacementNamed('/login')
            },
          ),
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

    fetchWorkshops();
    fetchCouncils();
    super.initState();
  }

  void fetchWorkshops() async {
    await AppConstants.populateWorkshops();
    setState(() {
      AppConstants.firstTimeFetching = false;
    });
    fetchUpdatedDetails();
  }

  void fetchCouncils() async {
    await AppConstants.populateCouncils();
    setState(() {});
  }

  void fetchUpdatedDetails() async {
    await AppConstants.updateAndPopulateWorkshops();
    setState(() {});
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

  // FutureBuilder<Response> _buildBody(BuildContext context) {
  //   // FutureBuilder is perfect for easily building UI when awaiting a Future
  //   // Response is the type currently returned by all the methods of PostApiService
  //   return FutureBuilder<Response<BuiltList<BuiltPost>>>(
  //     // In real apps, use some sort of state management (BLoC is cool)
  //     // to prevent duplicate requests when the UI rebuilds
  //     future: Provider.of<PostApiService>(context).getUpcomingWorkshops(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.done) {
  //         if (snapshot.hasError) {
  //           return Center(
  //             child: Text(
  //               snapshot.error.toString(),
  //               textAlign: TextAlign.center,
  //               textScaleFactor: 1.3,
  //             ),
  //           );
  //         }

  //         final posts = snapshot.data.body;
  //         print(posts);
  //         print('-------------------------------------');
  //         return _buildPosts(context, posts);
  //       } else {
  //         // Show a loading indicator while waiting for the posts
  //         return Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       }
  //     },
  //   );
  // }

  ListView _buildPosts(
    BuildContext context,
    // BuiltList<BuiltPost> posts
  ) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: AppConstants.workshops.length,
      // posts.length,
      padding: EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return HomeWidgets.getWorkshopCard(
          context,
          // w: Workshop.createWorkshopFromMap(posts[index])
          w: AppConstants.workshops[index],
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
                  onPressed: () {
                    print(AppConstants.currentUser.photoUrl);
                    print(AppConstants.currentUser);
                    // FirebaseAuth.instance.currentUser().then((value) {
                    //   print(value);
                    // });
                  },
                ),
              )
            ],
            bottom: TabBar(
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
            //shrinkWrap: true,
            children: <Widget>[
              Container(
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    Container(
                        height: 400,
                        child: AppConstants.firstTimeFetching
                            ? Center(child: CircularProgressIndicator())
                            : _buildPosts(context)),
                    Container(height: 400, child: _buildPosts(context))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(5, 400, 5, 20),
                child: AppConstants.councils == null
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return HomeWidgets.councilButton(context,
                              name: AppConstants.councils[index].name
                                  .toString()
                                  .substring(0, 4),
                              councilId: AppConstants.councils[index].id,
                              imageUrl:
                                  AppConstants.councils[index].small_image_url);
                        },
                        itemCount: AppConstants.councils.length,
                      ),
              ),
            ],
          ),
        ));
  }
}
