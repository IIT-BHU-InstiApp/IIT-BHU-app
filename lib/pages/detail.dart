import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/data/workshop.dart';
import 'package:iit_app/pages/login.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/appConstants.dart';

class DetailPage extends StatefulWidget {
  final int workshopId;

  const DetailPage({Key key, this.workshopId}) : super(key: key);
  @override
  _DetailPage createState() => _DetailPage();
}

class _DetailPage extends State<DetailPage> {
  // var _workshop;

  @override
  void initState() {
    // fetchWorkshopDetails();
    super.initState();
  }

  // void fetchWorkshopDetails() async {
  //   Response<BuiltWorkshopDetailPost> snapshots = await AppConstants.service
  //       .getWorkshopDetailsPost(
  //           widget.workshopId, "token ${AppConstants.djangoToken}")
  //       .catchError((onError) {
  //     print("Error in fetching clubs: ${onError.toString()}");
  //   });
  //   // print(snapshots.body);
  //   this._workshop = snapshots.body;
  //   setState(() {});
  // }

  dynamic _workshop = {
    'id': 7,
    'title': 'workshop2',
    'description': 'matlab kuch bhi',
    'club': {
      'id': 1,
      'name': 'Club of Programmers',
      'council': 1,
      'small_image_url': 'assets/iitbhu.jpeg',
      'large_image_url': 'assets/iitbhu.jpeg',
    },
    'date': '04-04-2020',
    'time': '04:24',
    'location': 'mujhe kya pata',
    'audience': 'kash aa jaye',
    'resources': 'nishant [konse? (: ] se puch',
    'contacts': [
      {
        'id': 420,
        'name': 'corona',
        'email': 'punisher@climate.21din',
        'phone_number': 'yamraj ka no',
        'photo_url': 'assets/iitbhu.jpeg',
      },
      {
        'id': 786,
        'name': 'india',
        'email': 'rakshak@climate.21din',
        'phone_number': 'jrurat ni',
        'photo_url': 'assets/iitbhu.jpeg',
      },
    ],
    'image_url': 'assets/iitbhu.jpeg',
    'is_attendee': 'true',
    'attendees': 'sab kuch m batau kya',
  };

// TODO: use all the fields of _workshop............
// TODO: use all the fields of _workshop............
// ? if you  use vs code, install 'better comments' extension.
// !--------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
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
                  image: this._workshop.club.large_image_url == null
                      ? AssetImage('assets/iitbhu.jpeg')
                      : NetworkImage(this._workshop.club.large_image_url),
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
                                this._workshop.date,
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
                                this._workshop.time,
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
                          Container(
                            width: MediaQuery.of(context).size.width - 90.0,
                            child: Text(this._workshop.title,
                                style: TextStyle(
                                    fontFamily: 'Opensans',
                                    fontSize: 27.0,
                                    fontWeight: FontWeight.w600)),
                          )
                        ],
                      ),
                      // Container(
                      //   height: 80.0,
                      //   width: 50.0,
                      //   decoration: BoxDecoration(
                      //       color: Colors.grey.withOpacity(0.2),
                      //       borderRadius: BorderRadius.circular(25.0)),
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: <Widget>[
                      //       SizedBox(height: 7.0),
                      //       Text(workshop.goingGlobal.toString()),
                      //       InkWell(
                      //         child: Icon(Icons.people,
                      //             color: going ? Colors.blue : Colors.black,
                      //             size: 25.0),
                      //         onTap: () => setState(() => going = !going),
                      //       ),
                      //       SizedBox(height: 7.0)
                      //     ],
                      //   ),
                      // )
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
                                  image: googleSignIn.currentUser == null
                                      ? AssetImage('assets/profile_test.jpg')
                                      : NetworkImage(photoUrl),
                                  fit: BoxFit.cover)),
                        ),
                        // Positioned(
                        //   left: 30.0,
                        //   child: Container(
                        //     height: 40.0,
                        //     width: 40.0,
                        //     decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(20.0),
                        //         color: Color(0xFFFE7050)),
                        //     child: Center(
                        //       child: Text('+${workshop.goingGlobal}',
                        //           style: TextStyle(
                        //               fontSize: 14.0, color: Colors.white)),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ],
                ),
              ),
              // Padding(
              //     padding: EdgeInsets.only(top: 15.0, left: 15.0),
              //     child: Container(
              //       width: 250.0,
              //       child: Text(workshop.description,
              //           style: TextStyle(
              //               color: Color(0xFF6A6A6A),
              //               fontFamily: 'Opensans',
              //               fontWeight: FontWeight.w300)),
              //     ))
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
                    height: 40.0,
                    width: 60.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.black.withOpacity(0.2)),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.star, color: Colors.white, size: 12.0),
                          SizedBox(width: 5.0),
                          Text(
                            Workshop.councils[this._workshop.club.council],
                            style: TextStyle(color: Colors.white),
                          )
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
