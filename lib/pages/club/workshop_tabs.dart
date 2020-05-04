import 'package:flutter/material.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/screens/home/home_widgets.dart';

class WorkshopTabs {
  static Widget _getWorkshops(workshops) {
    return workshops == null
        ? Container(child: Center(child: CircularProgressIndicator()))
        : workshops.length == 0
            ? Center(child: Text('No workshops here :('))
            : ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: workshops.length,
                padding: EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  return HomeWidgets.getWorkshopCard(
                    context,
                    w: workshops[index],
                  );
                },
              );
  }

  static Container getActiveAndPastTabBarForClub(
      {BuiltAllWorkshopsPost clubWorkshops,
      @required TabController tabController}) {
    return Container(
      margin: EdgeInsets.fromLTRB(12, 10, 12, 0),
      decoration: new BoxDecoration(
          color: Color(0xFF736AB7),
          borderRadius: new BorderRadius.all(Radius.circular(20.0))),
      height: 300,
      child: Column(
        children: [
          TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Colors.deepPurple,
            unselectedLabelColor: Colors.white70,
            labelColor: Colors.black,
            tabs: [
              new Tab(text: 'Active Workshops'),
              new Tab(text: 'Past Workshops'),
            ],
            controller: tabController,
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: <Widget>[
                clubWorkshops == null
                    ? Container(
                        child: Center(child: CircularProgressIndicator()))
                    : _getWorkshops(clubWorkshops.active_workshops),
                clubWorkshops == null
                    ? Container(
                        child: Center(child: CircularProgressIndicator()))
                    : _getWorkshops(clubWorkshops.past_workshops),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
