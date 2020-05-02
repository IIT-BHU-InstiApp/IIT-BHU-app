import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/pages/clubs.dart';
import 'package:iit_app/pages/create.dart';
import 'package:iit_app/screens/home/home_widgets.dart';
import 'package:iit_app/screens/home/separator.dart';
import 'package:iit_app/screens/home/text_style.dart';

class DetailPage extends StatefulWidget {
  final BuiltWorkshopSummaryPost workshop;
  final bool isPast;
  const DetailPage({Key key, this.workshop, this.isPast = false})
      : super(key: key);
  @override
  _DetailPage createState() => _DetailPage();
}

class _DetailPage extends State<DetailPage> {
  BuiltWorkshopDetailPost _workshop;
  int is_interested;
  @override
  void initState() {
    fetchWorkshopDetails();
    super.initState();
  }

  Widget loadingAnimation() {
    return CircularProgressIndicator();
  }

  showSuccessfulDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Successful!"),
          content: new Text("Workshop succesfully deleted!"),
          actions: <Widget>[
            FlatButton(
              child: new Text("yay"),
              onPressed: () {
                // TODO: Refresh clubs page after deleting workshop!
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ClubPage(
                            club: _workshop.club, editMode: true)));
              },
            ),
          ],
        );
      },
    );
  }

  Future showUnSuccessfulDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("UnSuccessful :("),
          content: new Text("Please try again"),
          actions: <Widget>[
            FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> confirmCreateDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Create workshop"),
          content: new Text("Are you sure to create this new workshop?"),
          actions: <Widget>[
            FlatButton(
              child: new Text("Yup!"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            FlatButton(
              child: new Text("nope, let me rethink.."),
              onPressed: () {
                Navigator.of(context).pop(false);
                return false;
              },
            ),
          ],
        );
      },
    );
  }

  void fetchWorkshopDetails() async {
    Response<BuiltWorkshopDetailPost> snapshots = await AppConstants.service
        .getWorkshopDetailsPost(
            widget.workshop.id, "token ${AppConstants.djangoToken}")
        .catchError((onError) {
      print("Error in fetching workshop: ${onError.toString()}");
    });
    _workshop = snapshots.body;
    is_interested = _workshop.is_interested ? 1 : -1;
    setState(() {});
  }

  void deleteWorkshop() async {
    await confirmCreateDialog()
        ? await AppConstants.service
            .removeWorkshop(
                widget.workshop.id, "token ${AppConstants.djangoToken}")
            .then((snapshot) {
            print("status of deleting workshop: ${snapshot.statusCode}");
            showSuccessfulDialog();
          }).catchError((onError) {
            print("Error in deleting: ${onError.toString()}");
            showUnSuccessfulDialog();
          })
        : null;
    setState(() {});
  }

  void updateButton() async {
    is_interested = 0;
    setState(() {});
    await AppConstants.service
        .toggleInterestedWorkshop(
            widget.workshop.id, "token ${AppConstants.djangoToken}")
        .then((snapshot) {
      print("status of toggle workshop: ${snapshot.statusCode}");
      if (snapshot.isSuccessful) {
        is_interested = (_workshop.is_interested ? 1 : -1) * -1;
      }
    }).catchError((onError) {
      print("Error in toggleing: ${onError.toString()}");
    });
    fetchWorkshopDetails();
    setState(() {});
  }

  Container _getToolbar(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: new BackButton(color: Colors.lightGreen),
    );
  }

  Container _getBackground() {
    final File clubLogoFile = AppConstants.getImageFile(
        isSmall: true, id: widget.workshop.club.id, isClub: true);

    return new Container(
      child: clubLogoFile == null
          ? Image.network(widget.workshop.club.small_image_url,
              fit: BoxFit.cover, height: 300.0)
          : Image.file(clubLogoFile, fit: BoxFit.cover, height: 300),
      constraints: new BoxConstraints.expand(height: 295.0),
    );
  }

  Row _getPeopleGoing() {
    return Row(
      children: <Widget>[
        Text(widget.isPast ? 'Interested by:' : 'People Going:',
            style: TextStyle(
                fontFamily: 'Opensans',
                fontSize: 15.0,
                color: Colors.white,
                fontWeight: FontWeight.w600)),
        SizedBox(width: 20),
        _workshop == null
            ? loadingAnimation()
            : Container(
                padding: EdgeInsets.only(left: 5.0),
                height: widget.isPast ? 40 : 50.0,
                width: widget.isPast ? 50.0 : 100.0,
                decoration: BoxDecoration(
                    color: Color(0xFF333366),
                    borderRadius: BorderRadius.circular(25.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(height: 7.0),
                    Text('${_workshop.interested_users}',
                        style: TextStyle(fontSize: 14.0, color: Colors.white)),
                    widget.isPast
                        ? Container()
                        : is_interested == 0
                            ? Container(
                                child: loadingAnimation(),
                                height: 20,
                                width: 20)
                            : InkWell(
                                child: Icon(Icons.people,
                                    color: is_interested == 1
                                        ? Colors.blue[400]
                                        : Colors.blue[100],
                                    size: 25.0),
                                onTap: () => updateButton(),
                              ),
                    SizedBox(height: 7.0)
                  ],
                ),
              ),
      ],
    );
  }

  Container _getContent() {
    final _overviewTitle = "Description".toUpperCase();
    return new Container(
      child: new ListView(
        padding: new EdgeInsets.fromLTRB(0.0, 72.0, 0.0, 32.0),
        children: <Widget>[
          HomeWidgets.getWorkshopCard(context,
              w: widget.workshop, editMode: false, horizontal: false),
          Container(
            padding: new EdgeInsets.symmetric(horizontal: 32.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  _overviewTitle,
                  style: Style.headerTextStyle,
                ),
                new Separator(),
                _workshop == null
                    ? loadingAnimation()
                    : Text(_workshop.description, style: Style.commonTextStyle),
                _getPeopleGoing(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _getGradient() {
    return new Container(
      margin: new EdgeInsets.only(top: 190.0),
      height: 110.0,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: <Color>[new Color(0x00736AB7), new Color(0xFF736AB7)],
          stops: [0.0, 0.9],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 1.0),
        ),
      ),
    );
  }

  Widget editWorkshopOptions() {
    return Positioned(
      right: 20,
      top: 30,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                'Edit',
                style: TextStyle(
                    color: Colors.yellow, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.yellow,
                ),
                iconSize: 50,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateScreen(
                        club: _workshop.club,
                        clubName: _workshop.club.name,
                        workshopData: _workshop,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Text(
                'Delete',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              IconButton(
                  iconSize: 50,
                  icon: Icon(Icons.delete_forever, color: Colors.red),
                  onPressed: () => deleteWorkshop()),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: Container(),
            backgroundColor: Colors.white,
            expandedHeight: MediaQuery.of(context).size.height * 0.75,
            floating: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(35.0),
                            bottomRight: Radius.circular(35.0)),
                        color: Color(0xFF736AB7)),
                  ),
                  _getBackground(),
                  _getGradient(),
                  _getContent(), //_workshop == null
                  _getToolbar(context),
                  _workshop == null
                      ? Container()
                      : _workshop.is_por_holder == false
                          ? Container()
                          : editWorkshopOptions()
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
