import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/pages/clubs.dart';
import 'package:iit_app/pages/create.dart';

class DetailPage extends StatefulWidget {
  final int workshopId;
  final bool editMode;
  const DetailPage({Key key, this.workshopId, this.editMode = false})
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
                            clubId: _workshop.club.id, editMode: true)));
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
            widget.workshopId, "token ${AppConstants.djangoToken}")
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
                widget.workshopId, "token ${AppConstants.djangoToken}")
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
            widget.workshopId, "token ${AppConstants.djangoToken}")
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _workshop == null
          ? Container(
              height: MediaQuery.of(context).size.height / 4,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height - 75.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(35.0),
                          bottomRight: Radius.circular(35.0)),
                      color: Colors.white),
                ),
                Container(
                  height: MediaQuery.of(context).size.height - 310.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(35.0),
                          bottomRight: Radius.circular(35.0)),
                      image: DecorationImage(
                          image: _workshop.club.large_image_url == null
                              ? AssetImage('assets/iitbhu.jpeg')
                              : NetworkImage(_workshop.club.large_image_url),
                          fit: BoxFit.cover)),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height - 300.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width - 35.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.date_range,
                                          size: 12.0, color: Colors.grey),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        _workshop.date,
                                        style: TextStyle(
                                            fontFamily: 'Opensans',
                                            fontSize: 12.0,
                                            color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 2.5,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.timelapse,
                                          size: 12.0, color: Colors.grey),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        _workshop.time != null
                                            ? _workshop.time
                                            : "none",
                                        style: TextStyle(
                                            fontFamily: 'Opensans',
                                            fontSize: 12.0,
                                            color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 7.0,
                                  ),
                                  // widget.editMode
                                  //     ? IconButton(
                                  //         iconSize: 50,
                                  //         icon: Icon(Icons.delete_forever,
                                  //             color: Colors.red),
                                  //         onPressed: () => deleteWorkshop())
                                  //     : SizedBox(width: 0.1),
                                  Container(
                                    width: MediaQuery.of(context).size.width -
                                        90.0,
                                    child: Text(_workshop.title,
                                        style: TextStyle(
                                            fontFamily: 'Opensans',
                                            fontSize: 27.0,
                                            fontWeight: FontWeight.w600)),
                                  )
                                ],
                              ),
                              Container(
                                height: 80.0,
                                width: 50.0,
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(25.0)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    SizedBox(height: 7.0),
                                    Text(_workshop.interested_users.toString()),
                                    is_interested == 0
                                        ? Container(
                                            child: CircularProgressIndicator(),
                                            height: 20,
                                            width: 20)
                                        : InkWell(
                                            child: Icon(Icons.people,
                                                color: is_interested == 1
                                                    ? Colors.blue
                                                    : Colors.black,
                                                size: 25.0),
                                            onTap: () => updateButton(),
                                          ),
                                    SizedBox(height: 7.0)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                        child: Row(
                          children: <Widget>[
                            Text('People Going:',
                                style: TextStyle(
                                    fontFamily: 'Opensans',
                                    fontSize: 15.0,
                                    color: Color(0xFF6A6A6A),
                                    fontWeight: FontWeight.w600)),
                            SizedBox(width: 25.0),
                            Stack(
                              children: <Widget>[
                                Container(height: 40.0, width: 100.0),
                                Container(
                                  height: 40.0,
                                  width: 40.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      image: DecorationImage(
                                          image: AppConstants
                                                      .currentUser.photoUrl ==
                                                  null
                                              ? AssetImage(
                                                  'assets/profile_test.jpg')
                                              : NetworkImage(AppConstants
                                                  .currentUser.photoUrl),
                                          fit: BoxFit.cover)),
                                ),
                                Positioned(
                                  left: 30.0,
                                  child: Container(
                                    height: 40.0,
                                    width: 40.0,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        color: Color(0xFFFE7050)),
                                    child: Center(
                                      child: Text(
                                          '+${_workshop.interested_users}',
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.white)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 15.0, left: 15.0),
                          child: Container(
                            width: 250.0,
                            child: Text(_workshop.description,
                                style: TextStyle(
                                    color: Color(0xFF6A6A6A),
                                    fontFamily: 'Opensans',
                                    fontWeight: FontWeight.w300)),
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40.0, left: 15.0, right: 15.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 15.0,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios,
                              color: Colors.lightGreen, size: 15.0),
                          onPressed: () => Navigator.pop(context),
                        ),
                        SizedBox(width: 20.0),
                        Container(
                          height: 35.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.black.withOpacity(0.2)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 5.0),
                                Icon(Icons.star,
                                    color: Colors.white, size: 12.0),
                                SizedBox(width: 5.0),
                                Text(
                                  'Council Name',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(width: 5.0),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                widget.editMode == false
                    ? Container()
                    : Positioned(
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
                                      color: Colors.yellow,
                                      fontWeight: FontWeight.bold),
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
                                          clubId: _workshop.club.id,
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
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                    iconSize: 50,
                                    icon: Icon(Icons.delete_forever,
                                        color: Colors.red),
                                    onPressed: () => deleteWorkshop()),
                              ],
                            )
                          ],
                        ),
                      ),
              ],
            ),
    );
  }
}
