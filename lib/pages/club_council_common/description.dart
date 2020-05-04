import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/ui/separator.dart';
import 'package:iit_app/ui/text_style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../club/club.dart';
import 'package:url_launcher/url_launcher.dart';

class Description extends StatefulWidget {
  final dynamic map;
  const Description({Key key, @required this.map}) : super(key: key);
  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  TextEditingController textEditingController = TextEditingController();
  final _overviewTitle = "Description".toUpperCase();
  bool editing = false;

  Widget build(context) {
    return widget.map == null
        ? Container(
            height: MediaQuery.of(context).size.height * 3 / 4,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Container(
            padding: new EdgeInsets.symmetric(horizontal: 32.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      _overviewTitle,
                      style: Style.headerTextStyle,
                    ),
                    widget.map.is_por_holder
                        ? IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () =>
                                setState(() => this.editing = true),
                          )
                        : Container(),
                    widget.map.is_por_holder
                        ? this.editing
                            ? IconButton(
                                icon: Icon(Icons.cancel),
                                onPressed: () =>
                                    setState(() => this.editing = false),
                              )
                            : Container()
                        : Container(),
                  ],
                ),
                Separator(),
                this.editing
                    ? TextFormField()
                    : Text(widget.map.description,
                        style: Style.commonTextStyle),
              ],
            ),
          );
  }
}
