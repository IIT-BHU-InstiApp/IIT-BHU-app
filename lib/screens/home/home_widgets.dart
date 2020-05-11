import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/pages/login.dart';
import 'package:iit_app/screens/home/search_workshop.dart';
import 'package:iit_app/screens/home/worshop_detail/workshop_detail.dart';
import 'package:iit_app/ui/separator.dart';
import 'package:iit_app/ui/text_style.dart';

import 'package:skeleton_text/skeleton_text.dart';
import 'buildWorkshops.dart' as buildWorkhops;

class HomeWidgets {
  static final Color textPaleColor = Color(0xFFAFAFAF);
  static final Color textColor = Color(0xFF004681);

  static Widget get connectionError {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text("Could not find active internet connection"),
        Text(
          'Try again',
          style: TextStyle(
              color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ],
    );
  }

  static Future<bool> getLogOutDialog(context, details) => showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
                height: 350.0,
                width: 200.0,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(height: 150.0),
                        Container(
                          height: 100.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                              color: Colors.teal),
                        ),
                        Positioned(
                            top: 50.0,
                            left: 94.0,
                            child: Container(
                              height: 90.0,
                              width: 90.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(45.0),
                                  border: Border.all(
                                      color: Colors.white,
                                      style: BorderStyle.solid,
                                      width: 2.0),
                                  image: DecorationImage(
                                      image: details[0], fit: BoxFit.cover)),
                            ))
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          details[1],
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 14.0,
                            fontWeight: FontWeight.w300,
                          ),
                        )),
                    SizedBox(height: 15.0),
                    FlatButton(
                        child: Center(
                          child: Text(
                            'Log Out',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14.0,
                                color: Colors.teal),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          signOutGoogle();
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                        color: Colors.transparent)
                  ],
                )));
      });

  static Widget getWorkshopCard(
    BuildContext context, {
    BuiltWorkshopSummaryPost w,
    bool editMode = false,
    bool horizontal = true,
    bool isPast = false,
  }) {
    final File clubLogoFile =
        AppConstants.getImageFile(isSmall: true, id: w.club.id, isClub: true);

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
              image: w.club.small_image_url == null
                  ? AssetImage('assets/iitbhu.jpeg')
                  : clubLogoFile == null
                      ? NetworkImage(w.club.small_image_url)
                      : FileImage(clubLogoFile),
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
          Text('${w.club.name}', style: Style.commonTextStyle),
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
            ? () => Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>
                        WorkshopDetailPage(workshop: w, isPast: isPast),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) =>
                            FadeTransition(opacity: animation, child: child),
                  ),
                )
            : null,
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
    return ListView.builder(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: Colors.transparent),
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SkeletonAnimation(
                      child: Container(
                        width: 110.0,
                        height: 110.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: ColorConstants.shimmerSkeletonColor,
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
                          child: SkeletonAnimation(
                            child: Container(
                              height: 20.0,
                              width: MediaQuery.of(context).size.width * 0.5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: ColorConstants.shimmerSkeletonColor),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 5.0, bottom: 15.0),
                          child: SkeletonAnimation(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: 20.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: ColorConstants.shimmerSkeletonColor),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 5.0, bottom: 15.0),
                          child: SkeletonAnimation(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: 20.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: ColorConstants.shimmerSkeletonColor),
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

class HomeChild extends StatelessWidget {
  final BuildContext context;
  final SearchBarWidget searchBarWidget;
  final TabController tabController;
  final bool isSearching;

  const HomeChild(
      {Key key,
      this.context,
      this.searchBarWidget,
      this.tabController,
      this.isSearching})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) => isSearching
          ? buildWorkhops.buildWorkshopsFromSearch(
              context: context, searchPost: searchBarWidget.searchPost)
          : Column(
              children: [
                TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: Colors.deepPurple,
                  unselectedLabelColor: Colors.white70,
                  labelColor: Colors.black,
                  tabs: [
                    Tab(text: 'Latest'),
                    Tab(text: 'Interested'),
                  ],
                  controller: tabController,
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: <Widget>[
                      Container(
                        child: AppConstants.firstTimeFetching
                            ? HomeWidgets.getPlaceholder()
                            : RefreshIndicator(
                                displacement: 60,
                                onRefresh: () async {
                                  await AppConstants
                                      .updateAndPopulateWorkshops();
                                  setState(() {});
                                },
                                child: buildWorkhops
                                    .buildCurrentWorkshopPosts(context)),
                      ),
                      Container(
                        child: AppConstants.isGuest
                            ? Text(
                                'We value your interest, but first you have to trust us by logging in. Dear Guest, it can not be one sided.')
                            : buildWorkhops
                                .buildInterestedWorkshopsBody(context),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
