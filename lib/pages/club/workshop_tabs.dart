import 'package:flutter/material.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/screens/home/home_widgets.dart';

class WorkshopTabs {
  static Widget _getWorkshops(workshops) {
    return workshops == null
        ? Container(child: Center(child: CircularProgressIndicator()))
        : workshops.length == 0
            ? Center(child: Text('No workshops here :('))
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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

  static Widget getActiveAndPastTabBarForClub(
      {BuiltAllWorkshopsPost clubWorkshops,
      @required TabController tabController,
      BuildContext context}) {
    return Container(
      margin: EdgeInsets.fromLTRB(12, 10, 12, 0),
      decoration: BoxDecoration(
          color: ColorConstants.workshopContainerBackground,
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      //constraints: BoxConstraints(minHeight: 600.0),
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        children: [
          TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Colors.deepPurple,
            unselectedLabelColor: Colors.white70,
            labelColor: Colors.black,
            tabs: [
              Tab(text: 'Active Workshops'),
              Tab(text: 'Past Workshops'),
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
