import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/appConstants.dart';

class DetailPage extends StatefulWidget {
  final int workshopId;
  final bool editMode;
  const DetailPage({Key key, this.workshopId, this.editMode = false})
      : super(key: key);
  @override
  _DetailPage createState() => _DetailPage();
}

class _DetailPage extends State<DetailPage> {
  var _workshop;
  bool is_interested;
  @override
  void initState() {
    fetchWorkshopDetails();
    super.initState();
  }

  void fetchWorkshopDetails() async {
    Response<BuiltWorkshopDetailPost> snapshots = await AppConstants.service
        .getWorkshopDetailsPost(
            widget.workshopId, "token ${AppConstants.djangoToken}")
        .catchError((onError) {
      print("Error in fetching clubs: ${onError.toString()}");
    });
    _workshop = snapshots.body;
    is_interested = _workshop.is_interested;
    setState(() {});
  }

  void deleteWorkshop() async {
    print('METHOD TO DELETE GOES HERE');
    setState(() {});
  }

  void updateButton() async {
    await AppConstants.service
        .toggleInterestedWorkshop(
            widget.workshopId, "token ${AppConstants.djangoToken}")
        .then((snapshot) {
      print("status of toggle workshop: ${snapshot.statusCode}");
      if (snapshot.isSuccessful) is_interested = !is_interested;
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
          : Stack(children: [
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
                                widget.editMode
                                    ? IconButton(
                                        iconSize: 50,
                                        icon: Icon(Icons.delete_forever,
                                            color: Colors.red),
                                        onPressed: () => deleteWorkshop())
                                    : SizedBox(width: 0.1),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 90.0,
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
                                  InkWell(
                                    child: Icon(Icons.people,
                                        color: is_interested
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
                                        image:
                                            AppConstants.currentUser.photoUrl ==
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
                                      borderRadius: BorderRadius.circular(20.0),
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
                          ))
                    ],
                  ),
                ),
              )
            ]),
    );
  }
}
