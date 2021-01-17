import 'dart:io';
import 'dart:typed_data';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/data/internet_connection_interceptor.dart';
import 'package:iit_app/external_libraries/spin_kit.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/services/dynamicLink.dart';
import 'package:iit_app/ui/dialogBoxes.dart';
import 'package:iit_app/ui/separator.dart';
import 'package:iit_app/ui/text_style.dart';

// TODO: we need only isPorHolder and description rather the whole model

class Description extends StatefulWidget {
  final dynamic map;
  final bool isClub;
  final bool isCouncil;
  final bool isEntity;
  const Description(
      {Key key,
      @required this.map,
      this.isClub = false,
      this.isCouncil = false,
      this.isEntity = false})
      : super(key: key);
  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  TextEditingController descriptionController = TextEditingController();
  final _overviewTitle = "Description".toUpperCase();
  bool editing = false;

  Future showUnsuccessfulDialog({@required BuildContext context}) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Unsuccessful :("),
          content: Text("Please try again."),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok."),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  showSuccesfulDialog({
    @required BuildContext context,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Successful!"),
          content: Text("Description edited succesfully!"),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok."),
              onPressed: () {
                Navigator.pop(context);
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  Future editClubDescription(
      {@required BuildContext context,
      @required BuiltClubPost club,
      @required String description}) async {
    final editedClub = BuiltClubPost((b) => b..description = description);

    await AppConstants.service
        .updateClubByPatch(club.id, AppConstants.djangoToken, editedClub)
        .then((value) {
      if (value.isSuccessful) {
        print('Edited!');
        this.showSuccesfulDialog(context: context);
      }
    }).catchError((onError) {
      if (onError is InternetConnectionException) {
        AppConstants.internetErrorFlushBar.showFlushbar(context);
        return;
      }
      this.showUnsuccessfulDialog(context: context);
      print('Error printing EDITED club: ${onError.toString()}');
    });
  }

  Future editCouncilDescription(
      {@required BuildContext context,
      @required BuiltCouncilPost council,
      @required String description}) async {
    final editedCouncil = BuiltCouncilPost((b) => b..description = description);

    await AppConstants.service
        .updateCouncilByPatch(
            council.id, AppConstants.djangoToken, editedCouncil)
        .then((value) {
      if (value.isSuccessful) {
        print('Edited!');
        this.showSuccesfulDialog(context: context);
      }
    }).catchError((onError) {
      if (onError is InternetConnectionException) {
        AppConstants.internetErrorFlushBar.showFlushbar(context);
        return;
      }
      this.showUnsuccessfulDialog(context: context);
      print('Error printing EDITED council: ${onError.toString()}');
    });
  }

  Future editEntityDescription(
      {@required BuildContext context,
      @required BuiltEntityPost entity,
      @required String description}) async {
    final editedEntity = BuiltEntityPost((b) => b..description = description);

    await AppConstants.service
        .updateEntityByPatch(entity.id, AppConstants.djangoToken, editedEntity)
        .then((value) {
      if (value.isSuccessful) {
        print('Edited!');
        this.showSuccesfulDialog(context: context);
      }
    }).catchError((onError) {
      if (onError is InternetConnectionException) {
        AppConstants.internetErrorFlushBar.showFlushbar(context);
        return;
      }
      this.showUnsuccessfulDialog(context: context);
      print('Error printing EDITED entity: ${onError.toString()}');
    });
  }

  Future<void> _shareWithImage(Uri uri) async {
    try {
      var request =
          await HttpClient().getUrl(Uri.parse(widget.map.small_image_url));

      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      await Share.file(
          '${widget.map.name}', '${widget.map.id}.png', bytes, 'image/png',
          text:
              'Do Subscribe ${widget.map.name} to stay updated about upcoming workshops and events: ${uri.toString()}');
    } catch (err) {
      _shareWithoutImage(uri);
    }
  }

  Future<void> _shareWithoutImage(Uri uri) async {
    Share.text(
        '${widget.map.name}',
        'Do Subscribe ${widget.map.name} to stay updated about upcoming workshops and events: ${uri.toString()}',
        'text/plain');
  }

  Widget build(context) {
    return widget.map == null
        ? Container(
            height: MediaQuery.of(context).size.height * 3 / 4,
            child: Center(
              child: LoadingCircle,
            ),
          )
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
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
                            onPressed: () {
                              this.descriptionController.text =
                                  widget.map.description;
                              setState(() {
                                this.editing = true;
                              });
                            })
                        : Container(),
                    this.editing
                        ? Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.cancel),
                                onPressed: () =>
                                    setState(() => this.editing = false),
                              ),
                              IconButton(
                                icon: Icon(Icons.done),
                                onPressed: () async {
                                  bool isconfirmed =
                                      await CreatePageDialogBoxes.confirmDialog(
                                          context: context,
                                          title: 'Edit',
                                          action: 'Edit');

                                  if (isconfirmed == false) return;
                                  if (widget.isClub) {
                                    await this.editClubDescription(
                                        context: context,
                                        club: widget.map,
                                        description:
                                            descriptionController.text);
                                  } else if (widget.isCouncil) {
                                    await this.editCouncilDescription(
                                        context: context,
                                        council: widget.map,
                                        description:
                                            descriptionController.text);
                                  } else if (widget.isEntity) {
                                    await this.editEntityDescription(
                                        context: context,
                                        entity: widget.map,
                                        description:
                                            descriptionController.text);
                                  }

                                  setState(() => this.editing = false);
                                },
                              ),
                            ],
                          )
                        : Container(),
                    SizedBox(width: 18.0),
                    widget.isCouncil
                        ? Container()
                        : Container(
                            child: FutureBuilder<Uri>(
                              future: widget.isClub
                                  ? DynamicLinkService.createDynamicLink(
                                      id: widget.map.id, isClub: widget.isClub)
                                  : DynamicLinkService.createDynamicLink(
                                      id: widget.map.id, isClub: widget.isClub),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  Uri uri = snapshot.data;
                                  return IconButton(
                                      color: ColorConstants.textColor,
                                      icon: Icon(Icons.share),
                                      iconSize: 30.0,
                                      onPressed: () {
                                        widget.map.small_image_url != null
                                            ? _shareWithImage(uri)
                                            : _shareWithoutImage(uri);
                                      });
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ),
                  ],
                ),
                Separator(),
                this.editing
                    ? TextFormField(
                        style: Style.commonTextStyle,
                        maxLines: null,
                        controller: this.descriptionController,
                        autofocus: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter the description';
                          }
                          return null;
                        },
                      )
                    : Text(widget.map.description,
                        style: Style.commonTextStyle),
              ],
            ),
          );
  }
}
