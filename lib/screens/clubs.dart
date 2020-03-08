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
    Response<BuiltClubPost> snapshots =
        await AppConstants.service.getClub(widget.clubId);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: ListView(
        children: <Widget>[
          SizedBox(height: 50.0),
          Text('COPS', textAlign: TextAlign.center, style: tempStyle),
          SizedBox(height: 25.0),
          Text('Description', textAlign: TextAlign.center, style: tempStyle),
          SizedBox(height: 25.0),
          Text(
            'Workshops',
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
