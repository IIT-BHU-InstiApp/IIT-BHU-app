import 'package:flutter/material.dart';
import 'package:iit_app/external_libraries/spin_kit.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/screens/create.dart';
import 'package:iit_app/ui/workshop_custom_widgets.dart';

class ClubCustomWidgets {
  final BorderRadiusGeometry radius;
  final BuildContext context;
  final TabController tabController;
  final Function reload;

  final BuiltClubPost clubMap;
  final BuiltAllWorkshopsPost clubWorkshops;

  ClubCustomWidgets(
      {this.clubMap,
      this.clubWorkshops,
      this.radius,
      this.context,
      this.tabController,
      this.reload});

  final divide = Divider(height: 8.0, thickness: 2.0, color: Colors.blue);
  final space = SizedBox(height: 8.0);

  Widget getPanel({@required ScrollController sc, @required ClubListPost club}) {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      decoration: BoxDecoration(
        borderRadius: radius,
        color: ColorConstants.panelColor,
      ),
      child: ListView(
        controller: sc,
        children: [
          space,
          clubMap != null
              ? clubMap.is_por_holder == true
                  ? RaisedButton(
                      child: Text('Create workshop'),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CreateScreen(club: club, clubName: clubMap.name),
                          ),
                        );
                      })
                  : Container()
              : Container(),
          _getActiveAndPastTabBarForClub(
              clubWorkshops: clubWorkshops,
              tabController: tabController,
              context: context,
              reload: reload),
          space,
        ],
      ),
    );
  }

  static Widget _getWorkshops(workshops, Function reload) {
    return workshops == null
        ? Container(child: Center(child: LoadingCircle))
        : workshops.length == 0
            ? Center(
                child: Text('No workshops here :(',
                    style: TextStyle(color: Colors.white, fontSize: 25)))
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: workshops.length,
                padding: EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  return WorkshopCustomWidgets.getWorkshopCard(context,
                      w: workshops[index], reload: reload);
                },
              );
  }

  Widget _getActiveAndPastTabBarForClub(
      {BuiltAllWorkshopsPost clubWorkshops,
      @required TabController tabController,
      BuildContext context,
      Function reload}) {
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
            indicatorColor: ColorConstants.workshopCardContainer,
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
                    ? Container(child: Center(child: LoadingCircle))
                    : _getWorkshops(clubWorkshops.active_workshops, reload),
                clubWorkshops == null
                    ? Container(child: Center(child: LoadingCircle))
                    : _getWorkshops(clubWorkshops.past_workshops, reload),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
