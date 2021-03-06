import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/data/internet_connection_interceptor.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/model/sharedPreferenceKeys.dart';
import 'package:iit_app/ui/club_council_entity_common/club_council_entity_widgets.dart';
import 'package:iit_app/ui/club_custom_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ClubPage extends StatefulWidget {
  final bool editMode;
  final int clubId;
  const ClubPage({Key key, this.editMode = false, @required this.clubId})
      : super(key: key);
  @override
  _ClubPageState createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage>
    with SingleTickerProviderStateMixin {
  BuiltClubPost clubMap;
  ClubListPost club;
  BuiltAllWorkshopsPost clubWorkshops;
  bool _toggling = false;
  TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  File _clubLargeLogoFile;

  @override
  void initState() {
    print("Club opened in edit mode:${widget.editMode}");
    _tabController = TabController(length: 2, vsync: this);
    _fetchClubDataById();
    super.initState();
  }

  void _reload() async {
    await _fetchClubDataById(refresh: true);
  }

  _fetchClubDataById({bool refresh = false}) async {
    try {
      clubMap = await AppConstants.getClubDetailsFromDatabase(
          clubId: widget.clubId, refresh: refresh);

      if (clubMap != null) {
        _clubLargeLogoFile = AppConstants.getImageFile(clubMap.large_image_url);

        if (_clubLargeLogoFile == null) {
          AppConstants.writeImageFileIntoDisk(clubMap.large_image_url);
        }
      }
      club = ClubListPost((b) => b
        ..id = clubMap.id
        ..name = clubMap.name
        ..council =
            clubMap.council == null ? null : (clubMap.council.toBuilder())
        ..small_image_url = clubMap.small_image_url
        ..large_image_url = clubMap.large_image_url);
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
        .getClubWorkshops(widget.clubId, AppConstants.djangoToken)
        .then((snapshots) {
      clubWorkshops = snapshots.body;
    }).catchError((onError) {
      if (onError is InternetConnectionException) {
        AppConstants.internetErrorFlushBar.showFlushbar(context);
        return;
      }
      print("Error in fetching workshops: ${onError.toString()}");
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
    _fetchClubDataById();
    setState(() {});
  }

  void _toggleToggle() {
    _toggling = !_toggling;
    setState(() {});
  }

  void toggleSubscription() async {
    if (!this.mounted) {
      return;
    }
    setState(() {
      this._toggling = true;
    });

    await AppConstants.service
        .toggleClubSubscription(widget.clubId, AppConstants.djangoToken)
        .then((snapshot) async {
      print("status of club subscription: ${snapshot.statusCode}");

      if (snapshot.statusCode == 200) {
        try {
          await AppConstants.updateClubSubscriptionInDatabase(
              clubId: widget.clubId,
              isSubscribed: !clubMap.is_subscribed,
              currentSubscribedUsers: clubMap.subscribed_users);

          clubMap = await AppConstants.getClubDetailsFromDatabase(
              clubId: widget.clubId);

          if (clubMap.is_subscribed == true) {
            await FirebaseMessaging.instance
                .subscribeToTopic('C_${clubMap.id}')
                .then((_) => print('subscribed to C_${clubMap.id}'));
          } else {
            await FirebaseMessaging.instance
                .unsubscribeFromTopic('C_${clubMap.id}');
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
    final clubCustomWidgets = ClubCustomWidgets(
      context: context,
      clubMap: clubMap,
      clubWorkshops: clubWorkshops,
      radius: radius,
      tabController: _tabController,
      reload: _reload,
    );

    return SafeArea(
      minimum: const EdgeInsets.all(2.0),
      child: WillPopScope(
        onWillPop: _willPopCallback,
        child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
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
          //         icon: this._toggling || clubMap == null
          //             ? CircularProgressIndicator()
          //             : Icon(
          //                 Icons.subscriptions,
          //                 color: clubMap.is_subscribed
          //                     ? Colors.red
          //                     : Colors.black26,
          //               ),
          //         label: Text(
          //           clubMap != null && clubMap.is_subscribed
          //               ? 'Subscribed'
          //               : 'Subscribe',
          //           style: TextStyle(
          //               fontSize: 16,
          //               color: clubMap != null && clubMap.is_subscribed
          //                   ? Colors.red
          //                   : Colors.black26),
          //         ),
          //       ),
          body: RefreshIndicator(
            onRefresh: () async => _reload(),
            child: SlidingUpPanel(
              body: ClubCouncilAndEntityWidgets.getPanelBackground(
                context,
                _clubLargeLogoFile,
                isClub: true,
                clubDetail: clubMap,
                club: club,
                update: _update,
                toggler: _toggleToggle,
                toggling: _toggling,
                scaffoldKey: _scaffoldKey,
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
                  clubCustomWidgets.getPanel(pc: _pc, sc: sc, club: club),
              minHeight: ClubCouncilAndEntityWidgets.getMinPanelHeight(context),
              maxHeight: ClubCouncilAndEntityWidgets.getMaxPanelHeight(context),
              header: ClubCouncilAndEntityWidgets.getHeader(context),
            ),
          ),
        ),
      ),
    );
  }
}
