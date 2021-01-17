import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/ui/club_council_entity_common/club_council_entity_widgets.dart';
import 'package:iit_app/pages/club_entity/entityPage.dart';
import 'package:iit_app/ui/club_entity_common.dart';
import 'package:iit_app/ui/separator.dart';
import 'package:iit_app/ui/text_style.dart';
import 'package:skeleton_text/skeleton_text.dart';

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
      child: ClubAndEntityWidgets().getWorkshopEventTabBar(
          workshops: entityWorkshops,
          tabController: tabController,
          context: context,
          reload: reload),
    );
  }

  static Widget getEntityCard(BuildContext context,
      {EntityListPost entity, bool horizontal = false, Function reload}) {
    final File entityLogoFile =
        AppConstants.getImageFile(entity.small_image_url);

    final entityThumbnail = Container(
      margin: EdgeInsets.symmetric(vertical: 16.0),
      alignment:
          horizontal ? FractionalOffset.centerLeft : FractionalOffset.center,
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
          height: horizontal ? 50 : 82,
          width: horizontal ? 50 : 82,
        ),
      ),
    );

    final entityCardContent = Container(
        margin: EdgeInsets.only(left: horizontal ? 40.0 : 10.0, right: 10.0),
        constraints: BoxConstraints.expand(),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: horizontal
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: <Widget>[
              horizontal ? Container() : SizedBox(height: 4.0),
              Text(entity.name, style: Style.titleTextStyle),
              Container(height: horizontal ? 4 : 10),
              horizontal ? Container() : Separator(),
            ]));

    final entityCard = Container(
      child: entityCardContent,
      height: horizontal ? 75.0 : 154.0,
      margin:
          horizontal ? EdgeInsets.only(left: 30.0) : EdgeInsets.only(top: 72.0),
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
          if (horizontal)
            Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (_, __, ___) => EntityPage(entityId: entity.id),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child),
            ));
          // .then((value) => reload());
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

  static ListView getPlaceholder() {
    final BorderRadius borderRadius = BorderRadius.circular(10.0);
    return ListView.builder(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: borderRadius, color: Colors.transparent),
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: borderRadius,
                      child: SkeletonAnimation(
                        child: Container(
                          width: 75.0,
                          height: 75.0,
                          decoration: BoxDecoration(
                            color: ColorConstants.shimmerSkeletonColor,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15.0,
                            bottom: 15.0,
                          ),
                          child: ClipRRect(
                            borderRadius: borderRadius,
                            child: SkeletonAnimation(
                              child: Container(
                                height: 20.0,
                                width: MediaQuery.of(context).size.width * 0.7,
                                decoration: BoxDecoration(
                                    color: ColorConstants.shimmerSkeletonColor),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 5.0),
                          child: ClipRRect(
                            borderRadius: borderRadius,
                            child: SkeletonAnimation(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: 20.0,
                                decoration: BoxDecoration(
                                    color: ColorConstants.shimmerSkeletonColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
