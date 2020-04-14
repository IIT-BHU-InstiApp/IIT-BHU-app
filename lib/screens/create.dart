import 'package:flutter/material.dart';
import 'package:iit_app/data/workshop.dart';
import 'package:iit_app/model/appConstants.dart';
import 'dart:async';

import 'package:iit_app/model/built_post.dart';

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State {
  final _formKey = GlobalKey<FormState>();
  final _workshop = Workshop();

  showSuccessfulDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Successful!"),
          content: new Text("Workshop succesfully created!"),
          actions: <Widget>[
            FlatButton(
              child: new Text("yay"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future showUnSuccessfulDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("UnSuccessful :("),
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

  Future<bool> confirmCreateDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Create workshop"),
          content: new Text("Are you sure to create this new workshop?"),
          actions: <Widget>[
            FlatButton(
              child: new Text("Yup!"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            FlatButton(
              child: new Text("nope, let me rethink.."),
              onPressed: () {
                Navigator.of(context).pop(false);
                return false;
              },
            ),
          ],
        );
      },
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: new DateTime(2018),
        lastDate: new DateTime(2022));

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _workshop.date = convertDate(picked);
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && picked != TimeOfDay.now()) {
      setState(() {
        _workshop.time = converTime(picked);
      });
    }
  }

  // void submitForm() async {
  //   Response<BuiltCouncilPost> snapshots =

  //   // print(snapshots.body);
  //   councilData = snapshots.body;
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Create Workshop')),
        body: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Builder(
                builder: (context) => Form(
                    key: _formKey,
                    child: ListView(children: [
                      // DropdownButton<String>(
                      //   items:
                      //       Workshop.councils.map((String dropDownStringItem) {
                      //     return DropdownMenuItem<String>(
                      //       value: dropDownStringItem,
                      //       child: Text(dropDownStringItem),
                      //     );
                      //   }).toList(),
                      //   onChanged: (value) {
                      //     setState(() {
                      //       _workshop.councilId =
                      //           Workshop.councils.indexOf(value);
                      //       _workshop.club = null;
                      //     });
                      //   },
                      //   value: Workshop.councils[_workshop.councilId],
                      //   hint: Text('Select Council'),
                      // ),
                      // DropdownButton<String>(
                      //   items: Workshop.clubs[_workshop.councilId]
                      //       .map((String dropDownStringItem) {
                      //     return DropdownMenuItem<String>(
                      //       value: dropDownStringItem,
                      //       child: Text(dropDownStringItem),
                      //     );
                      //   }).toList(),
                      //   onChanged: (value) {
                      //     setState(() {
                      //       _workshop.club = value;
                      //     });
                      //   },
                      //   value: _workshop.club,
                      //   hint: Text('Select Club'),
                      // ),
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Title of the Workshop'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter the title';
                          }
                          return null;
                        },
                        onSaved: (val) => setState(() => _workshop.title = val),
                      ),
                      // TextFormField(
                      //     decoration: InputDecoration(labelText: 'Description'),
                      //     validator: (value) {
                      //       if (value.isEmpty) {
                      //         return 'Please describe the workshop in detail.';
                      //       }
                      //       return null;
                      //     },
                      //     onSaved: (val) =>
                      //         setState(() => _workshop.description = val)),
                      // Container(
                      //   padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      //   child: SwitchListTile(
                      //       title: const Text('\'number of people going\''),
                      //       value: _workshop.showGoing,
                      //       onChanged: (bool val) =>
                      //           setState(() => _workshop.showGoing = val)),
                      // ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          // Container(
                          //   padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                          //   child: Text("Select Date:"),
                          // ),
                          RaisedButton(
                            onPressed: () => _selectDate(context),
                            child: Text('${_workshop.date}'),
                          ),
                          RaisedButton(
                            onPressed: () => _selectTime(context),
                            child: Text('${_workshop.time}'),
                          ),
                        ],
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 16.0),
                          child: RaisedButton(
                              onPressed: () async {
                                final form = _formKey.currentState;
                                if (true) {
                                  // if (_workshop.councilId == null)
                                  //   Scaffold.of(context).showSnackBar(SnackBar(
                                  //       content:
                                  //           Text('Please select council')));
                                  // if (_workshop.club == null)
                                  //   Scaffold.of(context).showSnackBar(SnackBar(
                                  //       content: Text('Please select club')));
                                  {
                                    form.save();
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text('Submitting form')));
                                    // BuiltWorkshopCreatePost snapshot =
                                    //     new BuiltWorkshopCreatePost();
                                    // print(snapshot.club);
                                    // snapshot.body.id = 6;
                                    final newWorkshop =
                                        BuiltWorkshopCreatePost((b) => b
                                          ..title = 'New Title'
                                          ..club = 2
                                          ..date = '2020-04-13');

                                    await confirmCreateDialog()
                                        ? await AppConstants.service
                                            .postNewWorkshop(
                                                "token ${AppConstants.djangoToken}",
                                                newWorkshop)
                                            .catchError((onError) {
                                            print(
                                                'Error creating workshop: ${onError.toString()}');
                                            showUnSuccessfulDialog();
                                          }).then((value) {
                                            if (value.isSuccessful) {
                                              print('Created!');
                                              showSuccessfulDialog();
                                            }
                                          }).catchError((onError) {
                                            print(
                                                'Error printing CREATED workshop: ${onError.toString()}');
                                          })
                                        : null;
                                  }
                                }
                              },
                              child: Text('Create'))),
                    ])))));
  }
}
