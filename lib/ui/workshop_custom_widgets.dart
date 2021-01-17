import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iit_app/external_libraries/fab_circular_menu.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/pages/worshop_detail/workshopDetailPage.dart';
import 'package:iit_app/ui/separator.dart';
import 'package:iit_app/ui/text_style.dart';
import 'package:iit_app/pages/club_entity/clubPage.dart';
import 'package:iit_app/pages/club_entity/entityPage.dart';
import 'package:skeleton_text/skeleton_text.dart';

class WorkshopCustomWidgets {
  static final Color textPaleColor = Color(0xFFAFAFAF);
  static final Color textColor = Color(0xFF004681);

  static Widget getWorkshopOrEventCard(BuildContext context,
      {BuiltWorkshopSummaryPost w,
      bool editMode = false,
      bool horizontal = true,
      bool isPast = false,
      GlobalKey<FabCircularMenuState> fabKey,
      Function reload}) {
    final bool isClub = w.club != null;
    File logoFile;
    if (isClub)
      logoFile = AppConstants.getImageFile(w.club.small_image_url);
    else
      logoFile = AppConstants.getImageFile(w.entity.small_image_url);

    final workshopThumbnail = Container(
      margin: EdgeInsets.symmetric(vertical: 16.0),
      alignment:
          horizontal ? FractionalOffset.centerLeft : FractionalOffset.center,
      child: Hero(
        tag: "w-hero-${w.id}",
        child: Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image(
              fit: BoxFit.contain,
              image: isClub
                  ? (w.club.small_image_url == null ||
                          w.club.small_image_url == ''
                      ? AssetImage('assets/iitbhu.jpeg')
                      : logoFile == null
                          ? NetworkImage(w.club.small_image_url)
                          : FileImage(logoFile))
                  : (w.entity.small_image_url == null ||
                          w.entity.small_image_url == ''
                      ? AssetImage('assets/iitbhu.jpeg')
                      : logoFile == null
                          ? NetworkImage(w.entity.small_image_url)
                          : FileImage(logoFile)),
            ),
          ),
          height: 92.0,
          width: 92.0,
        ),
      ),
    );

    Widget _workshopValue({String value, IconData icon}) {
      return Container(
        child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Icon(icon, color: Colors.white, size: 12.0),
          Container(width: 8.0),
          Text(value, style: Style.smallTextStyle),
        ]),
      );
    }

    final workshopCardContent = Container(
      margin: EdgeInsets.only(left: horizontal ? 60.0 : 16.0, right: 16.0),
      constraints: BoxConstraints.expand(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:
            horizontal ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: <Widget>[
          editMode
              ? Text("CLICK TO EDIT", style: TextStyle(color: Colors.green))
              : SizedBox(height: 1),
          Container(height: 4.0),
          Text(w.title, style: Style.titleTextStyle),
          Container(height: 10.0),
          Text('${isClub ? w.club.name : w.entity.name}',
              style: Style.commonTextStyle),
          Separator(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  flex: horizontal ? 1 : 0,
                  child: _workshopValue(value: w.date, icon: Icons.date_range)),
              Container(
                width: 15.0,
              ),
              w.time == null
                  ? SizedBox(height: 1)
                  : Expanded(
                      flex: horizontal ? 1 : 0,
                      child: _workshopValue(value: w.time, icon: Icons.timer))
            ],
          ),
        ],
      ),
    );

    final workshopCard = Container(
      child: workshopCardContent,
      height: horizontal ? 140.0 : 154.0,
      margin:
          horizontal ? EdgeInsets.only(left: 46.0) : EdgeInsets.only(top: 72.0),
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
        onTap: horizontal
            ? () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>
                        WorkshopDetailPage(w.id, workshop: w, isPast: isPast),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) =>
                            FadeTransition(opacity: animation, child: child),
                  ),
                );
                // .then((value) => reload());
                try {
                  if (fabKey.currentState.isOpen) {
                    fabKey.currentState.close();
                  }
                } catch (e) {
                  print(e);
                }
              }
            : () {
                isClub
                    ? Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                            ClubPage(clubId: w.club.id, editMode: true),
                        transitionsBuilder: (context, animation,
                                secondaryAnimation, child) =>
                            FadeTransition(opacity: animation, child: child),
                      ))
                    : Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                            EntityPage(entityId: w.entity.id, editMode: true),
                        transitionsBuilder: (context, animation,
                                secondaryAnimation, child) =>
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
              workshopCard,
              workshopThumbnail,
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
                          width: 110.0,
                          height: 110.0,
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
                                width: MediaQuery.of(context).size.width * 0.5,
                                decoration: BoxDecoration(
                                    color: ColorConstants.shimmerSkeletonColor),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 5.0, bottom: 15.0),
                          child: ClipRRect(
                            borderRadius: borderRadius,
                            child: SkeletonAnimation(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: 20.0,
                                decoration: BoxDecoration(
                                    color: ColorConstants.shimmerSkeletonColor),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 5.0, bottom: 15.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: SkeletonAnimation(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.3,
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
