import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/data/internet_connection_interceptor.dart';
import 'package:iit_app/external_libraries/fab_circular_menu.dart';
import 'package:iit_app/external_libraries/spin_kit.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/ui/workshop_custom_widgets.dart';
import 'package:built_collection/built_collection.dart';

Widget buildCurrentWorkshopAndEventPosts(
    BuildContext context, GlobalKey<FabCircularMenuState> fabKey,
    {Function reload, bool isEvent}) {
  Widget _builder(w) {
    return w.length == 0
        ? Center(
            child: Text('No Activity :(',
                style: TextStyle(color: Colors.white, fontSize: 25)))
        : ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: w.length,
            padding: EdgeInsets.all(8),
            itemBuilder: (context, index) {
              return WorkshopCustomWidgets.getWorkshopOrEventCard(context,
                  w: w[index], fabKey: fabKey, reload: reload);
            },
          );
  }

  return _builder(AppConstants.workshopFromDatabase
      .where((w) => isEvent ? !w.is_workshop : w.is_workshop)
      .toList());
}

FutureBuilder<Response> buildInterestedWorkshopsBody(BuildContext context,
    {Function reload}) {
  return FutureBuilder<Response<BuiltList<BuiltWorkshopSummaryPost>>>(
    future:
        AppConstants.service.getInterestedWorkshops(AppConstants.djangoToken),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError) {
          if (snapshot.error is InternetConnectionException) {
            AppConstants.internetErrorFlushBar.showFlushbar(context);
          }
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
            return WorkshopCustomWidgets.getWorkshopOrEventCard(context,
                w: posts[index], reload: reload);
          },
        );
      } else {
        return Center(
          child: WorkshopCustomWidgets.getPlaceholder(),
        );
      }
    },
  );
}

FutureBuilder<Response> buildWorkshopsFromSearch(
    {BuildContext context,
    BuiltWorkshopSearchByStringPost searchPost,
    Function reload}) {
  return FutureBuilder<Response<BuiltAllWorkshopsPost>>(
    future: AppConstants.service.searchWorkshop(searchPost),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError) {
          if (snapshot.error is InternetConnectionException) {
            AppConstants.internetErrorFlushBar.showFlushbar(context);
          }
          return Center(
            child: Text(
              snapshot.error.toString(),
              textAlign: TextAlign.center,
              textScaleFactor: 1.3,
            ),
          );
        }
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

        final posts = snapshot.data.body;
        print(posts);
        return _buildWorkshopsFromSearchPosts(context, posts, reload);
      } else {
        // Show a loading indicator while waiting for the posts
        return Center(
          child: WorkshopCustomWidgets.getPlaceholder(),
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
                  'Upcoming...',
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
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
            return WorkshopCustomWidgets.getWorkshopOrEventCard(context,
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
                  '..... Past .....',
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
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
            return WorkshopCustomWidgets.getWorkshopOrEventCard(context,
                w: posts.past_workshops[index], reload: reload);
          },
        ),
      ),
    ],
  );
}

FutureBuilder<Response> buildAllWorkshopsBody(BuildContext context,
    {Function reload}) {
  return FutureBuilder<Response<BuiltAllWorkshopsPost>>(
    future: AppConstants.service.getAllWorkshops(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError) {
          if (snapshot.error is InternetConnectionException) {
            AppConstants.internetErrorFlushBar.showFlushbar(context);
          }
          return Center(
            child: Text(
              snapshot.error.toString(),
              textAlign: TextAlign.center,
              textScaleFactor: 1.3,
            ),
          );
        }

        final posts = snapshot.data.body;

        // print(posts);
        // print('-------------------------------------');

        return _buildAllWorkshopsBodyPosts(context, posts, reload: reload);
      } else {
        // Show a loading indicator while waiting for the posts
        return Center(
          child: LoadingCircle,
        );
      }
    },
  );
}

Widget _buildAllWorkshopsBodyPosts(
    BuildContext context, BuiltAllWorkshopsPost posts,
    {Function reload}) {
  return ListView(
    children: <Widget>[
      Container(
        child: ListView.builder(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: posts.active_workshops.length,
          padding: EdgeInsets.all(8),
          itemBuilder: (context, index) {
            return WorkshopCustomWidgets.getWorkshopOrEventCard(context,
                w: posts.active_workshops[index], reload: reload);
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
        child: Center(
          child: Text(
            '..... Past .....',
            style: TextStyle(
                fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
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
            return WorkshopCustomWidgets.getWorkshopOrEventCard(
              context,
              w: posts.past_workshops[index],
              reload: reload,
              isPast: true,
            );
          },
        ),
      ),
    ],
  );
}
