import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/pages/clubs.dart';
import 'package:iit_app/pages/common_ui_widgets.dart';

class CouncilPage extends StatefulWidget {
  @override
  _CouncilPageState createState() => _CouncilPageState();
}

class _CouncilPageState extends State<CouncilPage> {
  BuiltCouncilPost councilData;
  @override
  void initState() {
    fetchCouncilById();
    super.initState();
  }

  void fetchCouncilById() async {
    print('fetching council data ');
    councilData = await AppConstants.getCouncilDetailsFromDatabase(
        councilId: AppConstants.currentCouncilId);

    if (!this.mounted) {
      return;
    }
    setState(() {});

    print('updating council data ');

    councilData = await AppConstants.getAndUpdateCouncilDetailsInDatabase(
        councilId: AppConstants.currentCouncilId);

    if (!this.mounted) {
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  final space = SizedBox(height: 8.0);
  Widget template({String imageUrl, String name, String desg}) {
    return Column(
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
        Container(
          child: Text(name, textAlign: TextAlign.center),
          width: 100,
        ),
        Text(desg, textAlign: TextAlign.center),
      ],
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
                          image: councilData.large_image_url == '' ||
                                  councilData.large_image_url == null
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
                                          councilData.joint_gensec.length > 0
                                              ? template(
                                                  imageUrl: councilData
                                                      .joint_gensec[0]
                                                      .photo_url,
                                                  desg: 'joint gensec',
                                                  name: councilData
                                                      .joint_gensec[0].name,
                                                )
                                              : SizedBox(width: 1),
                                          councilData.gensec == null
                                              ? SizedBox(width: 1)
                                              : template(
                                                  imageUrl: councilData
                                                      .gensec.photo_url,
                                                  desg: 'gensec',
                                                  name: councilData.gensec.name,
                                                ),
                                          councilData.joint_gensec.length > 1
                                              ? template(
                                                  imageUrl: councilData
                                                      .joint_gensec[1]
                                                      .photo_url,
                                                  desg: 'joint gensec',
                                                  name: councilData
                                                      .joint_gensec[1].name,
                                                )
                                              : SizedBox(width: 1),
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
                                    return CommonWidgets.getClubSummaryCard(
                                        context,
                                        club: councilData.clubs[index],
                                        councilName: councilData.name,
                                        editMode: false);
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
