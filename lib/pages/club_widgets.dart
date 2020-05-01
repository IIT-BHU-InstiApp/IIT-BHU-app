import 'package:flutter/material.dart';
import 'package:iit_app/pages/clubs.dart';
import 'package:iit_app/screens/home/separator.dart';
import 'package:iit_app/screens/home/text_style.dart';

class ClubWidgets {
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

  static Widget getPosHolder({String imageUrl, String name, String desg}) {
    return Column(
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
    );
  }

  static Widget getClubCard(
      {BuildContext context,
      String title,
      String subtitle = '',
      int id,
      String imageUrl,
      bool isCouncil}) {
    final clubThumbnail = Container(
      margin: new EdgeInsets.symmetric(vertical: 16.0),
      alignment: FractionalOffset.center,
      child: Hero(
        tag: "club-hero-${id}",
        child: Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image(
              fit: BoxFit.contain,
              image: imageUrl == null
                  ? AssetImage('assets/iitbhu.jpeg')
                  : NetworkImage(imageUrl),
            ),
          ),
          height: 92.0,
          width: 92.0,
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
                : NetworkImage(imageUrl),
          ),
        ),
        height: 92.0,
        width: 92.0,
      ),
    );

    final clubCardContent = Container(
      margin: new EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 16.0),
      constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 4.0),
          Text(title, style: Style.titleTextStyle),
          Container(height: 10.0),
          subtitle == ''
              ? SizedBox(height: 1.0)
              : Text(subtitle, style: Style.commonTextStyle),
          Separator(),
        ],
      ),
    );

    final clubCard = Container(
      child: clubCardContent,
      height: 154.0,
      margin: EdgeInsets.fromLTRB(20.0, 120.0, 20.0, 0.0),
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
    if (isCouncil == true)
      return Stack(
        children: [
          clubCard,
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 60.0, 0.0, 0.0),
            child: councilThumbnail,
          ),
        ],
      );
    else
      return Stack(
        children: [
          clubCard,
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 60.0, 0.0, 0.0),
            child: clubThumbnail,
          ),
        ],
      );
  }
}
