import 'package:flutter/material.dart';
import 'package:iit_app/data/internet_connection_interceptor.dart';
import 'package:iit_app/external_libraries/fab_circular_menu.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/ui/workshop_custom_widgets.dart';
import '../services/buildWorkshops.dart' as buildWorkhops;

class HomeScreen extends StatefulWidget {
  final BuildContext context;
  final GlobalKey<FabCircularMenuState> fabKey;
  final Function(bool refreshed) reload;

  const HomeScreen({Key key, this.context, this.fabKey, this.reload})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  void onRefresh() async {
    try {
      await AppConstants.updateAndPopulateWorkshops();
    } on InternetConnectionException catch (_) {
      AppConstants.internetErrorFlushBar.showFlushbar(context);
      return;
    } catch (err) {
      print(err);
    }
    this.widget.reload(true);
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
          indicatorColor: ColorConstants.workshopCardContainer,
          onTap: (value) {
            if (widget.fabKey.currentState.isOpen) {
              widget.fabKey.currentState.close();
            }
          },
          tabs: [
            Tab(text: 'Workshops'),
            Tab(text: 'Events'),
          ],
          controller: _tabController,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              Container(
                child: AppConstants.firstTimeFetching
                    ? WorkshopCustomWidgets.getPlaceholder()
                    : RefreshIndicator(
                        displacement: 60,
                        onRefresh: () async => onRefresh(),
                        child: buildWorkhops.buildCurrentWorkshopAndEventPosts(
                            context, widget.fabKey,
                            isEvent: false, reload: onRefresh),
                      ),
              ),
              Container(
                child: AppConstants.firstTimeFetching
                    ? WorkshopCustomWidgets.getPlaceholder()
                    : RefreshIndicator(
                        displacement: 60,
                        onRefresh: () async => onRefresh(),
                        child: buildWorkhops.buildCurrentWorkshopAndEventPosts(
                            context, widget.fabKey,
                            isEvent: true, reload: onRefresh),
                      ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
