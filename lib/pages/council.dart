import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/pages/clubs.dart';

class CouncilPage extends StatefulWidget {
  @override
  _CouncilPageState createState() => _CouncilPageState();
}

class _CouncilPageState extends State<CouncilPage> {
  var councilData;
  @override
  void initState() {
    fetchCouncilById();
    super.initState();
  }

  void fetchCouncilById() async {
    Response<BuiltCouncilPost> snapshots =
        await AppConstants.service.getCouncil(AppConstants.currentCouncilId);
    // print(snapshots.body);
    councilData = snapshots.body;
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
                    ? AssetImage('assets/iitbhu.jpeg')
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
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.grey[300],
              floating: true,
              expandedHeight: MediaQuery.of(context).size.height / 4,
              flexibleSpace: FlexibleSpaceBar(
                //title: Text('SnTC'),
                background: councilData == null
                    ? Container(
                        height: MediaQuery.of(context).size.height / 4,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Image(
                          image: councilData.large_image_url == null
                              ? AssetImage('assets/iitbhu.jpeg')
                              : NetworkImage(councilData.large_image_url),
                          // AssetImage('assets/fmc.jpeg'),
                          fit: BoxFit.cover,
                        ),
                        elevation: 2.5,
                      ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      //scrollDirection: Axis.vertical,
                      children: <Widget>[
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'Description',
                                      style: headingStyle,
                                    ),
                                    divide,
                                    councilData == null
                                        ? Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : Text(councilData.description,
                                            style: generalTextStyle),
                                    space,
                                  ],
                                ),
                              ),
                              councilData == null
                                  ? Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              4,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : Container(
                                      color: Colors.grey[300],
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          // template(
                                          //   imageUrl:
                                          //       councilData.joint_gensec[0].photo_url,
                                          //   desg: 'joint gensec',
                                          //   name: councilData.joint_gensec[0].name,
                                          // ),

                                          template(
                                            imageUrl:
                                                councilData.gensec.photo_url,
                                            desg: 'gensec',
                                            name: councilData.gensec.name,
                                          ),

                                          // template(
                                          //   imageUrl:
                                          //       councilData.joint_gensec[1].photo_url,
                                          //   desg: 'joint gensec',
                                          //   name: councilData.joint_gensec[1].name,
                                          // ),
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
                        councilData == null
                            ? Container(
                                height: MediaQuery.of(context).size.height / 4,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : Container(
                                color: Colors.white,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: councilData.clubs.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => ClubPage(
                                              clubId:
                                                  councilData.clubs[index].id,
                                            ),
                                          ),
                                        );
                                      },
                                      leading: Container(
                                        height: 50.0,
                                        width: 50.0,
                                        decoration: BoxDecoration(
                                            //color: Colors.black,
                                            image: DecorationImage(
                                              image: councilData.clubs[index]
                                                          .small_image_url ==
                                                      null
                                                  ? AssetImage('assets/AMC.png')
                                                  : NetworkImage(councilData
                                                      .clubs[index]
                                                      .small_image_url),
                                              fit: BoxFit.fill,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30.0)),
                                            border: Border.all(
                                                color: Colors.blue,
                                                width: 2.0)),
                                      ),
                                      title: Container(
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Colors.blue, width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          color: Colors.black,
                                          child: Container(
                                            height: 50.0,
                                            child: Center(
                                              child: Text(
                                                  councilData.clubs[index].name,
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
