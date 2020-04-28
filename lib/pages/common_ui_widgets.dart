import 'package:flutter/material.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/pages/clubs.dart';
import 'package:iit_app/screens/home/text_style.dart';

class CommonWidgets {
  static final Color textPaleColor = Color(0xFFAFAFAF);
  static final Color textColor = Color(0xFF004681);

  static Widget getOnlyClubnameCard(BuildContext context,
      {ClubListPost club, bool editMode, String type, bool horizontal = true}) {
    final workshopThumbnail = new Container(
      // margin: new EdgeInsets.symmetric(vertical: 16.0),
      alignment:
          horizontal ? FractionalOffset.centerLeft : FractionalOffset.center,
      child: Hero(
        tag: "club-hero-${club.id}-$type",
        child: Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image(
              fit: BoxFit.contain,
              image: club.small_image_url == null
                  ? AssetImage('assets/iitbhu.jpeg')
                  : NetworkImage(club.small_image_url),
            ),
          ),
          height: 50.0,
          width: 50.0,
        ),
      ),
    );

    final workshopCardContent = new Container(
      margin: new EdgeInsets.fromLTRB(40.0, 0.0, 10.0, 0.0),
      constraints: new BoxConstraints.expand(),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:
            horizontal ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: <Widget>[
          new Text(club.name, style: Style.titleTextStyle),
        ],
      ),
    );

    final workshopCard = new Container(
      child: workshopCardContent,
      height: horizontal ? 50.0 : 154.0,
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

    return new GestureDetector(
        onTap: horizontal
            ? () => Navigator.of(context).push(
                  new PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>
                        new ClubPage(clubId: club.id, editMode: editMode),
                    transitionsBuilder: (context, animation, secondaryAnimation,
                            child) =>
                        new FadeTransition(opacity: animation, child: child),
                  ),
                )
            : null,
        child: new Container(
          margin: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 15.0,
          ),
          child: new Stack(
            children: <Widget>[
              workshopCard,
              workshopThumbnail,
            ],
          ),
        ));
  }

  static Widget getClubSummaryCard(BuildContext context,
      {ClubListPost club,
      String councilName,
      bool editMode,
      bool horizontal = true}) {
    final workshopThumbnail = new Container(
      margin: new EdgeInsets.symmetric(vertical: 16.0),
      alignment:
          horizontal ? FractionalOffset.centerLeft : FractionalOffset.center,
      child: new Hero(
        tag: "club-hero-${club.id}",
        child: Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image(
              fit: BoxFit.contain,
              image: club.small_image_url == null
                  ? AssetImage('assets/iitbhu.jpeg')
                  : NetworkImage(club.small_image_url),
            ),
          ),
          height: 50.0,
          width: 50.0,
        ),
      ),
    );

    final workshopCardContent = new Container(
      margin: new EdgeInsets.fromLTRB(
          horizontal ? 40.0 : 10.0, horizontal ? 16.0 : 42.0, 10.0, 10.0),
      constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment:
            horizontal ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: <Widget>[
          new Text(club.name, style: Style.titleTextStyle),
          new Container(height: 4.0),
          new Text('$councilName', style: Style.commonTextStyle),
        ],
      ),
    );

    final workshopCard = new Container(
      child: workshopCardContent,
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

    return new GestureDetector(
        onTap: horizontal
            ? () => Navigator.of(context).push(
                  new PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>
                        new ClubPage(clubId: club.id, editMode: editMode),
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
              workshopCard,
              workshopThumbnail,
            ],
          ),
        ));
  }
}
