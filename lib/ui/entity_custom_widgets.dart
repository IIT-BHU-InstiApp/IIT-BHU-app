import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iit_app/external_libraries/spin_kit.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/ui/club_council_common/club_&_council_widgets.dart';
import 'package:iit_app/pages/club_entity/entityPage.dart';
import 'package:iit_app/ui/separator.dart';
import 'package:iit_app/ui/text_style.dart';
import 'package:iit_app/ui/workshop_custom_widgets.dart';

class EntityCustomWidgets {
  final BorderRadiusGeometry radius;
  final BuildContext context;
  final TabController tabController;
  final Function reload;

  final BuiltEntityPost entityMap;
  final BuiltAllWorkshopsPost entityWorkshops;

  EntityCustomWidgets(
      {this.entityMap,
      this.entityWorkshops,
      this.radius,
      this.context,
      this.tabController,
      this.reload});

  final divide = Divider(height: 8.0, thickness: 2.0, color: Colors.blue);
  final space = SizedBox(height: 8.0);

  Widget getPanel(
      {@required ScrollController sc, @required EntityListPost entity}) {
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
          SizedBox(
            height: ClubCouncilAndEntityWidgets.getMinPanelHeight(context),
          ),
          _getActiveAndPastTabBarForEntity(
              entityWorkshops: entityWorkshops,
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
                  return WorkshopCustomWidgets.getWorkshopOrEventCard(context,
                      w: workshops[index], reload: reload);
                },
              );
  }

  Widget _getActiveAndPastTabBarForEntity(
      {BuiltAllWorkshopsPost entityWorkshops,
      @required TabController tabController,
      BuildContext context,
      Function reload}) {
    return Container(
      margin: EdgeInsets.fromLTRB(12, 10, 12, 0),
      decoration: BoxDecoration(
          color: ColorConstants.workshopContainerBackground,
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
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
                entityWorkshops == null
                    ? Container(child: Center(child: LoadingCircle))
                    : _getWorkshops(entityWorkshops.active_workshops, reload),
                entityWorkshops == null
                    ? Container(child: Center(child: LoadingCircle))
                    : _getWorkshops(entityWorkshops.past_workshops, reload),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget getEntityCard(
    BuildContext context, {
    EntityListPost entity,
  }) {
    final File entityLogoFile =
        AppConstants.getImageFile(isSmall: true, id: entity.id, isEntity: true);

    final entityThumbnail = Container(
      margin: EdgeInsets.symmetric(vertical: 16.0),
      alignment: FractionalOffset.center,
      child: Hero(
        tag: "e-hero-${entity.id}",
        child: Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image(
              fit: BoxFit.contain,
              image:
                  entity.small_image_url == null || entity.small_image_url == ''
                      ? AssetImage('assets/iitbhu.jpeg')
                      : entityLogoFile == null
                          ? NetworkImage(entity.small_image_url)
                          : FileImage(entityLogoFile),
            ),
          ),
          height: 92.0,
          width: 92.0,
        ),
      ),
    );

    final entityCardContent = Container(
        margin: EdgeInsets.only(left: 16.0, right: 16.0),
        constraints: BoxConstraints.expand(),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 4.0,
              ),
              Container(height: 4.0),
              Text(entity.name, style: Style.titleTextStyle),
              Container(height: 10.0),
              Separator(),
            ]));

    final entityCard = Container(
      child: entityCardContent,
      height: 154.0,
      margin: EdgeInsets.only(top: 72.0),
      decoration: BoxDecoration(
        color: ColorConstants.workshopCardContainer,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
    );

    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (_, __, ___) => EntityPage(entity: entity),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          ));
        },
        child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 10.0,
          ),
          child: Stack(
            children: <Widget>[
              entityCard,
              entityThumbnail,
            ],
          ),
        ));
  }
}
