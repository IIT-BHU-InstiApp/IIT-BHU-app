import 'package:chopper/chopper.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/pages/Home/home_widgets.dart';
import 'package:built_collection/built_collection.dart';

ListView buildCurrentWorkshopPosts(BuildContext context, GlobalKey<FabCircularMenuState> fabKey,
    {Function reload}) {
  return ListView.builder(
    physics: ScrollPhysics(),
    scrollDirection: Axis.vertical,
    itemCount: AppConstants.workshopFromDatabase.length,
    padding: EdgeInsets.all(8),
    itemBuilder: (context, index) {
      return HomeWidgets.getWorkshopCard(context,
          w: AppConstants.workshopFromDatabase[index], fabKey: fabKey, reload: reload);
    },
  );
}

FutureBuilder<Response> buildInterestedWorkshopsBody(
    BuildContext context, GlobalKey<FabCircularMenuState> fabKey,
    {Function reload}) {
  return FutureBuilder<Response<BuiltList<BuiltWorkshopSummaryPost>>>(
    future: AppConstants.service.getInterestedWorkshops(AppConstants.djangoToken),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
              textAlign: TextAlign.center,
              textScaleFactor: 1.3,
            ),
          );
        }

        final posts = snapshot.data.body;
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: posts.length,
          padding: EdgeInsets.all(8),
          itemBuilder: (context, index) {
            return HomeWidgets.getWorkshopCard(context,
                w: posts[index], fabKey: fabKey, reload: reload);
          },
        );
      } else {
        return Center(
          child: HomeWidgets.getPlaceholder(),
        );
      }
    },
  );
}

FutureBuilder<Response> buildWorkshopsFromSearch({context, searchPost, Function reload}) {
  return FutureBuilder<Response<BuiltAllWorkshopsPost>>(
    future: AppConstants.service.searchWorkshop(searchPost),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.data == null ||
            (snapshot.data.body.active_workshops.isEmpty &&
                snapshot.data.body.past_workshops.isEmpty)) {
          return Center(
            child: Text(
              'No Workshops found........',
              textAlign: TextAlign.center,
              textScaleFactor: 3,
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
              textAlign: TextAlign.center,
              textScaleFactor: 1.3,
            ),
          );
        }

        final posts = snapshot.data.body;
        print(posts);
        return _buildWorkshopsFromSearchPosts(context, posts, reload);
      } else {
        // Show a loading indicator while waiting for the posts
        return Center(
          child: HomeWidgets.getPlaceholder(),
        );
      }
    },
  );
}

Widget _buildWorkshopsFromSearchPosts(
    BuildContext context, BuiltAllWorkshopsPost posts, Function reload) {
  return ListView(
    children: <Widget>[
      posts.active_workshops.isEmpty
          ? Container()
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: Text(
                  'Active Workshops',
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
      Container(
        child: ListView.builder(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: posts.active_workshops.length,
          padding: EdgeInsets.all(8),
          itemBuilder: (context, index) {
            return HomeWidgets.getWorkshopCard(context,
                w: posts.active_workshops[index], reload: reload);
          },
        ),
      ),
      posts.past_workshops.isEmpty
          ? Container()
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: Text(
                  'Past Workshops',
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
      Container(
        child: ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: posts.past_workshops.length,
          padding: EdgeInsets.all(8),
          itemBuilder: (context, index) {
            return HomeWidgets.getWorkshopCard(context,
                w: posts.past_workshops[index], reload: reload);
          },
        ),
      ),
    ],
  );
}
