import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/screens/home/app_bar.dart';
import 'package:iit_app/screens/home/floating_action_button.dart';
import 'package:iit_app/screens/home/home_widgets.dart';
import 'package:iit_app/screens/home/search_workshop.dart';
import 'package:iit_app/screens/drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  SearchBarWidget searchBarWidget;
  ValueNotifier<bool> searchListener;

  final GlobalKey<FabCircularMenuState> fabKey =
      GlobalKey<FabCircularMenuState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    fetchWorkshopsAndCouncilButtons();

    searchListener = ValueNotifier(false);
    searchBarWidget = SearchBarWidget(searchListener);

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onPopHome,
      child: SafeArea(
        minimum: const EdgeInsets.all(2.0),
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: ColorConstants.homeBackground,
          drawer: SideBar(context: context),
          floatingActionButton: homeFAB(context, fabKey: fabKey),
          appBar: homeAppBar(context, searchBarWidget: searchBarWidget),
          body: Container(
            margin: EdgeInsets.fromLTRB(12, 10, 12, 0),
            decoration: BoxDecoration(
                color: ColorConstants.workshopContainerBackground,
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(40.0),
                    topRight: const Radius.circular(40.0))),
            child: ValueListenableBuilder(
              valueListenable: searchListener,
              builder: (context, isSearching, child) {
                return HomeChild(
                  context: context,
                  searchBarWidget: searchBarWidget,
                  tabController: _tabController,
                  isSearching: isSearching,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
