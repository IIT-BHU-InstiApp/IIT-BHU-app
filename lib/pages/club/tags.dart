import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/pages/dialogBoxes.dart';
import 'package:iit_app/ui/separator.dart';
import 'package:iit_app/ui/text_style.dart';

class Tag extends StatefulWidget {
  final dynamic map;
  const Tag({
    Key key,
    @required this.map,
  }) : super(key: key);
  @override
  _TagState createState() => _TagState();
}

class _TagState extends State<Tag> {
  TextEditingController tagController = TextEditingController();
  final _overviewTitle = "Tags".toUpperCase();
  bool editing = false;
  List tags = [
    'Tag14521',
    'Tag2',
    'Tag3',
    'Tag1',
    'Tag2',
    'Tag3',
    'Tag1',
    'Tag2',
    'Tag3',
  ];

  Future showUnSuccessfulDialog({@required BuildContext context}) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("UnSuccessful :("),
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
          content: Text("Tags Created succesfully!"),
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

  Widget build(context) {
    return widget.map == null
        ? Container(
            height: MediaQuery.of(context).size.height * 3 / 4,
            child: Center(
              child: CircularProgressIndicator(),
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
                            icon: Icon(Icons.add_circle_rounded),
                            onPressed: () {
                              this.tagController.text = 'widget.map.tags';
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
                                          context: context, isEditing: true);

                                  if (isconfirmed == false) return;
                                  // TODO: Add confirmed code here

                                  // if (widget.isClub) {
                                  //   await this.editClubDescription(
                                  //       context: context,
                                  //       club: widget.map,
                                  //       description:
                                  //           descriptionController.text);
                                  // } else if (widget.isCouncil) {
                                  //   await this.editCouncilDescription(
                                  //       context: context,
                                  //       council: widget.map,
                                  //       description:
                                  //           descriptionController.text);
                                  // }

                                  setState(() => this.editing = false);
                                },
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
                this.editing
                    ? TextFormField(
                        autovalidate: true,
                        style: Style.commonTextStyle,
                        maxLines: null,
                        controller: this.tagController,
                        autofocus: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter the Tags';
                          }
                          return null;
                        },
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: tags
                                .map((text) => Container(
                                      padding: EdgeInsets.fromLTRB(
                                          0.0, 0.0, 8.0, 0.0),
                                      child: FilterChip(
                                        label: Text(text),
                                        onSelected: null,
                                      ),
                                    ))
                                .toList())),

                // : Text('Hello', style: Style.commonTextStyle),
                Separator(),
              ],
            ),
          );
  }
}
