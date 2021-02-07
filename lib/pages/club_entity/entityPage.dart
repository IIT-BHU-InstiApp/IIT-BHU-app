import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/data/internet_connection_interceptor.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/ui/club_council_entity_common/club_council_entity_widgets.dart';
import 'package:iit_app/ui/entity_custom_widgets.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class EntityPage extends StatefulWidget {
  final bool editMode;
  final int entityId;
  const EntityPage({Key key, this.editMode = false, @required this.entityId})
      : super(key: key);
  @override
  _EntityPageState createState() => _EntityPageState();
}

class _EntityPageState extends State<EntityPage>
    with SingleTickerProviderStateMixin {
  BuiltEntityPost entityMap;
  EntityListPost entity;
  BuiltAllWorkshopsPost entityWorkshops;
  bool _toggling = false;
  TabController _tabController;
  File _entityLargeLogoFile;

  @override
  void initState() {
    print("Entity opened in edit mode:${widget.editMode}");
    _tabController = TabController(length: 2, vsync: this);
    _fetchEntityDataByID();
    super.initState();
  }

  _fetchEntityDataByID({bool refresh = false}) async {
    try {
      entityMap = await AppConstants.getEntityDetailsFromDatabase(
          entityId: widget.entityId, refresh: refresh);
      if (entityMap != null) {
        _entityLargeLogoFile =
            AppConstants.getImageFile(entityMap.large_image_url);
        if (_entityLargeLogoFile == null) {
          AppConstants.writeImageFileIntoDisk(entityMap.large_image_url);
        }
      }
      entity = EntityListPost((b) => b
        ..id = entityMap.id
        ..name = entityMap.name
        ..small_image_url = entityMap.small_image_url
        ..large_image_url = entityMap.large_image_url);
    } on InternetConnectionException catch (_) {
      AppConstants.internetErrorFlushBar.showFlushbar(context);
      return;
    } catch (err) {
      print(err);
    }
    if (!this.mounted) {
      return;
    }
    setState(() {});

    await AppConstants.service
        .getEntityWorkshops(widget.entityId, AppConstants.djangoToken)
        .then((snapshots) {
      entityWorkshops = snapshots.body;
    }).catchError((onError) {
      if (onError is InternetConnectionException) {
        AppConstants.internetErrorFlushBar.showFlushbar(context);
        return;
      }
      print("Error fetching Entity Workshops: ${onError.toString()}");
    });
    if (!this.mounted) {
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _update() {
    _fetchEntityDataByID();
    setState(() {});
  }

  void _reload() async {
    await _fetchEntityDataByID(refresh: true);
  }

  void toggleSubscription() async {
    if (!this.mounted) {
      return;
    }
    setState(() {
      this._toggling = true;
    });

    await AppConstants.service
        .toggleEntitySubscription(widget.entityId, AppConstants.djangoToken)
        .then((snapshot) async {
      print("status of entity subscription: ${snapshot.statusCode}");

      if (snapshot.statusCode == 200) {
        try {
          await AppConstants.updateEntitySubscriptionInDatabase(
              entityId: widget.entityId,
              isSubscribed: !entityMap.is_subscribed,
              currentSubscribedUsers: entityMap.subscribed_users);

          entityMap = await AppConstants.getEntityDetailsFromDatabase(
              entityId: widget.entityId);

          if (entityMap.is_subscribed == true) {
            await FirebaseMessaging.instance
                .subscribeToTopic('E_${entityMap.id}')
                .then((_) => print('subscribed to E_${entityMap.id}'));
          } else {
            await FirebaseMessaging.instance
                .unsubscribeFromTopic('E_${entityMap.id}');
          }
        } on InternetConnectionException catch (_) {
          AppConstants.internetErrorFlushBar.showFlushbar(context);
          return;
        } catch (err) {
          print(err);
        }
      }
    }).catchError((onError) {
      if (onError is InternetConnectionException) {
        AppConstants.internetErrorFlushBar.showFlushbar(context);
        return;
      }
      print("Error in toggleing: ${onError.toString()}");
    });

    if (!this.mounted) {
      return;
    }
    setState(() {
      this._toggling = false;
    });
  }

  final BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  PanelController _pc = PanelController();

  Future<bool> _willPopCallback() async {
    if (_pc.isPanelOpen) {
      _pc.close();
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final entityCustomWidgets = EntityCustomWidgets(
      context: context,
      entityMap: entityMap,
      entityWorkshops: entityWorkshops,
      radius: radius,
      tabController: _tabController,
      reload: _reload,
    );
    return SafeArea(
        minimum: const EdgeInsets.all(2.0),
        child: WillPopScope(
          onWillPop: _willPopCallback,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            resizeToAvoidBottomPadding: false,
            backgroundColor: ColorConstants.backgroundThemeColor,
            // floatingActionButton: AppConstants.isGuest
            //     ? null
            //     : FloatingActionButton.extended(
            //         backgroundColor: Colors.white,
            //         onPressed: () {
            //           if (this._toggling == false) {
            //             toggleSubscription();
            //           }
            //         },
            //         icon: this._toggling || entityMap == null
            //             ? CircularProgressIndicator()
            //             : Icon(
            //                 Icons.subscriptions,
            //                 color: entityMap.is_subscribed
            //                     ? Colors.red
            //                     : Colors.black26,
            //               ),
            //         label: Text(
            //           entityMap != null && entityMap.is_subscribed
            //               ? 'Subscribed'
            //               : 'Subscribe',
            //           style: TextStyle(
            //               fontSize: 16,
            //               color: entityMap != null && entityMap.is_subscribed
            //                   ? Colors.red
            //                   : Colors.black26),
            //         ),
            //       ),
            body: RefreshIndicator(
                onRefresh: () async => _reload(),
                child: SlidingUpPanel(
                  body: ClubCouncilAndEntityWidgets.getPanelBackground(
                    context,
                    _entityLargeLogoFile,
                    isEntity: true,
                    entityDetail: entityMap,
                    entity: entity,
                    update: _update,
                  ),
                  parallaxEnabled: true,
                  controller: _pc,
                  borderRadius: radius,
                  collapsed: Container(
                    decoration: BoxDecoration(
                      borderRadius: radius,
                    ),
                  ),
                  backdropEnabled: true,
                  panelBuilder: (ScrollController sc) =>
                      entityCustomWidgets.getPanel(sc: sc, entity: entity),
                  minHeight:
                      ClubCouncilAndEntityWidgets.getMinPanelHeight(context),
                  maxHeight:
                      ClubCouncilAndEntityWidgets.getMaxPanelHeight(context),
                  header: ClubCouncilAndEntityWidgets.getHeader(context),
                )),
          ),
        ));
  }
}
