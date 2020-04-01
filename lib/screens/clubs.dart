import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';

class ClubPage extends StatefulWidget {
  final int clubId;
  const ClubPage({Key key, @required this.clubId}) : super(key: key);
  @override
  _ClubPageState createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> {
  TextStyle tempStyle = TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold);
  var clubData;

  @override
  void initState() {
    fetchClubDataById();
    super.initState();
  }

  void fetchClubDataById() async {
    // print('AppConstants.djangoToken : ${AppConstants.djangoToken}');
    Response<BuiltClubPost> snapshots = await AppConstants.service
        .getClub(widget.clubId, "token ${AppConstants.djangoToken}")
        .catchError((onError) {
      print("Error in fetching clubs: ${onError.toString()}");
    });
    print(snapshots.body);
    clubData = snapshots.body;
    setState(() {});
  }

// ?----------------------------------------------------------------------

//TODO: use all the fields of clubMap in the UI..........
//TODO: use all the fields of clubMap in the UI..........

  Map<String, dynamic> clubMap = {
    "id": 1,
    "name": "Club of Programmers",
    "description": "Dev Extravaganzaa",
    "council": {
      "id": 1,
      "name": "Science and Technology Council",
      "small_image_url": null,
      "large_image_url": null
    },
    "secy": {
      "id": 1,
      "name": "Nishant Kumar",
      "email": "nishantkr.ece18@itbhu.ac.in",
      "phone_number": null,
      "photo_url": null
    },
    "joint_secy": [
      {
        "id": 1,
        "name": "Nishant Kumar",
        "email": "nishantkr.ece18@itbhu.ac.in",
        "phone_number": null,
        "photo_url": null
      }
    ],
    "active_workshops": [
      {
        "id": 7,
        "club": {
          "id": 1,
          "name": "Club of Programmers",
          "council": 1,
          "small_image_url": null,
          "large_image_url": null
        },
        "title": "Hey",
        "date": "2020-07-02",
        "time": "17:34:20"
      },
      {
        "id": 8,
        "club": {
          "id": 1,
          "name": "Club of Programmers",
          "council": 1,
          "small_image_url": null,
          "large_image_url": null
        },
        "title": "Test2",
        "date": "2020-07-02",
        "time": "17:42:55"
      },
      {
        "id": 5,
        "club": {
          "id": 1,
          "name": "Club of Programmers",
          "council": 1,
          "small_image_url": null,
          "large_image_url": null
        },
        "title": "TEST1",
        "date": "2020-07-09",
        "time": "13:50:00"
      },
      {
        "id": 4,
        "club": {
          "id": 1,
          "name": "Club of Programmers",
          "council": 1,
          "small_image_url": null,
          "large_image_url": null
        },
        "title": "Dev Extravaganza",
        "date": "2021-12-28",
        "time": "09:23:05"
      }
    ],
    "past_workshops": [],
    "small_image_url": null,
    "large_image_url": null,
    "is_subscribed": true,
    "subscribed_users": 1
  };
//TODO: use all the fields of clubMap in the UI..........
//TODO: use all the fields of clubMap in the UI..........

// ?----------------------------------------------------------------------
  final divide = Divider(height: 8.0, thickness: 2.0, color: Colors.blue);
  final space = SizedBox(height: 8.0);
  final headingStyle = TextStyle(
      fontSize: 30.0,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.0);
  Widget template({String imageUrl, String name, String desg}) {
    return Container(
      child: Wrap(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              space,
              Center(
                  child: CircleAvatar(
                backgroundImage: imageUrl == null
                    ? AssetImage('assets/AMC.png')
                    : NetworkImage(imageUrl),
                radius: 30.0,
                backgroundColor: Colors.transparent,
              )),
              ListTile(
                title: Text(
                  name,
                  textAlign: TextAlign.center,
                ),
                subtitle: Text(
                  desg,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        scrollDirection: Axis.vertical,
        children: [
          Stack(children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Image(
                  image: AssetImage('assets/fmc.jpeg'),
                  fit: BoxFit.cover,
                ),
                elevation: 2.5,
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.all(15.0),
                child: FloatingActionButton(
                  elevation: 3.0,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  onPressed: () {},
                  child: Icon(Icons.description),
                  /*child: Image(
                    image: AssetImage('assets/iitbhu.jpeg'),
                  ),*/
                ),
              ),
            ),
          ]),
          space,
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  clubMap['name'],
                  style: headingStyle,
                ),
                IconButton(
                    color: Colors.red,
                    iconSize: 30.0,
                    icon: Icon(Icons.subscriptions),
                    onPressed: null)
              ],
            ),
          ),
          Container(
            color: Colors.grey[300],
            child: Center(
              child: template(name: 'Ayush Kumar', desg: 'Secy'),
            ),
          ),
          // Container(
          //   color: Colors.grey[300],
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       template(name: 'Ayush Kumar', desg: 'JointSecy'),
          //       template(name: 'Ayush Kumar', desg: 'JointSecy')
          //     ],
          //   ),
          // ),
          Center(
            child: Text(
              'Description',
              style: headingStyle,
            ),
          ),
          divide,
          Text('${clubMap['description']}',
              style: TextStyle(fontSize: 20, color: Colors.black)),
          space,
          Center(
            child: Text(
              'Active Workshops',
              style: headingStyle,
            ),
          ),
        ],
      ),
    );
  }
}
