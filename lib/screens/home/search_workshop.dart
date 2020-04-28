import 'package:flutter/material.dart';
import 'package:iit_app/model/built_post.dart';
import 'home_widgets.dart';

class SearchWorkshopWidgets {
  static Widget buildWorkshopsFromSearchPosts(
      BuildContext context, BuiltAllWorkshopsPost posts) {
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
                  w: posts.active_workshops[index]);
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
                  w: posts.past_workshops[index]);
            },
          ),
        ),
      ],
    );
  }
}
