import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/ui/separator.dart';
import 'package:iit_app/ui/text_style.dart';

import 'clubs.dart';

class ClubAndCouncilWidgets {
  static Container getSecies(BuildContext context, {secy, joint_secy}) {
    return Container(
      color: Colors.grey[300],
      child: Column(
        children: [
          Center(child: Text('Secys:', style: Style.headingStyle)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              joint_secy.length > 0
                  ? ClubAndCouncilWidgets.getPosHolder(
                      context: context,
                      imageUrl: joint_secy[0].photo_url,
                      desg: 'Joint-Secy',
                      name: joint_secy[0].name,
                      email: joint_secy[0].email,
                    )
                  : SizedBox(width: 1),
              secy == null
                  ? SizedBox(width: 1)
                  : ClubAndCouncilWidgets.getPosHolder(
                      context: context,
                      imageUrl: secy.photo_url,
                      desg: 'Secy',
                      name: secy.name,
                      email: secy.email,
                    ),
              joint_secy.length > 1
                  ? ClubAndCouncilWidgets.getPosHolder(
                      context: context,
                      imageUrl: joint_secy[1].photo_url,
                      desg: 'Joint Secy',
                      name: joint_secy[1].name,
                      email: joint_secy[1].email,
                    )
                  : SizedBox(width: 1),
            ],
          ),
        ],
      ),
    );
  }

  static Container getToolbar(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: new BackButton(color: Colors.lightGreen),
    );
  }

  static Container getGradient() {
    return Container(
      margin: new EdgeInsets.only(top: 190.0),
      height: 110.0,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: <Color>[new Color(0x00736AB7), new Color(0xFF736AB7)],
          stops: [0.0, 0.9],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 1.0),
        ),
      ),
    );
  }

  static Widget getPosHolder(
      {String desg,
      BuildContext context,
      String name,
      String imageUrl,
      String email,
      String phone}) {
    return GestureDetector(
      onTap: () {
        detailsDialog(
          context: context,
          name: name,
          imageUrl: imageUrl,
          email: email,
        );
      },
      child: Column(
        children: <Widget>[
          SizedBox(height: 4.0),
          Center(
            child: CircleAvatar(
              backgroundImage: imageUrl == null
                  ? AssetImage('assets/iitbhu.jpeg')
                  : NetworkImage(imageUrl),
              radius: 30.0,
              backgroundColor: Colors.transparent,
            ),
          ),
          Container(
            child: Text(name, textAlign: TextAlign.center),
            width: 100,
          ),
          Text(desg, textAlign: TextAlign.center),
          SizedBox(height: 4.0),
        ],
      ),
    );
  }

  static Widget getClubCard(
      {BuildContext context,
      String title,
      String subtitle,
      int id,
      String imageUrl,
      bool isCouncil,
      horizontal = false,
      ClubListPost club,
      String clubTypeForHero = 'default'}) {
    final File clubLogoFile =
        AppConstants.getImageFile(isSmall: true, id: id, isClub: true);

    if (clubLogoFile == null) {
      AppConstants.writeImageFileIntoDisk(
          isClub: true, isSmall: true, id: id, url: imageUrl);
    }
    final File _largeLogofile = AppConstants.getImageFile(
        isCouncil: isCouncil, isClub: !isCouncil, isSmall: false, id: id);

    final clubThumbnail = Container(
      margin: new EdgeInsets.symmetric(vertical: 16.0),
      alignment:
          horizontal ? FractionalOffset.centerLeft : FractionalOffset.center,
      child: Hero(
        tag: "club-hero-$id-$clubTypeForHero",
        child: Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image(
              fit: BoxFit.contain,
              image: imageUrl == null
                  ? AssetImage('assets/iitbhu.jpeg')
                  : _largeLogofile == null
                      ? NetworkImage(imageUrl)
                      : FileImage(_largeLogofile),
            ),
          ),
          height: horizontal ? 50 : 82,
          width: horizontal ? 50 : 82,
        ),
      ),
    );

    final councilThumbnail = Container(
      margin: new EdgeInsets.symmetric(vertical: 16.0),
      alignment: FractionalOffset.center,
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image(
            fit: BoxFit.contain,
            image: imageUrl == null
                ? AssetImage('assets/iitbhu.jpeg')
                : _largeLogofile == null
                    ? NetworkImage(imageUrl)
                    : FileImage(_largeLogofile),
          ),
        ),
        height: 92.0,
        width: 92.0,
      ),
    );

    final clubCardContent = Container(
      margin: new EdgeInsets.only(left: horizontal ? 40.0 : 10.0, right: 10.0),
      constraints: new BoxConstraints.expand(),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:
            horizontal ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: <Widget>[
          horizontal ? Container() : SizedBox(height: 4.0),
          Text(title, style: Style.titleTextStyle),
          Container(height: horizontal ? 4 : 10),
          subtitle == null
              ? Container()
              : Text(subtitle, style: Style.commonTextStyle),
          horizontal ? Container() : Separator(),
        ],
      ),
    );

    final clubCard = Container(
      child: clubCardContent,
      height: horizontal ? 75.0 : 154.0,
      margin: horizontal
          ? new EdgeInsets.only(left: 30.0)
          : new EdgeInsets.only(top: 72.0),
      decoration: new BoxDecoration(
        color: new Color(0xFF333366),
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),
    );

    return GestureDetector(
        onTap: horizontal
            ? () => Navigator.of(context).push(
                  new PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>
                        new ClubPage(club: club, editMode: true),
                    transitionsBuilder: (context, animation, secondaryAnimation,
                            child) =>
                        new FadeTransition(opacity: animation, child: child),
                  ),
                )
            : null,
        child: new Container(
          margin: const EdgeInsets.symmetric(
            vertical: 1.0,
            horizontal: 15.0,
          ),
          child: new Stack(
            children: <Widget>[
              clubCard,
              isCouncil == true ? councilThumbnail : clubThumbnail,
            ],
          ),
        ));
  }

  static Future detailsDialog(
          {BuildContext context,
          String name,
          String imageUrl,
          String email,
          String phone}) =>
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          final dialogColor = Color(0xFFAFAFAF);
          Container details = Container(
            child: Stack(
              children: [
                Container(
                  constraints: new BoxConstraints.expand(),
                  margin: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
                  padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
                  decoration: new BoxDecoration(
                    color: Color(0xFF004681),
                    shape: BoxShape.rectangle,
                    borderRadius: new BorderRadius.circular(8.0),
                    boxShadow: <BoxShadow>[
                      new BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.0,
                        offset: new Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child: ListView(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      ListTile(
                        leading: Icon(
                          Icons.email,
                          color: dialogColor,
                        ),
                        title: Text(
                          email,
                          style: TextStyle(
                            color: dialogColor,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.phone,
                          color: dialogColor,
                        ),
                        title: Text(
                          //phone,
                          'No Phone',
                          style: TextStyle(
                            color: dialogColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  /*decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20.0,
                        offset: new Offset(0.0, -10.0),
                      ),
                    ],
                  ),*/
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 35.0,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                ),
              ],
            ),
          );
          Container outerBox = Container(
            child: details,
            height: 270.0,
            color: Colors.transparent,
            margin: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
          );

          return Dialog(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: outerBox,
          );
        },
      );
}
