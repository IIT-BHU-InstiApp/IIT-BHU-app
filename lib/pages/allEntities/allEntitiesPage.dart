import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/data/internet_connection_interceptor.dart';
import 'package:iit_app/external_libraries/spin_kit.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/ui/drawer.dart';
import 'package:iit_app/ui/entity_custom_widgets.dart';
import 'package:built_collection/built_collection.dart';

class EntitiesPage extends StatefulWidget {
  @override
  _EntitiesPageState createState() => _EntitiesPageState();
}

class _EntitiesPageState extends State<EntitiesPage> {
  void initState() {
    super.initState();
  }

  Future<bool> onPop() async {
    Navigator.pushNamed(context, '/home');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onPop,
      child: SafeArea(
          minimum: const EdgeInsets.all(2.0),
          child: Scaffold(
            backgroundColor: ColorConstants.homeBackground,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: ColorConstants.textColor),
                onPressed: () => Navigator.pop(context),
              ),
              backgroundColor: ColorConstants.homeBackground,
              automaticallyImplyLeading: false,
              title: Text("All Entities and Fests"),
            ),
            drawer: SideBar(context: context),
            body: _getAllEntities(),
          )),
    );
  }

  Widget _getAllEntities() {
    return Container(
        child: FutureBuilder<Response<BuiltList<EntityListPost>>>(
      future: AppConstants.service.getAllEntity(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            if (snapshot.error is InternetConnectionException &&
                AppConstants.internetErrorFlushBar.onScreen == false) {
              AppConstants.internetErrorFlushBar.flushbar..show(context);
            }

            return Center(
              child: Text(
                snapshot.error.toString(),
                textAlign: TextAlign.center,
                textScaleFactor: 1.3,
              ),
            );
          }
          final posts = snapshot.data.body
              ?.where((entity) => entity.is_permanent != true)
              ?.toBuiltList();
          return _buildAllEntitiesBodyPosts(context, posts);
        } else {
          return Center(
            child: LoadingCircle,
          );
        }
      },
    ));
  }

  Widget _buildAllEntitiesBodyPosts(
    BuildContext context,
    BuiltList<EntityListPost> posts,
  ) {
    return Container(
      child: ListView.builder(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: posts.length,
          padding: EdgeInsets.all(8),
          itemBuilder: (context, index) {
            return EntityCustomWidgets.getEntityCard(context,
                entity: posts[index], horizontal: true);
          }),
    );
  }
}
