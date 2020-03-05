import 'package:flutter/material.dart';

class CouncilPage extends StatelessWidget {
  final dynamic council;
  final String descriptionText =
      'Loremquis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ';
  CouncilPage(this.council);
  Widget clubTemplate({String clubName, String image}) {
    return ListTile(
      leading: Container(
        height: 50.0,
        width: 50.0,
        decoration: BoxDecoration(
            //color: Colors.black,
            image: DecorationImage(
              image: AssetImage('assets/fmc.jpeg'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            border: Border.all(color: Colors.blue, width: 2.0)),
      ),
      title: Container(
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.black,
          child: Container(
              height: 50.0,
              child: Center(
                child: Text(clubName,
                    style: TextStyle(color: Colors.white, fontSize: 25.0)),
              )),
        ),
      ),
    );
  }

  final space = SizedBox(height: 8.0);
  Widget template({String imageVal, String name, String desg}) {
    return Expanded(
      child: Container(
          child: Wrap(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              space,
              Center(
                  child: CircleAvatar(
                backgroundImage: AssetImage('assets/fmc.jpeg'),
                radius: 50.0,
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
      )),
    );
  }

  final headingStyle = TextStyle(
      fontSize: 30.0,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.0);
  final generalTextStyle = TextStyle(fontSize: 20.0, color: Colors.black);
  final divide = Divider(height: 8.0, thickness: 2.0, color: Colors.blue);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              //scrollDirection: Axis.vertical,
              children: <Widget>[
                Card(
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
                space,
                Container(
                  color: Colors.white,
                  //margin: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'council.description',
                              style: headingStyle,
                            ),
                            divide,
                            Text(descriptionText, style: generalTextStyle),
                            space,
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.grey[300],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            template(desg: 'GenSec', name: 'Ayush Kumar'),
                            template(desg: 'GenSec', name: 'Ayush Kumar'),
                            template(desg: 'GenSec', name: 'Ayush Kumar'),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Clubs',
                              style: headingStyle,
                              textAlign: TextAlign.left,
                            ),
                            divide,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      // clubTemplate(clubName: this.club),
                      clubTemplate(clubName: 'Creative Design Club'),
                      clubTemplate(clubName: 'Creative Design Club'),
                      clubTemplate(clubName: 'Creative Design Club'),
                      clubTemplate(clubName: 'Creative Design Club'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
