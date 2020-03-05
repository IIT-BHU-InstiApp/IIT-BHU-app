import 'package:flutter/material.dart';

class ClubScreen extends StatefulWidget {
  @override
  _ClubScreenState createState() => _ClubScreenState();
}

class _ClubScreenState extends State<ClubScreen> {
  TextStyle tempStyle=TextStyle(fontSize:50.0,fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: ListView(
        children: <Widget>[
          SizedBox(height:50.0),
          Text(
            'COPS',
            textAlign: TextAlign.center,
            style:tempStyle
          ),
          SizedBox(height:25.0),
          Text(
            'Description',
            textAlign: TextAlign.center,
            style:tempStyle
          ),
          SizedBox(height:25.0),
          Text(
            'Workshops',
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
