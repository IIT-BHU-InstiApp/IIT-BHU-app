import 'dart:io';
import 'package:chopper/chopper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/external_libraries/spin_kit.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/pages/club_council_common/club_&_council_widgets.dart';
import 'package:iit_app/pages/club_council_common/description.dart';
import 'package:iit_app/pages/create.dart';
import 'package:iit_app/ui/colorPicker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'workshop_tabs.dart';
import 'package:iit_app/screens/account.dart';

class ClubPage extends StatefulWidget {
  final ClubListPost club;
  final bool editMode;
  const ClubPage({Key key, @required this.club, this.editMode = false}) : super(key: key);
  @override
  _ClubPageState createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> with SingleTickerProviderStateMixin {
  TextStyle tempStyle = TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold);
  BuiltClubPost clubMap;
  BuiltAllWorkshopsPost clubWorkshops;
  bool _toggling = false;
  TabController _tabController;

  File _clubLargeLogoFile;

  ValueNotifier<Color> _colorListener;
  ColorPicker _colorPicker;

  bool _mainBg = false,
      _cardBg = false,
      _bodyBg = false,
      _panelBg = false,
      _porBg = false,
      _panelContainer = false;

  setColorPalleteOff() {
    _mainBg = false;
    _cardBg = false;
    _bodyBg = false;
    _panelBg = false;
    _porBg = false;
    _panelContainer = false;
  }

  Widget _colorSelectOptionRow(context) {
    return Container(
      height: 45,
      color: Colors.white,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Container(
            color: Colors.blue[100],
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            child: InkWell(
              onTap: () {
                setColorPalleteOff();
                _mainBg = true;
                _colorListener.value = ColorConstants.backgroundThemeColor;
                return _colorPicker.getColorPickerDialogBox(context);
              },
              child: Text('main bg'),
            ),
          ),
          Container(
            color: Colors.blue[100],
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            child: InkWell(
              onTap: () {
                setColorPalleteOff();
                _cardBg = true;
                _colorListener.value = ColorConstants.workshopCardContainer;
                return _colorPicker.getColorPickerDialogBox(context);
              },
              child: Text('card bg'),
            ),
          ),
          Container(
            color: Colors.blue[100],
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            child: InkWell(
              onTap: () {
                setColorPalleteOff();
                _bodyBg = true;
                _colorListener.value = ColorConstants.workshopContainerBackground;
                return _colorPicker.getColorPickerDialogBox(context);
              },
              child: Text('body bg'),
            ),
          ),
          Container(
            color: Colors.blue[100],
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            child: InkWell(
              onTap: () {
                setColorPalleteOff();
                _panelBg = true;
                _colorListener.value = ColorConstants.panelColor;
                return _colorPicker.getColorPickerDialogBox(context);
              },
              child: Text('panel bg'),
            ),
          ),
          Container(
            color: Colors.blue[100],
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            child: InkWell(
              onTap: () {
                setColorPalleteOff();
                _porBg = true;
                _colorListener.value = ColorConstants.porHolderBackground;
                return _colorPicker.getColorPickerDialogBox(context);
              },
              child: Text('por bg'),
            ),
          ),
          Container(
            color: Colors.blue[100],
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            child: InkWell(
              onTap: () {
                setColorPalleteOff();
                _panelContainer = true;
                _colorListener.value = ColorConstants.workshopContainerBackground;
                return _colorPicker.getColorPickerDialogBox(context);
              },
              child: Text('wokrshop container'),
            ),
          ),
          Container(
            color: Colors.red[100],
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            child: InkWell(
              onTap: () {
                setColorPalleteOff();
                AppConstants.chooseColorPaletEnabled = false;
                _colorListener.value = Colors.white;
              },
              child: Text('Clear  X'),
            ),
          ),
        ],
      ),
    );
  }

  setColor() {
    if (_mainBg) {
      ColorConstants.backgroundThemeColor = _colorListener.value;
    } else if (_cardBg) {
      ColorConstants.workshopCardContainer = _colorListener.value;
    } else if (_bodyBg) {
      ColorConstants.workshopContainerBackground = _colorListener.value;
    } else if (_panelBg) {
      ColorConstants.panelColor = _colorListener.value;
    } else if (_porBg) {
      ColorConstants.porHolderBackground = _colorListener.value;
    } else if (_panelContainer) {
      ColorConstants.workshopContainerBackground = _colorListener.value;
    }
  }

  @override
  void initState() {
    this._colorListener = ValueNotifier(Colors.white);
    this._colorPicker = ColorPicker(this._colorListener);

    print("Club opened in edit mode:${widget.editMode}");
    _tabController = TabController(length: 2, vsync: this);
    fetchClubDataById();
    super.initState();
  }

  void reload() {
    fetchClubDataById();
  }

  fetchClubDataById() async {
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

        // var activeWorkshops = clubMap.active_workshops;
        // var pastWorkshops = clubMap.past_workshops;

        clubMap = await AppConstants.getClubDetailsFromDatabase(clubId: widget.club.id);

        if (clubMap.is_subscribed == true) {
          await FirebaseMessaging()
              .subscribeToTopic('C_${clubMap.id}')
              .then((_) => print('subscribed to C_${clubMap.id}'));
        } else {
          await FirebaseMessaging().unsubscribeFromTopic('C_${clubMap.id}');
        }

        // clubMap = clubMap.rebuild((b) => b
        //   ..active_workshops = activeWorkshops.toBuilder()
        //   ..past_workshops = pastWorkshops.toBuilder());
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

  final divide = Divider(height: 8.0, thickness: 2.0, color: Colors.blue);
  final space = SizedBox(height: 8.0);

  Widget _getBackground(context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      color: ColorConstants.workshopContainerBackground,
      //height:MediaQuery.of(context).size.height * 0.90,
      child: ListView(
        shrinkWrap: true,
        children: [
          clubMap == null
              ? Container(
                  height: MediaQuery.of(context).size.height * 3 / 4,
                  child: Center(
                    child: LoadingCircle,
                  ),
                )
              : Stack(
                  children: [
                    Container(
                      child: _clubLargeLogoFile == null
                          ? Image.network(clubMap.large_image_url, fit: BoxFit.cover, height: 300.0)
                          : Image.file(_clubLargeLogoFile, fit: BoxFit.cover, height: 300.0),
                      constraints: BoxConstraints.expand(height: 295.0),
                    ),
                    ClubAndCouncilWidgets.getGradient(),
                    Container(
                      padding: EdgeInsets.fromLTRB(0.0, 72.0, 0.0, 0.0),
                      child: ClubAndCouncilWidgets.getClubCard(
                          title: widget.club.name,
                          subtitle: widget.club.council.name,
                          id: widget.club.id,
                          imageUrl: widget.club.large_image_url,
                          isCouncil: false,
                          context: context),
                    ),
                    ClubAndCouncilWidgets.getToolbar(context),
                  ],
                ),
          SizedBox(height: 8.0),
          Padding(
            padding: EdgeInsets.only(
              bottom: bottom,
            ),
            child: Description(map: clubMap, isClub: true),
          ),
          SizedBox(height: 15.0),
          clubWorkshops == null
              ? Container(
                  height: ClubAndCouncilWidgets.getMinPanelHeight(context),
                  child: Center(child: LoadingCircle))
              : ClubAndCouncilWidgets.getSecies(context,
                  secy: clubMap.secy, joint_secy: clubMap.joint_secy),
          clubMap == null ? Container() : ClubAndCouncilWidgets.getSocialLinks(clubMap),
          SizedBox(height: 1.5 * ClubAndCouncilWidgets.getMinPanelHeight(context)),
        ],
      ),
    );
  }

  Widget _getPanel({ScrollController sc}) {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      decoration: BoxDecoration(
        borderRadius: radius,
        color: ColorConstants.panelColor,
      ),
      child: ListView(
        controller: sc,
        children: [
          space,
          clubMap != null
              ? clubMap.is_por_holder == true
                  ? RaisedButton(
                      child: Text('Create workshop'),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                CreateScreen(club: widget.club, clubName: clubMap.name),
                          ),
                        );
                      })
                  : Container()
              : Container(),
          WorkshopTabs.getActiveAndPastTabBarForClub(
              clubWorkshops: clubWorkshops,
              tabController: _tabController,
              context: context,
              reload: reload),
          space,
        ],
      ),
    );
  }

  Future<bool> _onPress() {
    print("Clubscreen:${AccountScreen.flag}");
    if (AccountScreen.flag == "Account")
      Navigator.push(context, MaterialPageRoute(builder: (context) => AccountScreen()));
    else
      Navigator.pop(context);
    return Future.value(false);
  }

  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );
  PanelController _pc = PanelController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onPress,
        child: SafeArea(
          minimum: const EdgeInsets.all(2.0),
          child: ValueListenableBuilder(
              valueListenable: _colorListener,
              builder: (context, color, child) {
                setColor();
                return Scaffold(
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
                    child: Stack(
                      children: [
                        SlidingUpPanel(
                          body: _getBackground(context),
                          parallaxEnabled: true,
                          controller: _pc,
                          borderRadius: radius,
                          collapsed: Container(
                            decoration: BoxDecoration(
                              borderRadius: radius,
                            ),
                          ),
                          backdropEnabled: true,
                          /*panel: Dismissible(
                      key: Key('clubs'),
                      direction: DismissDirection.down,
                      onDismissed: (_) => _pc.close(),
                      child: _getPanel(),
                    ),*/
                          panelBuilder: (ScrollController sc) => _getPanel(sc: sc),
                          minHeight: ClubAndCouncilWidgets.getMinPanelHeight(context),
                          maxHeight: ClubAndCouncilWidgets.getMaxPanelHeight(context),
                          header: ClubAndCouncilWidgets.getHeader(context),
                        ),
                        AppConstants.chooseColorPaletEnabled
                            ? _colorSelectOptionRow(context)
                            : Container()
                      ],
                    ),
                  ),
                );
              }),
        ));
  }
}
