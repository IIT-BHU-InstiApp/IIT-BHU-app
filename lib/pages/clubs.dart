import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/pages/create.dart';
import 'package:iit_app/screens/home/home_widgets.dart';

class ClubPage extends StatefulWidget {
  final int clubId;
  final bool editMode;
  const ClubPage({Key key, @required this.clubId, this.editMode = false})
      : super(key: key);
  @override
  _ClubPageState createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> {
  TextStyle tempStyle = TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold);
  BuiltClubPost clubMap;
  bool _loadingWorkshops = true;
  bool _toggling = false;

  @override
  void initState() {
    print("Club opened in edit mode:${widget.editMode}");
    fetchClubDataById();
    super.initState();
  }

  fetchClubDataById() async {
    if (clubMap == null) {
      clubMap =
          await AppConstants.getClubDetailsFromDatabase(clubId: widget.clubId);
    }
    if (!this.mounted) {
      return;
    }
    setState(() {});

    Response<BuiltClubPost> snapshots = await AppConstants.service
        .getClub(widget.clubId, "token ${AppConstants.djangoToken}")
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
            widget.clubId, "token ${AppConstants.djangoToken}")
        .then((snapshot) async {
      print("status of club subscription: ${snapshot.statusCode}");
      if (snapshot.statusCode == 200) {
        await AppConstants.updateClubSubscriptionInDatabase(
            clubId: widget.clubId,
            isSubscribed: !clubMap.is_subscribed,
            currentSubscribedUsers: clubMap.subscribed_users);

        var activeWorkshops = clubMap.active_workshops;
        var pastWorkshops = clubMap.past_workshops;

        clubMap = await AppConstants.getClubDetailsFromDatabase(
            clubId: widget.clubId);

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
  final headingStyle = TextStyle(
      fontSize: 30.0,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.0);
  Widget template({String imageUrl, String name, String desg}) {
    return Column(
      children: <Widget>[
        space,
        Center(
            child: CircleAvatar(
          backgroundImage: imageUrl == null
              ? AssetImage('assets/iitbhu.jpeg')
              : NetworkImage(imageUrl),
          radius: 30.0,
          backgroundColor: Colors.transparent,
        )),
        Container(
          child: Text(name, textAlign: TextAlign.center),
          width: 100,
        ),
        Text(desg, textAlign: TextAlign.center),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            SliverAppBar(
              backgroundColor: Colors.grey[300],
              floating: true,
              expandedHeight: MediaQuery.of(context).size.height / 4,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    clubMap == null
                        ? Container(
                            height: MediaQuery.of(context).size.height / 4,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Container(
                            height: MediaQuery.of(context).size.height / 4,
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Image(
                                image: clubMap.large_image_url == null
                                    ? AssetImage('assets/iitbhu.jpeg')
                                    : NetworkImage(clubMap.large_image_url),
                                fit: BoxFit.fill,
                              ),
                              elevation: 2.5,
                            ),
                          ),
                    clubMap == null
                        ? Container()
                        : Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              padding: EdgeInsets.all(15.0),
                              child: FloatingActionButton(
                                elevation: 3.0,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                onPressed: () {},
                                child: Image(
                                  image: clubMap.council.small_image_url == null
                                      ? AssetImage('assets/iitbhu.jpeg')
                                      : NetworkImage(
                                          clubMap.council.small_image_url,
                                        ),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  space,
                  clubMap == null
                      ? Container()
                      : Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                clubMap.name,
                                style: headingStyle,
                              ),
                            ],
                          ),
                        ),
                  space,
                  clubMap == null
                      ? Container(
                          height: MediaQuery.of(context).size.height / 4,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              clubMap.secy == null
                                  ? Container()
                                  : template(
                                      name: clubMap.secy.name,
                                      desg: 'Secy',
                                      imageUrl: clubMap.secy.photo_url),
                              // template(
                              //     name: clubMap.joint_secy[0].name,
                              //     desg: 'JointSecy',
                              //     imageUrl: clubMap.joint_secy[0].photo_url),
                              // template(
                              //     name: clubMap.joint_secy[1].name,
                              //     desg: 'JointSecy',
                              //     imageUrl: clubMap.joint_secy[1].photo_url),
                            ],
                          ),
                        ),
                  Center(
                    child: Text(
                      'Description',
                      style: headingStyle,
                    ),
                  ),
                  divide,
                  clubMap == null
                      ? Container()
                      : Text('${clubMap.description}',
                          style: TextStyle(fontSize: 20, color: Colors.black)),
                  space,
                  RaisedButton(
                      child: Text('Create workshop'),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CreateScreen(
                                clubId: clubMap.id, clubName: clubMap.name),
                          ),
                        );
                      }),
                  widget.editMode
                      ? Center(
                          child: Text(
                            'Edit Workshops Here:',
                            style: headingStyle,
                          ),
                        )
                      : SizedBox(height: 1),
                  Center(
                    child: Text(
                      'Active Workshops',
                      style: headingStyle,
                    ),
                  ),
                  clubMap == null || this._loadingWorkshops
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
                        ),
                  Center(
                    child: Text(
                      'Past Workshops',
                      style: headingStyle,
                    ),
                  ),
                  clubMap == null || this._loadingWorkshops
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
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
