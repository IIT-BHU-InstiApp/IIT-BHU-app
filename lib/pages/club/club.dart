import 'dart:io';
import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/pages/club_council_common/club_&_council_widgets.dart';
import 'package:iit_app/pages/club_council_common/description.dart';
import 'package:iit_app/pages/create.dart';
import 'package:iit_app/ui/separator.dart';
import 'package:iit_app/ui/text_style.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'workshop_tabs.dart';

class ClubPage extends StatefulWidget {
  final ClubListPost club;
  final bool editMode;
  const ClubPage({Key key, @required this.club, this.editMode = false})
      : super(key: key);
  @override
  _ClubPageState createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage>
    with SingleTickerProviderStateMixin {
  TextStyle tempStyle = TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold);
  BuiltClubPost clubMap;
  BuiltAllWorkshopsPost clubWorkshops;
  bool _toggling = false;
  TabController _tabController;

  File _clubLargeLogoFile;

  @override
  void initState() {
    print("Club opened in edit mode:${widget.editMode}");
    _tabController = new TabController(length: 2, vsync: this);
    fetchClubDataById();
    super.initState();
  }

  fetchClubDataById() async {
    if (clubMap == null) {
      clubMap =
          await AppConstants.getClubDetailsFromDatabase(clubId: widget.club.id);
    }
    if (clubMap != null) {
      _clubLargeLogoFile = AppConstants.getImageFile(
          isClub: true, isSmall: false, id: clubMap.id);

      if (_clubLargeLogoFile == null) {
        AppConstants.writeImageFileIntoDisk(
            isClub: true,
            isSmall: false,
            id: clubMap.id,
            url: clubMap.large_image_url);
      }
    }
    if (!this.mounted) {
      return;
    }
    setState(() {});

    Response<BuiltAllWorkshopsPost> snapshots = await AppConstants.service
        .getClubWorkshops(widget.club.id, "token ${AppConstants.djangoToken}")
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
        .toggleClubSubscription(
            widget.club.id, "token ${AppConstants.djangoToken}")
        .then((snapshot) async {
      print("status of club subscription: ${snapshot.statusCode}");
      if (snapshot.statusCode == 200) {
        await AppConstants.updateClubSubscriptionInDatabase(
            clubId: widget.club.id,
            isSubscribed: !clubMap.is_subscribed,
            currentSubscribedUsers: clubMap.subscribed_users);

        // var activeWorkshops = clubMap.active_workshops;
        // var pastWorkshops = clubMap.past_workshops;

        clubMap = await AppConstants.getClubDetailsFromDatabase(
            clubId: widget.club.id);

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
    return Stack(
      children: [
        Container(
          color: Color(0xFF736AB7),
          height: MediaQuery.of(context).size.height * 3 / 4,
          /*decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35.0),
                      bottomRight: Radius.circular(35.0)),
                  color: Color(0xFF736AB7)),*/
        ),
        clubMap == null
            ? Container(
                height: MediaQuery.of(context).size.height * 3 / 4,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
                child: _clubLargeLogoFile == null
                    ? Image.network(clubMap.large_image_url,
                        fit: BoxFit.cover, height: 300.0)
                    : Image.file(_clubLargeLogoFile,
                        fit: BoxFit.cover, height: 300.0),
                constraints: new BoxConstraints.expand(height: 295.0),
              ),
        ClubAndCouncilWidgets.getGradient(),
        _getClubCardAndDescription(),
        ClubAndCouncilWidgets.getToolbar(context),
      ],
    );
  }

  Container _getClubCardAndDescription() {
    return new Container(
      height: MediaQuery.of(context).size.height * 3 / 4,
      child: new ListView(
        padding: new EdgeInsets.fromLTRB(0.0, 72.0, 0.0, 32.0),
        children: <Widget>[
          ClubAndCouncilWidgets.getClubCard(
              title: widget.club.name,
              subtitle: widget.club.council.name,
              id: widget.club.id,
              imageUrl: widget.club.large_image_url,
              isCouncil: false,
              context: context),
          SizedBox(height: 8.0),
          Description(map: clubMap),
        ],
      ),
    );
  }

  Widget _getPanel({ScrollController sc}) {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
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
                            builder: (context) => CreateScreen(
                                club: widget.club, clubName: clubMap.name),
                          ),
                        );
                      })
                  : Container()
              : Container(),
          WorkshopTabs.getActiveAndPastTabBarForClub(
              clubWorkshops: clubWorkshops, tabController: _tabController),
          space,
          clubWorkshops == null
              ? Container(
                  height: MediaQuery.of(context).size.height / 4,
                  child: Center(child: CircularProgressIndicator()))
              : ClubAndCouncilWidgets.getSecies(context,
                  secy: clubMap.secy, joint_secy: clubMap.joint_secy),
          clubMap == null
              ? Container()
              : ClubAndCouncilWidgets.getSocialLinks(clubMap),
        ],
      ),
    );
  }

  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );
  PanelController _pc = PanelController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(2.0),
      child: Scaffold(
        backgroundColor: Color(0xFF736AB7),
        floatingActionButton: FloatingActionButton(
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
        body: SlidingUpPanel(
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
          minHeight: MediaQuery.of(context).size.height / 4 - 20.0,
          maxHeight: MediaQuery.of(context).size.height - 20.0,
          header: ClubAndCouncilWidgets.getHeader(context),
        ),
      ),
    );
  }
}
