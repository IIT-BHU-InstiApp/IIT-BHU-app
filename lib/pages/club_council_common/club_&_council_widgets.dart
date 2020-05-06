import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/ui/separator.dart';
import 'package:iit_app/ui/text_style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../club/club.dart';
import 'package:url_launcher/url_launcher.dart';

class ClubAndCouncilWidgets {
  static double getMinPanelHeight(context) {
    return MediaQuery.of(context).size.height / 10;
  }

  static double getMaxPanelHeight(context) {
    return MediaQuery.of(context).size.height / 1.1;
  }

  static Container getSocialLinks(map) {
    _launchURL(String url) {
      print('URL: ${url}');
      launch(url);
    }

    Column _buildButtonColumn(IconData icon, String label, String url,
        {Color color = Colors.white}) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              icon: Icon(icon, color: color), onPressed: () => _launchURL(url)),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      height: 100,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: Color(0xFF736AB7),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          map.youtube_url == null || map.youtube_url.length == 0
              ? Container()
              : _buildButtonColumn(
                  FontAwesomeIcons.youtube, 'YouTube', map.youtube_url),
          map.website_url == null || map.website_url.length == 0
              ? Container()
              : _buildButtonColumn(Icons.web, 'Website', map.website_url),
          map.linkedin_url == null || map.linkedin_url.length == 0
              ? Container()
              : _buildButtonColumn(
                  FontAwesomeIcons.linkedin, 'LinkedIn', map.linkedin_url),
          map.instagram_url == null || map.instagram_url.length == 0
              ? Container()
              : _buildButtonColumn(
                  FontAwesomeIcons.instagram, 'Instagram', map.instagram_url),
          map.facebook_url == null || map.facebook_url.length == 0
              ? Container()
              : _buildButtonColumn(
                  FontAwesomeIcons.facebook, 'Facebook', map.facebook_url),
          map.twitter_url == null || map.twitter_url.length == 0
              ? Container()
              : _buildButtonColumn(
                  FontAwesomeIcons.twitter, 'Twitter', map.twitter_url),
        ],
      ),
    );
  }

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
          Container(
            color: Colors.grey[300],
            height: 25.0,
          )
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
      {String desg='',
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
          desg == ''
              ? SizedBox(height: 1.0)
              : Text(desg, textAlign: TextAlign.center),
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

  static Column getHeader(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xff00c6ff),
            borderRadius: BorderRadius.circular(2.0),
          ),
          margin: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width / 2 - 12.0, 10.0, 0.0, 0.0),
          height: 4.0,
          width: 24.0,
          //color: new Color(0xff00c6ff)
        ),
      ],
    );
  }
}
