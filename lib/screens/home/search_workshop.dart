import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'home_widgets.dart';

class SearchBarWidget {
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  var searchPost;

  FutureBuilder<Response> buildWorkshopsFromSearch(BuildContext context) {
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
          return SearchBarWidget.buildWorkshopsFromSearchPosts(context, posts);
        } else {
          // Show a loading indicator while waiting for the posts
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget getSearchTextFeild(context) {
    return TextFormField(
      onTap: () => print('===================='),
      controller: searchController,
      decoration: InputDecoration(
          hintText: 'Search Workshops ...',
          prefixIcon: Icon(Icons.search),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              searchController.clear();
              isSearching = false;
              // FocusScope.of(context).unfocus();
            },
          )),
      onFieldSubmitted: (value) {
        if (value.isEmpty) return;
        isSearching = true;
        searchPost = BuiltWorkshopSearchByStringPost((b) => b
          ..search_by = 'title'
          ..search_string = searchController.text);
      },
    );
  }

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
