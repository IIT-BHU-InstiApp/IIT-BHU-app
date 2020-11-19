import 'dart:io';
import 'package:chopper/chopper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/ui/club_council_common/club_&_council_widgets.dart';
import 'package:iit_app/ui/club_custom_widgets.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:iit_app/pages/account/accountPage.dart';

class ClubPage extends StatefulWidget {
  final ClubListPost club;
  final bool editMode;
  const ClubPage({Key key, @required this.club, this.editMode = false}) : super(key: key);
  @override
  _ClubPageState createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> with SingleTickerProviderStateMixin {
  BuiltClubPost clubMap;
  BuiltAllWorkshopsPost clubWorkshops;
  bool _toggling = false;
  TabController _tabController;

  File _clubLargeLogoFile;

  @override
  void initState() {
    print("Club opened in edit mode:${widget.editMode}");
    _tabController = TabController(length: 2, vsync: this);
    _fetchClubDataById();
    super.initState();
  }

  void _reload() {
    _fetchClubDataById();
  }

  _fetchClubDataById() async {
    if (clubMap == null) {
      clubMap = await AppConstants.getClubDetailsFromDatabase(clubId: widget.club.id);
    }
    if (clubMap != null) {
      _clubLargeLogoFile = AppConstants.getImageFile(isClub: true, isSmall: false, id: clubMap.id);

      if (_clubLargeLogoFile == null) {
        AppConstants.writeImageFileIntoDisk(
            isClub: true, isSmall: false, id: clubMap.id, url: clubMap.large_image_url);
      }
    }
    if (!this.mounted) {
      return;
    }
    setState(() {});

    Response<BuiltAllWorkshopsPost> snapshots = await AppConstants.service
        .getClubWorkshops(widget.club.id, AppConstants.djangoToken)
        .catchError((onError) {
      print("Error in fetching workshops: ${onError.toString()}");
    });
    clubWorkshops = snapshots.body;
    if (!this.mounted) {
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  void toggleSubscription() async {
    if (!this.mounted) {
      return;
    }
    setState(() {
      this._toggling = true;
    });

    await AppConstants.service
        .toggleClubSubscription(widget.club.id, AppConstants.djangoToken)
        .then((snapshot) async {
      print("status of club subscription: ${snapshot.statusCode}");

      if (snapshot.statusCode == 200) {
        await AppConstants.updateClubSubscriptionInDatabase(
            clubId: widget.club.id,
            isSubscribed: !clubMap.is_subscribed,
            currentSubscribedUsers: clubMap.subscribed_users);

        clubMap = await AppConstants.getClubDetailsFromDatabase(clubId: widget.club.id);

        if (clubMap.is_subscribed == true) {
          await FirebaseMessaging()
              .subscribeToTopic('C_${clubMap.id}')
              .then((_) => print('subscribed to C_${clubMap.id}'));
        } else {
          await FirebaseMessaging().unsubscribeFromTopic('C_${clubMap.id}');
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
    print("Clubscreen:${AccountPage.flag}");
    if (AccountPage.flag == "Account")
      Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPage()));
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
    final clubCustomWidgets = ClubCustomWidgets(
      context: context,
      clubMap: clubMap,
      clubWorkshops: clubWorkshops,
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
                  child: this._toggling || clubMap == null
                      ? CircularProgressIndicator()
                      : Icon(
                          Icons.subscriptions,
                          color: clubMap.is_subscribed ? Colors.red : Colors.black26,
                        ),
                ),
          body: RefreshIndicator(
            onRefresh: () async {
              clubMap = await AppConstants.refreshClubInDatabase(clubId: widget.club.id);
              setState(() {});
            },
            child: SlidingUpPanel(
              body: ClubAndCouncilWidgets.getPanelBackground(context, _clubLargeLogoFile,
                  isClub: true, clubDetail: clubMap),
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
                  clubCustomWidgets.getPanel(sc: sc, club: widget.club),
              minHeight: ClubAndCouncilWidgets.getMinPanelHeight(context),
              maxHeight: ClubAndCouncilWidgets.getMaxPanelHeight(context),
              header: ClubAndCouncilWidgets.getHeader(context),
            ),
          ),
        ),
      ),
    );
  }
}
