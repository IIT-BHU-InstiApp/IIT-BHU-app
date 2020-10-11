import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/screens/drawer.dart';
import 'package:iit_app/screens/home/buildWorkshops.dart';
import 'package:iit_app/screens/home/home_widgets.dart';
import 'package:iit_app/screens/home/search_workshop.dart';

class AllWorkshopsScreen extends StatefulWidget {
  @override
  _AllWorkshopsScreenState createState() => _AllWorkshopsScreenState();
}

class _AllWorkshopsScreenState extends State<AllWorkshopsScreen>
    with SingleTickerProviderStateMixin {
  SearchBarWidget searchBarWidget;
  TabController _tabController;
  ValueNotifier<bool> searchListener;
  FocusNode searchFocusNode;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);

    searchListener = ValueNotifier(false);
    searchBarWidget = SearchBarWidget(searchListener);
    searchFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    super.dispose();
  }

  Future<bool> onPop() async {
    if (!searchBarWidget.isSearching.value &&
        searchBarWidget.searchController.text.isEmpty &&
        searchFocusNode.hasFocus) {
      searchFocusNode.unfocus();
      Navigator.pop(context);
      Navigator.pushNamed(context, '/allWorkshops');
      return false;
    }
    if (searchBarWidget.isSearching.value) {
      searchFocusNode.unfocus();
      Navigator.pop(context);
      Navigator.pushNamed(context, '/allWorkshops');
      return false;
    }
    Navigator.pushNamed(context, '/home');
    return true;
  }

  FutureBuilder<Response> _buildAllWorkshopsBody(BuildContext context) {
    return FutureBuilder<Response<BuiltAllWorkshopsPost>>(
      future: AppConstants.service.getAllWorkshops(),
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

          print(posts);
          print('-------------------------------------');

          return _buildAllWorkshopPosts(context, posts);
        } else {
          // Show a loading indicator while waiting for the posts
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildAllWorkshopPosts(
      BuildContext context, BuiltAllWorkshopsPost posts) {
    return ListView(
      children: <Widget>[
        Padding(
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
        Padding(
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
              return HomeWidgets.getWorkshopCard(
                context,
                w: posts.past_workshops[index],
                isPast: true,
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onPop,
      child: SafeArea(
        minimum: const EdgeInsets.all(2.0),
        child: Scaffold(
          backgroundColor: ColorConstants.allWorkshopsBackground,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("All Workshops"),
            actions: <Widget>[
              Expanded(
                  child: searchBarWidget.getSearchTextField(context,
                      searchFocusNode: searchFocusNode)),
            ],
          ),
          drawer: SideBar(context: context),
          body: ValueListenableBuilder(
              valueListenable: searchListener,
              builder: (context, isSearching, child) {
                return (isSearching
                    ? buildWorkshopsFromSearch(
                        context: context,
                        searchPost: searchBarWidget.searchPost)
                    : _buildAllWorkshopsBody(context));
              }),
        ),
      ),
    );
  }
}
