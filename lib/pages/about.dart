import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPageListTile {
  static Widget getAboutPageListTile() => AboutListTile(
      child: Text("About"),
      applicationName: "Institute App",
      applicationVersion: "v1.0.0",
      applicationIcon: Icon(Icons.apps),
      aboutBoxChildren: <Widget>[
        Text('UI Designer'),
        Text('App Developers'),
        Text('BackEnd Developers'),
        Text('Ideation'),
        Text('Alumni'),
        Text('Frameworks'),
        InkWell(
          child: new Text('Flutter'),
          onTap: () => launch('https://www.flutter.com'),
        ),
        InkWell(
          child: new Text('DRF'),
          onTap: () => launch('https://https://www.django-rest-framework.org/'),
        ),
      ],
      icon: Icon(Icons.info));
}
