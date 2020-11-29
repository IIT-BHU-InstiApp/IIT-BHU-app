import 'package:flutter/material.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/ui/club_council_entity_common/club_council_entity_widgets.dart';
import 'package:iit_app/ui/club_entity_common.dart';

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

  Widget getPanel(
      {@required ScrollController sc, @required ClubListPost club}) {
    return Container(
      padding: EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        borderRadius: radius,
        color: ColorConstants.panelColor,
      ),
      child: ListView(
        controller: sc,
        children: [
          space,
          ClubAndEntityWidgets.getWorkshopEventTabBar(
              workshops: clubWorkshops,
              tabController: tabController,
              context: context,
              reload: reload),
          space,
        ],
      ),
    );
  }
}
