import 'package:flutter/material.dart';
import 'package:iit_app/external_libraries/spin_kit.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
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
          content: Text("Please try again"),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
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
              child: Text("yay"),
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
        .catchError((onError) {
      print('Error editing club description: ${onError.toString()}');
      this.showUnsuccessfulDialog(context: context);
    }).then((value) {
      if (value.isSuccessful) {
        print('Edited!');
        this.showSuccesfulDialog(context: context);
      }
    }).catchError((onError) {
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
        .catchError((onError) {
      print('Error editing council description: ${onError.toString()}');
      this.showUnsuccessfulDialog(context: context);
    }).then((value) {
      if (value.isSuccessful) {
        print('Edited!');
        this.showSuccesfulDialog(context: context);
      }
    }).catchError((onError) {
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
        .catchError((onError) {
      print('Error editing entity description: ${onError.toString()}');
      this.showUnsuccessfulDialog(context: context);
    }).then((value) {
      if (value.isSuccessful) {
        print('Edited!');
        this.showSuccesfulDialog(context: context);
      }
    }).catchError((onError) {
      print('Error printing EDITED entity: ${onError.toString()}');
    });
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
                                          context: context, action: 'Edit');

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
                  ],
                ),
                Separator(),
                this.editing
                    ? TextFormField(
                        autovalidate: true,
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
