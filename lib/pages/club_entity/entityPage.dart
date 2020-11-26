import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/pages/account/accountPage.dart';
import 'package:iit_app/ui/club_council_common/club_&_council_widgets.dart';
import 'package:iit_app/ui/entity_custom_widgets.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class EntityPage extends StatefulWidget {
  final EntityListPost entity;
  final bool editMode;
  const EntityPage({Key key, @required this.entity, this.editMode = false})
      : super(key: key);
  @override
  _EntityPageState createState() => _EntityPageState();
}

class _EntityPageState extends State<EntityPage>
    with SingleTickerProviderStateMixin {
  BuiltEntityPost entityMap;
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
    entityMap = await AppConstants.getEntityDetailsFromDatabase(
        entityId: widget.entity.id, refresh: refresh);
    if (entityMap != null) {
      _entityLargeLogoFile = AppConstants.getImageFile(
          isEntity: true, isSmall: false, id: entityMap.id);
      if (_entityLargeLogoFile == null) {
        AppConstants.writeImageFileIntoDisk(
            isEntity: true,
            isSmall: false,
            id: entityMap.id,
            url: entityMap.large_image_url);
      }
    }
    if (!this.mounted) {
      return;
    }
    setState(() {});

    Response<BuiltAllWorkshopsPost> snapshots = await AppConstants.service
        .getEntityWorkshops(widget.entity.id, AppConstants.djangoToken)
        .catchError((onError) {
      print("Error fetching Entity Workshops: ${onError.toString()}");
    });
    entityWorkshops = snapshots.body;
    if (!this.mounted) {
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _reload() {
    _fetchEntityDataByID(refresh: true);
  }

  void toggleSubscription() async {
    if (!this.mounted) {
      return;
    }
    setState(() {
      this._toggling = true;
    });

    await AppConstants.service
        .toggleEntitySubscription(widget.entity.id, AppConstants.djangoToken)
        .then((snapshot) async {
      print("status of entity subscription: ${snapshot.statusCode}");

      if (snapshot.statusCode == 200) {
        await AppConstants.updateEntitySubscriptionInDatabase(
            entityId: widget.entity.id,
            isSubscribed: !entityMap.is_subscribed,
            currentSubscribedUsers: entityMap.subscribed_users);

        entityMap = await AppConstants.getEntityDetailsFromDatabase(
            entityId: widget.entity.id);

        if (entityMap.is_subscribed == true) {
          await FirebaseMessaging()
              .subscribeToTopic('E_${entityMap.id}')
              .then((_) => print('subscribed to E_${entityMap.id}'));
        } else {
          await FirebaseMessaging().unsubscribeFromTopic('E_${entityMap.id}');
        }
      }
    }).catchError((onError) {
      print("Error in toggleing: ${onError.toString()}");
    });

    if (!this.mounted) {
      return;
    }
    setState(() {
      this._toggling = false;
    });
  }

  Future<bool> _onWillPop() {
    print("Entityscreen:${AccountPage.flag}");
    if (AccountPage.flag == "Account")
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AccountPage()));
    else
      Navigator.pop(context);
    return Future.value(false);
  }

  final BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  PanelController _pc = PanelController();

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
    return WillPopScope(
        onWillPop: _onWillPop,
        child: SafeArea(
            minimum: const EdgeInsets.all(2.0),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              resizeToAvoidBottomPadding: false,
              backgroundColor: ColorConstants.backgroundThemeColor,
              floatingActionButton: AppConstants.isGuest
                  ? null
                  : FloatingActionButton(
                      backgroundColor: Colors.white,
                      onPressed: () {
                        if (this._toggling == false) {
                          toggleSubscription();
                        }
                      },
                      child: this._toggling || entityMap == null
                          ? CircularProgressIndicator()
                          : Icon(
                              Icons.subscriptions,
                              color: entityMap.is_subscribed
                                  ? Colors.red
                                  : Colors.black26,
                            ),
                    ),
              body: RefreshIndicator(
                  onRefresh: () async => _reload(),
                  child: SlidingUpPanel(
                    body: ClubCouncilAndEntityWidgets.getPanelBackground(
                        context, _entityLargeLogoFile,
                        isEntity: true,
                        entityDetail: entityMap,
                        entity: widget.entity),
                    parallaxEnabled: true,
                    controller: _pc,
                    borderRadius: radius,
                    collapsed: Container(
                      decoration: BoxDecoration(
                        borderRadius: radius,
                      ),
                    ),
                    backdropEnabled: true,
                    panelBuilder: (ScrollController sc) => entityCustomWidgets
                        .getPanel(sc: sc, entity: widget.entity),
                    minHeight:
                        ClubCouncilAndEntityWidgets.getMinPanelHeight(context),
                    maxHeight:
                        ClubCouncilAndEntityWidgets.getMaxPanelHeight(context),
                    header: ClubCouncilAndEntityWidgets.getHeader(context),
                  )),
            )));
  }
}
