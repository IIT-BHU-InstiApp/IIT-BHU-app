import 'package:chopper/chopper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/external_libraries/spin_kit.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/model/workshopCreator.dart';
import 'package:iit_app/pages/club/clubPage.dart';
import 'package:iit_app/ui/club_council_common/club_&_council_widgets.dart';
import 'package:iit_app/ui/dialogBoxes.dart';
import 'package:iit_app/ui/workshopDetail_custom_widgets.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class WorkshopDetailPage extends StatefulWidget {
  final BuiltWorkshopSummaryPost workshop;
  final bool isPast;
  WorkshopDetailPage({Key key, this.workshop, this.isPast = false}) : super(key: key);
  @override
  _WorkshopDetailPage createState() => _WorkshopDetailPage();
}

class _WorkshopDetailPage extends State<WorkshopDetailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  BuiltWorkshopSummaryPost workshopSummary;

  BuiltWorkshopDetailPost _workshop;
  int is_interested;

  @override
  void initState() {
    this.workshopSummary = widget.workshop;
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
          content: new Text("Succesfully deleted!"),
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
                        builder: (context) => ClubPage(club: _workshop.club, editMode: true)));
              },
            ),
          ],
        );
      },
    );
  }

  Future showUnsuccessfulDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Unsuccessful :("),
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

  Future<bool> confirmDeleteDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Delete resource"),
          content: new Text("Are you sure to remove this resource?"),
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
        .getWorkshopDetailsPost(workshopSummary.id, AppConstants.djangoToken)
        .catchError((onError) {
      print("Error in fetching workshop: ${onError.toString()}");
    });
    _workshop = snapshots.body;
    if (_workshop.is_interested != null) {
      is_interested = _workshop.is_interested ? 1 : -1;
    } else {
      is_interested = -1;
    }

    print(_workshop.toString());

    workshopSummary = workshopSummary.rebuild((builder) => builder
      ..title = _workshop.title
      ..date = _workshop.date
      ..time = _workshop.time
      ..tags = _workshop.tags.toBuilder());

    if (!this.mounted) return;
    setState(() {});
  }

  void deleteWorkshop() async {
    bool isConfirmed =
        await CreatePageDialogBoxes.confirmDialog(context: context, action: 'Delete');
    if (isConfirmed == true) {
      AppConstants.service
          .removeWorkshop(workshopSummary.id, AppConstants.djangoToken)
          .then((snapshot) async {
        await WorkshopCreater.deleteImageFromFirestore(_workshop.image_url);

        print("status of deleting workshop: ${snapshot.statusCode}");
        showSuccessfulDialog();
      }).catchError((onError) {
        print("Error in deleting: ${onError.toString()}");
        CreatePageDialogBoxes.showUnsuccessfulDialog(context: context);
      });
    }
    setState(() {});
  }

  void deleteResource(int id) async {
    print(id);
    await confirmDeleteDialog()
        ? await AppConstants.service
            .deleteWorkshopResources(id, AppConstants.djangoToken)
            .then((snapshot) {
            print("status of deleting resource ${snapshot.statusCode}");
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(content: Text("Resource deleted"), actions: <Widget>[
                    FlatButton(
                      child: Text("yay"),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    )
                  ]);
                });
          }).catchError((onError) {
            final error = onError as Response<dynamic>;
            print(error.body);
            print("Error in deleting: ${onError.toString()}");
            showUnsuccessfulDialog();
          })
        : null;
    setState(() {});
  }

  void updateButton() async {
    is_interested = 0;
    setState(() {});
    await AppConstants.service
        .toggleInterestedWorkshop(workshopSummary.id, AppConstants.djangoToken)
        .then((snapshot) {
      print("status of toggle workshop: ${snapshot.statusCode}");
      if (snapshot.isSuccessful) {
        is_interested = (_workshop.is_interested ? 1 : -1) * -1;
        int _newInterestedUser = is_interested == 1 ? 1 : -1;

        if (_newInterestedUser == 1) {
          FirebaseMessaging().subscribeToTopic('W_${_workshop.id}');
        } else {
          FirebaseMessaging().unsubscribeFromTopic('W_${_workshop.id}');
        }

        _workshop
            .rebuild((b) => b..interested_users = _workshop.interested_users + _newInterestedUser);
      }
    }).catchError((onError) {
      print("Error in toggleing: ${onError.toString()}");
    });
    setState(() {});
    fetchWorkshopDetails();
  }

  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  @override
  Widget build(BuildContext context) {
    final workshopDetailCustomWidgets = WorkshopDetailCustomWidgets(
        workshopDetail: _workshop,
        workshopSummary: workshopSummary,
        context: context,
        isPast: widget.isPast,
        is_interested: is_interested,
        scaffoldKey: _scaffoldKey,
        updateButton: updateButton,
        fetchWorkshopDetails: fetchWorkshopDetails,
        deleteWorkshop: deleteWorkshop,
        deleteResource: deleteResource);

    return SafeArea(
      minimum: const EdgeInsets.all(2.0),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: ColorConstants.backgroundThemeColor,
        body: SlidingUpPanel(
          body: workshopDetailCustomWidgets.getPanelBackground(),
          borderRadius: radius,
          backdropEnabled: true,
          parallaxEnabled: true,
          collapsed: Container(
            decoration: BoxDecoration(
              borderRadius: radius,
            ),
          ),
          minHeight: ClubAndCouncilWidgets.getMinPanelHeight(context),
          maxHeight: ClubAndCouncilWidgets.getMaxPanelHeight(context),
          header: workshopDetailCustomWidgets.getPanelHeader(context),
          panelBuilder: (ScrollController sc) => workshopDetailCustomWidgets.getPanel(sc: sc),
        ),
      ),
    );
  }
}
