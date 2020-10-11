import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/external_libraries/spin_kit.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/pages/club/club.dart';
import 'package:iit_app/pages/club_council_common/club_&_council_widgets.dart';
import 'package:iit_app/pages/create.dart';
import 'package:iit_app/screens/home/home_widgets.dart';
import 'package:iit_app/ui/colorPicker.dart';
import 'package:iit_app/ui/separator.dart';
import 'package:iit_app/ui/text_style.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'workshop_detail_widgets.dart';

class WorkshopDetailPage extends StatefulWidget {
  final BuiltWorkshopSummaryPost workshop;
  final bool isPast;
  const WorkshopDetailPage({Key key, this.workshop, this.isPast = false})
      : super(key: key);
  @override
  _WorkshopDetailPage createState() => _WorkshopDetailPage();
}

class _WorkshopDetailPage extends State<WorkshopDetailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  BuiltWorkshopDetailPost _workshop;
  int is_interested;

  ValueNotifier<Color> _colorListener;
  ColorPicker _colorPicker;

  bool _mainBg = false,
      _cardBg = false,
      _bodyBg = false,
      _panelBg = false,
      _porBg = false,
      _headingColor = false;

  setColorPalleteOff() {
    _mainBg = false;
    _cardBg = false;
    _bodyBg = false;
    _panelBg = false;
    _porBg = false;
    _headingColor = false;
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
                _colorListener.value =
                    ColorConstants.workshopContainerBackground;
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
                _headingColor = true;
                _colorListener.value = ColorConstants.headingColor;
                return _colorPicker.getColorPickerDialogBox(context);
              },
              child: Text('panel headings'),
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
    } else if (_headingColor) {
      ColorConstants.headingColor = _colorListener.value;
    }
  }

  @override
  void initState() {
    this._colorListener = ValueNotifier(Colors.white);
    this._colorPicker = ColorPicker(this._colorListener);

    fetchWorkshopDetails();
    super.initState();
  }

  Widget loadingAnimation() {
    return LoadingCircle;
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
                        builder: (context) =>
                            ClubPage(club: _workshop.club, editMode: true)));
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

  Future<bool> confirmCalendarOpenDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Open Calendar"),
          content: new Text(
              "You have expressed Interest!\nDo you want to save this event to your Google Calendar?"),
          actions: <Widget>[
            FlatButton(
              child: new Text("Yup!"),
              onPressed: () {
                Navigator.of(context).pop(true);
                return true;
              },
            ),
            FlatButton(
              child: new Text("Nope"),
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
        .getWorkshopDetailsPost(widget.workshop.id, AppConstants.djangoToken)
        .catchError((onError) {
      print("Error in fetching workshop: ${onError.toString()}");
    });
    _workshop = snapshots.body;
    if (_workshop.is_interested != null) {
      is_interested = _workshop.is_interested ? 1 : -1;
    } else {
      is_interested = -1;
    }
    if (!this.mounted) return;
    setState(() {});
  }

  void deleteWorkshop() async {
    await confirmCreateDialog()
        ? await AppConstants.service
            .removeWorkshop(widget.workshop.id, AppConstants.djangoToken)
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
        .toggleInterestedWorkshop(widget.workshop.id, AppConstants.djangoToken)
        .then((snapshot) {
      print("status of toggle workshop: ${snapshot.statusCode}");
      if (snapshot.isSuccessful) {
        is_interested = (_workshop.is_interested ? 1 : -1) * -1;
        int _newInterestedUser = is_interested == 1 ? 1 : -1;
        _workshop.rebuild((b) => b
          ..interested_users = _workshop.interested_users + _newInterestedUser);
      }
    }).catchError((onError) {
      print("Error in toggleing: ${onError.toString()}");
    });
    setState(() {});
    fetchWorkshopDetails();
  }

  Container _getBackground() {
    final File clubLogoFile = AppConstants.getImageFile(
        isSmall: true, id: widget.workshop.club.id, isClub: true);

    return Container(
      child: clubLogoFile == null
          ? Image.network(widget.workshop.club.small_image_url,
              fit: BoxFit.cover, height: 300.0)
          : Image.file(clubLogoFile, fit: BoxFit.cover, height: 300),
      constraints: BoxConstraints.expand(height: 295.0),
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
                height: widget.isPast ? 40 : 60.0,
                width: widget.isPast ? 50.0 : 130.0,
                decoration: BoxDecoration(
                    color: ColorConstants.workshopCardContainer,
                    borderRadius: BorderRadius.circular(30.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(width: 7.0),
                    Text(
                      '${_workshop.interested_users}',
                      style: TextStyle(fontSize: 14.0, color: Colors.white),
                    ),
                    widget.isPast
                        ? Container()
                        : is_interested == 0
                            ? Container(
                                child: loadingAnimation(),
                                height: 20,
                                width: 20)
                            : InkWell(
                                onTap: () async {
                                  if (AppConstants.isGuest) {
                                    _scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                      content: Text('Please Log In first'),
                                      duration: Duration(seconds: 2),
                                    ));
                                  } else {
                                    if (is_interested != 1) {
                                      bool shouldCalendarBeOpened =
                                          await confirmCalendarOpenDialog();
                                      print(shouldCalendarBeOpened);
                                      if (shouldCalendarBeOpened == true) {
                                        final String _calendarUrl =
                                            AppConstants.addEventToCalendarLink(
                                                workshop: _workshop);
                                        print(
                                            'add event to calendar URL: $_calendarUrl');
                                        launch(_calendarUrl);
                                      }
                                    }
                                    updateButton();
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(Icons.star,
                                        color: is_interested == 1
                                            ? Colors.blue[400]
                                            : Colors.blue[100],
                                        size: 25.0),
                                    Text(
                                      'Interested',
                                      style: TextStyle(
                                        color: is_interested == 1
                                            ? Colors.blue[400]
                                            : Colors.blue[100],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                    SizedBox(width: 7.0),
                  ],
                ),
              ),
      ],
    );
  }

  Container _getContent() {
    final _overviewTitle = "Description".toUpperCase();
    return Container(
      child: ListView(
        padding: EdgeInsets.fromLTRB(0.0, 72.0, 0.0, 32.0),
        children: <Widget>[
          HomeWidgets.getWorkshopCard(context,
              w: widget.workshop, editMode: false, horizontal: false),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _overviewTitle,
                  style: Style.headerTextStyle,
                ),
                Separator(),
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

  Stack _getBody(context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35.0),
                bottomRight: Radius.circular(35.0)),
            color: ColorConstants.workshopContainerBackground,
          ),
        ),
        _getBackground(),
        WorkshopDetailWidgets.getGradient(),
        _getContent(), //_workshop == null
        WorkshopDetailWidgets.getToolbar(context),
        _workshop == null
            ? Container()
            : _workshop.is_por_holder == false
                ? Container()
                : editWorkshopOptions()
      ],
    );
  }

  Container _getPanel({ScrollController sc}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        color: ColorConstants.panelColor,
      ),
      padding: EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 10.0),
      child: ListView(
        controller: sc,
        children: [
          WorkshopDetailWidgets.getHeading(
              icon: Icons.location_on, title: 'Location'),
          SizedBox(height: 5.0),
          _workshop == null
              ? Container(
                  height: 35.0,
                  child: Center(child: LoadingCircle),
                )
              : Text(
                  _workshop.location,
                  //'Not Specified yet',
                  //style: baseTextStyle,
                ),
          SizedBox(height: 5.0),
          Text(
            //'${_workshop.longitude}',
            '(Lattitude,Longitude)',
            //style: baseTextStyle,
          ),
          SizedBox(height: 15.0),
          WorkshopDetailWidgets.getHeading(
              icon: Icons.library_books, title: 'Resouces'),
          SizedBox(height: 5.0),
          _workshop == null
              ? Container(
                  height: 35.0,
                  child: Center(child: LoadingCircle),
                )
              : Text(
                  //_workshop.resources,
                  'No Resources',
                ),
          SizedBox(height: 15.0),
          WorkshopDetailWidgets.getHeading(
              icon: Icons.people, title: 'Audience'),
          SizedBox(height: 5.0),
          _workshop == null
              ? Container(
                  height: 35.0,
                  child: Center(child: LoadingCircle),
                )
              : Text(
                  _workshop.audience,
                  //'No Audience',
                ),
          SizedBox(height: 15.0),
          WorkshopDetailWidgets.getHeading(
              icon: Icons.contacts, title: 'Contacts'),
          SizedBox(height: 5.0),
          _workshop == null
              ? Container(
                  height: 35.0,
                  child: Center(child: LoadingCircle),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: ColorConstants.porHolderBackground,
                  ),
                  //color:Colors.grey[300],
                  padding: EdgeInsets.only(
                    top: 20.0,
                  ),
                  height: 180.0,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _workshop.contacts.length,
                    itemBuilder: (context, index) {
                      return ClubAndCouncilWidgets.getPosHolder(
                        imageUrl: _workshop.contacts[index].photo_url,
                        name: _workshop.contacts[index].name,
                        email: _workshop.contacts[index].email,
                        context: context,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(width: 15.0);
                    },
                  ),
                ),
          SizedBox(height: 15.0),
          WorkshopDetailWidgets.getHeading(icon: Icons.bookmark, title: 'Tags'),
          SizedBox(height: 5.0),
          _workshop == null
              ? Container(
                  height: 35.0,
                  child: Center(child: LoadingCircle),
                )
              : Container(
                  //height: ,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: _workshop.tags.length,
                    itemBuilder: (context, index) {
                      return WorkshopDetailWidgets.getTag(
                          tag: _workshop.tags[index].tag_name, index: index);
                    },
                  ),
                ),
        ],
      ),
    );
  }

  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(2.0),
      child: ValueListenableBuilder(
          valueListenable: _colorListener,
          builder: (context, color, child) {
            setColor();

            return Scaffold(
              key: _scaffoldKey,
              backgroundColor: ColorConstants.backgroundThemeColor,
              body: Stack(
                children: [
                  SlidingUpPanel(
                    body: _getBody(context),
                    borderRadius: radius,
                    backdropEnabled: true,
                    parallaxEnabled: true,
                    collapsed: Container(
                      decoration: BoxDecoration(
                        borderRadius: radius,
                      ),
                    ),
                    minHeight: MediaQuery.of(context).size.height / 4 - 20.0,
                    maxHeight: MediaQuery.of(context).size.height - 20.0,
                    header: WorkshopDetailWidgets.getPanelHeader(context),
                    panelBuilder: (ScrollController sc) => _getPanel(sc: sc),
                  ),
                  AppConstants.chooseColorPaletEnabled
                      ? _colorSelectOptionRow(context)
                      : Container()
                ],
              ),
            );
          }),
    );
  }
}
