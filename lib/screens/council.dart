import 'package:flutter/material.dart';
import 'package:iit_app/data/workshop.dart';

class CouncilScreen extends StatelessWidget {
  final String descriptionText;
  final councilName;
  final List<String> secyNames,designation,clubNames;
  CouncilScreen({this.descriptionText,this.clubNames,this.secyNames,this.designation,this.councilName});
  /*final List<String> clubs = [
    'Design',
    'Design',
    'Design',
    'Design',
    'Design',
    'Design',
  ];*/
 

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

  final String description = 'Description';
  //final String descriptionText =
      //'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ';
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
                              description,
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
                            template(desg: designation[0], name: secyNames[0],),
                            template(desg: designation[1], name: secyNames[1],),
                            template(desg: designation[2], name: secyNames[2]),
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
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: clubNames.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, '/club');
                        },
                        leading: Container(
                          height: 50.0,
                          width: 50.0,
                          decoration: BoxDecoration(
                              //color: Colors.black,
                              image: DecorationImage(
                                image: AssetImage('assets/fmc.jpeg'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                              border:
                                  Border.all(color: Colors.blue, width: 2.0)),
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
                                child: Text('${clubNames[index]}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25.0)),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
