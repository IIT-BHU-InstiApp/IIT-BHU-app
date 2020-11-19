import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/external_libraries/spin_kit.dart';
import 'package:iit_app/external_libraries/url_launcher.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:built_collection/built_collection.dart';
import 'package:iit_app/ui/drawer.dart';
import 'package:iit_app/ui/text_style.dart';

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
    Response<BuiltList<BuiltTeamMemberPost>> snapshots = await AppConstants.service.getTeam();
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
                backgroundImage:
                    imageUrl == null ? AssetImage('assets/AMC.png') : NetworkImage(imageUrl),
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

  final generalTextStyle = TextStyle(fontSize: 20.0, color: Colors.black);
  final divide = Divider(height: 8.0, thickness: 2.0, color: Colors.blueGrey);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(2.0),
      child: Scaffold(
        backgroundColor: Color(0xFF736AB7),
        drawer: SideBar(context: context),
        body: teamData == null
            ? Container(
                height: MediaQuery.of(context).size.height / 4,
                child: Center(
                  child: LoadingCircle,
                ),
              )
            : ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: teamData.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20), color: Colors.white70),
                    padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      //scrollDirection: Axis.vertical,
                      children: <Widget>[
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                padding: EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      teamData[index].role,
                                      style: Style.headingStyle.copyWith(color: Colors.black54),
                                    ),
                                    divide,
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: teamData[index].team_members.length,
                            itemBuilder: (context, index2) {
                              return ListTile(
                                leading: GestureDetector(
                                  onTap: () => openGithub(
                                      teamData[index].team_members[index2].github_username),
                                  child: Container(
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
                                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                        border: Border.all(color: Colors.blueGrey, width: 2.0)),
                                  ),
                                ),
                                title: Container(
                                  child: GestureDetector(
                                    onTap: () => openGithub(
                                        teamData[index].team_members[index2].github_username),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(color: Colors.blueGrey, width: 2.0),
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      color: Colors.blueGrey[200],
                                      child: Container(
                                        height: 50.0,
                                        child: Center(
                                          child: Text(teamData[index].team_members[index2].name,
                                              style:
                                                  TextStyle(color: Colors.black, fontSize: 15.0)),
                                        ),
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
      ),
    );
  }
}
