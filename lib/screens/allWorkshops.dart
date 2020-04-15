import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/screens/home/home_widgets.dart';

class AllWorkshopsScreen extends StatelessWidget {
  TabController _tabController;

  FutureBuilder<Response> _buildAllWorkshopsBody(BuildContext context) {
    return FutureBuilder<Response<BuiltAllWorkshopsPost>>(
      future: AppConstants.service.getAllWorkshops(),
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

          print(posts);
          print('-------------------------------------');

          return _buildAllWorkshopPosts(context, posts);
        } else {
          // Show a loading indicator while waiting for the posts
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildAllWorkshopPosts(
      BuildContext context, BuiltAllWorkshopsPost posts) {
    return
        // TabBarView(
        //   controller: _tabController,
        //   children: <Widget>[
        //     Container(
        //       height: 400,
        //       child: ListView.builder(
        // physics: ScrollPhysics(),
        //         shrinkWrap: true,
        //         scrollDirection: Axis.vertical,
        //         itemCount: posts.active_workshops.length,
        //         padding: EdgeInsets.all(8),
        //         itemBuilder: (context, index) {
        //           return HomeWidgets.getWorkshopCard(context,
        //               w: Workshop.createWorkshopFromMap(
        //                   posts.active_workshops[index]));
        //         },
        //       ),
        //     ),
        //     Container(
        //       height: 400,
        //       child: ListView.builder(
        // physics: ScrollPhysics(),
        //         shrinkWrap: true,
        //         scrollDirection: Axis.vertical,
        //         itemCount: posts.past_workshops.length,
        //         padding: EdgeInsets.all(8),
        //         itemBuilder: (context, index) {
        //           return HomeWidgets.getWorkshopCard(context,
        //               w: Workshop.createWorkshopFromMap(
        //                   posts.past_workshops[index]));
        //         },
        //       ),
        //     ),
        //   ],
        // );

        ListView(
      children: <Widget>[
        Padding(
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
        Padding(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("All Workshops"),
        actions: <Widget>[
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
        ],
        // bottom: TabBar(
        //   unselectedLabelColor: Colors.grey,
        //   labelColor: Colors.black,
        //   tabs: [
        //     new Tab(
        //       text: 'Active',
        //     ),
        //     new Tab(text: 'Past'),
        //   ],
        //   controller: _tabController,
        // ),
      ),
      body: _buildAllWorkshopsBody(context),
    );
  }
}
