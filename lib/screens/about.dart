import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:built_collection/built_collection.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  var teamData;
  @override
  void initState() {
    fetchTeamDetails();
    super.initState();
  }

  void fetchTeamDetails() async {
    Response<BuiltList<BuiltTeamMemberPost>> snapshots =
        await AppConstants.service.getTeam();
    // print(snapshots.body);
    teamData = snapshots.body;
    setState(() {});
  }

  final space = SizedBox(height: 8.0);
  Widget template({String imageUrl, String name, String desg}) {
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
      backgroundColor: Color(0xFF736AB7),
      body: teamData == null
          ? Container(
              height: MediaQuery.of(context).size.height / 4,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              itemCount: teamData.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    //scrollDirection: Axis.vertical,
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        //margin: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              color: Colors.white,
                              padding: EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    teamData[index].role,
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
                          itemCount: teamData[index].team_members.length,
                          itemBuilder: (context, index2) {
                            return ListTile(
                              leading: Container(
                                height: 50.0,
                                width: 50.0,
                                decoration: BoxDecoration(
                                    //color: Colors.black,
                                    image: DecorationImage(
                                      image: teamData[index]
                                                  .team_members[index2]
                                                  .github_image_url ==
                                              null
                                          ? AssetImage('assets/AMC.png')
                                          : NetworkImage(teamData[index]
                                              .team_members[index2]
                                              .github_image_url),
                                      fit: BoxFit.fill,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30.0)),
                                    border: Border.all(
                                        color: Colors.blue, width: 2.0)),
                              ),
                              title: Container(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.blue, width: 2.0),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  color: Colors.black,
                                  child: Container(
                                    height: 50.0,
                                    child: Center(
                                      child: Text(
                                          teamData[index]
                                              .team_members[index2]
                                              .github_username,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25.0)),
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
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        child: Container(
          color: Colors.grey[300],
          height: 50.0,
          child: Center(
            child: Text(
              'Made with ❤️ by COPS',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
