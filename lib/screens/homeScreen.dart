import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/pages/Home/home_widgets.dart';
import '../screens/home/buildWorkshops.dart' as buildWorkhops;

class HomeScreen extends StatefulWidget {
  final BuildContext context;
  final GlobalKey<FabCircularMenuState> fabKey;
  final Function reload;

  const HomeScreen({Key key, this.context, this.fabKey, this.reload}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;

  void onRefresh() async {
    await AppConstants.updateAndPopulateWorkshops();
    this.widget.reload();
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: Colors.deepPurple,
          unselectedLabelColor: Colors.white70,
          labelColor: Colors.black,
          onTap: (value) {
            if (widget.fabKey.currentState.isOpen) {
              widget.fabKey.currentState.close();
            }
          },
          tabs: [
            Tab(text: 'Latest'),
            Tab(text: 'Interested'),
          ],
          controller: _tabController,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              Container(
                child: AppConstants.firstTimeFetching
                    ? HomeWidgets.getPlaceholder()
                    : RefreshIndicator(
                        displacement: 60,
                        onRefresh: () async => onRefresh(),
                        child: buildWorkhops.buildCurrentWorkshopPosts(context, widget.fabKey,
                            reload: onRefresh),
                      ),
              ),
              Container(
                child: AppConstants.isGuest
                    ? Container(
                        margin: EdgeInsets.symmetric(vertical: 70, horizontal: 20),
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'We value your interest, but first you have to trust us by logging in.   {Dear Guest, it can not be one sided.}',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      )
                    : buildWorkhops.buildInterestedWorkshopsBody(
                        context,
                        widget.fabKey,
                        reload: onRefresh,
                      ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
