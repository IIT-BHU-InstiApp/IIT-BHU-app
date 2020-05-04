import 'package:chopper/chopper.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/screens/home/app_bar.dart';
import 'package:iit_app/screens/home/floating_action_button.dart';
import 'package:iit_app/screens/home/home_widgets.dart';
import 'package:iit_app/screens/home/search_workshop.dart';
import 'package:built_collection/built_collection.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/screens/drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  SearchBarWidget searchBarWidget = SearchBarWidget();

  final GlobalKey<FabCircularMenuState> fabKey =
      GlobalKey<FabCircularMenuState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
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

  Future<bool> _onPopHome() async {
    if (fabKey.currentState.isOpen) {
      print('fab is open');
      fabKey.currentState.close();
      return false;
    }
    if (_scaffoldKey.currentState.isDrawerOpen) {
      print('drawer is open');
      Navigator.of(context).pop();

      return false;
    }
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
        child: SafeArea(
          minimum: const EdgeInsets.all(2.0),
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.blue[200],
            drawer: SideBar(context: context),
            floatingActionButton: homeFAB(context, fabKey: fabKey),
            appBar: homeAppBar(context, searchBarWidget: searchBarWidget),
            body: Container(
              margin: EdgeInsets.fromLTRB(12, 10, 12, 0),
              decoration: new BoxDecoration(
                  color: Color(0xFF736AB7),
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(40.0),
                      topRight: const Radius.circular(40.0))),
              child: searchBarWidget.isSearching
                  ? searchBarWidget.buildWorkshopsFromSearch(context)
                  : Column(
                      children: [
                        TabBar(
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorColor: Colors.deepPurple,
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
                                        child: _buildCurrentWorkshopPosts(
                                            context)),
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
          ),
        ));
  }
}
