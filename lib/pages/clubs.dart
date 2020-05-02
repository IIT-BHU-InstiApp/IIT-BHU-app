import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/pages/club_&_council_widgets.dart';
import 'package:iit_app/pages/create.dart';
import 'package:iit_app/screens/home/home_widgets.dart';
import 'package:iit_app/ui/separator.dart';
import 'package:iit_app/ui/text_style.dart';

class ClubPage extends StatefulWidget {
  final ClubListPost club;
  final bool editMode;
  const ClubPage({Key key, @required this.club, this.editMode = false})
      : super(key: key);
  @override
  _ClubPageState createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> {
  TextStyle tempStyle = TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold);
  BuiltClubPost clubMap;
  bool _loadingWorkshops = true;
  bool _toggling = false;

  File _clubLargeLogoFile;

  @override
  void initState() {
    print("Club opened in edit mode:${widget.editMode}");
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

    Response<BuiltClubPost> snapshots = await AppConstants.service
        .getClub(widget.club.id, "token ${AppConstants.djangoToken}")
        .catchError((onError) {
      print("Error in fetching clubs: ${onError.toString()}");
    });
    clubMap = snapshots.body;
    if (!this.mounted) {
      return;
    }
    AppConstants.updateClubDetailsInDatabase(clubPost: clubMap);
    setState(() {
      this._loadingWorkshops = false;
    });
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

        var activeWorkshops = clubMap.active_workshops;
        var pastWorkshops = clubMap.past_workshops;

        clubMap = await AppConstants.getClubDetailsFromDatabase(
            clubId: widget.club.id);

        clubMap = clubMap.rebuild((b) => b
          ..active_workshops = activeWorkshops.toBuilder()
          ..past_workshops = pastWorkshops.toBuilder());
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

  SliverAppBar _getSliverAppBar(context) {
    return SliverAppBar(
      leading: Container(),
      backgroundColor: Colors.white,
      floating: true,
      expandedHeight: MediaQuery.of(context).size.height * 3 / 4,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            Container(
              //height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35.0),
                      bottomRight: Radius.circular(35.0)),
                  color: Color(0xFF736AB7)),
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
        ),
      ),
    );
  }

  Container _getClubCardAndDescription() {
    final _overviewTitle = "Description".toUpperCase();
    return new Container(
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
          clubMap == null
              ? Container(
                  height: MediaQuery.of(context).size.height * 3 / 4,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(
                  padding: new EdgeInsets.symmetric(horizontal: 32.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        _overviewTitle,
                        style: Style.headerTextStyle,
                      ),
                      Separator(),
                      Text(clubMap.description, style: Style.commonTextStyle),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget _getActiveWorkshops() {
    return clubMap == null || this._loadingWorkshops
        ? Container(
            height: MediaQuery.of(context).size.height / 4,
            child: Center(
              child: CircularProgressIndicator(),
            ))
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: clubMap.active_workshops.length,
            // posts.length,
            padding: EdgeInsets.all(8),
            itemBuilder: (context, index) {
              return HomeWidgets.getWorkshopCard(
                context,
                w: clubMap.active_workshops[index],
                editMode: widget.editMode,
              );
            },
          );
  }

  Widget _getPastWorkshops() {
    return clubMap == null || this._loadingWorkshops
        ? Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: clubMap.past_workshops.length,
            // posts.length,
            padding: EdgeInsets.all(8),
            itemBuilder: (context, index) {
              return HomeWidgets.getWorkshopCard(
                context,
                w: clubMap.past_workshops[index],
                editMode: widget.editMode,
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          _getSliverAppBar(context),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                space,
                clubMap == null
                    ? Container()
                    : RaisedButton(
                        child: Text('Create workshop'),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CreateScreen(
                                  club: widget.club, clubName: clubMap.name),
                            ),
                          );
                        }),
                widget.editMode
                    ? Center(
                        child: Text('Edit Workshops Here:',
                            style: Style.headingStyle),
                      )
                    : SizedBox(height: 1),
                Center(
                  child: Text('Active Workshops', style: Style.headingStyle),
                ),
                _getActiveWorkshops(),
                Center(
                  child: Text('Past Workshops', style: Style.headingStyle),
                ),
                _getPastWorkshops(),
                space,
                clubMap == null
                    ? Container(
                        height: MediaQuery.of(context).size.height / 4,
                        child: Center(child: CircularProgressIndicator()))
                    : ClubAndCouncilWidgets.getSecies(context,
                        secy: clubMap.secy, joint_secy: clubMap.joint_secy),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
