import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/pages/dialogBoxes.dart';
import 'package:iit_app/ui/separator.dart';
import 'package:iit_app/ui/text_style.dart';

class Description extends StatefulWidget {
  final dynamic map;
  const Description({Key key, @required this.map}) : super(key: key);
  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  TextEditingController descriptionController = TextEditingController();
  final _overviewTitle = "Description".toUpperCase();
  bool editing = false;

  Future showUnSuccessfulDialog({@required BuildContext context}) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("UnSuccessful :("),
          content: new Text("Please try again"),
          actions: <Widget>[
            FlatButton(
              child: new Text("Ok"),
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
    bool isEditing = false,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Successful!"),
          content: isEditing
              ? Text("Workshop edited succesfully!")
              : Text("Workshop succesfully created!"),
          actions: <Widget>[
            FlatButton(
              child: new Text("yay"),
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
        .updateClubByPatch(
            club.id, "token ${AppConstants.djangoToken}", editedClub)
        .catchError((onError) {
      print('Error editing club description: ${onError.toString()}');
      this.showUnSuccessfulDialog(context: context);
    }).then((value) {
      if (value.isSuccessful) {
        print('Edited!');
        this.showSuccesfulDialog(context: context, isEditing: true);
      }
    }).catchError((onError) {
      print('Error printing EDITED club: ${onError.toString()}');
    });
  }

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
                            onPressed: () {
                              this.descriptionController.text =
                                  widget.map.description;
                              setState(() {
                                this.editing = true;
                              });
                            })
                        : Container(),
                    widget.map.is_por_holder
                        ? this.editing
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
                                          await CreatePageDialogBoxes
                                              .confirmDialog(
                                                  context: context,
                                                  isEditing: true);

                                      if (isconfirmed == false) return;
                                      await this.editClubDescription(
                                          context: context,
                                          club: widget.map,
                                          description:
                                              descriptionController.text);
                                      // if (widget.workshopData == null) {
                                      //   await WorkshopCreater.create(
                                      //       context: context,
                                      //       club: _workshop,
                                      //       club: widget.club);
                                      // } else {
                                      //   WorkshopCreater.edit(
                                      //       context: context,
                                      //       club: _workshop,
                                      //       club: widget.club,
                                      //       widgetWorkshopData:
                                      //           widget.workshopData);
                                      // }
                                      setState(() => this.editing = false);
                                    },
                                  ),
                                ],
                              )
                            : Container()
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
