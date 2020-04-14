import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'dart:async';

import 'package:iit_app/model/built_post.dart';

class CreateScreen extends StatefulWidget {
  final int clubId;
  final String clubName;
  const CreateScreen({Key key, @required this.clubId, @required this.clubName})
      : super(key: key);
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _workshop = WorkshopCreater();

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
        _workshop.date = _workshop.convertDate(picked);
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
        _workshop.time = _workshop.converTime(picked);
      });
    }
  }

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
                      Text(widget.clubName),
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
                      TextFormField(
                          decoration: InputDecoration(labelText: 'Description'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please describe the workshop in detail.';
                            }
                            return null;
                          },
                          onSaved: (val) =>
                              setState(() => _workshop.description = val)),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                            child: Text("Select Date:"),
                          ),
                          RaisedButton(
                            onPressed: () => _selectDate(context),
                            child: Text('${_workshop.date}'),
                          ),
                          // TODO: make time selection optional
                          RaisedButton(
                            onPressed: () => _selectTime(context),
                            child: Text('${_workshop.time}'),
                          ),
                        ],
                      ),
                      TextFormField(
                          decoration: InputDecoration(labelText: 'Location'),
                          validator: (value) {
                            return null;
                          },
                          onSaved: (val) =>
                              setState(() => _workshop.location = val)),
                      TextFormField(
                          decoration: InputDecoration(labelText: 'Audience'),
                          validator: (value) {
                            return null;
                          },
                          onSaved: (val) =>
                              setState(() => _workshop.audience = val)),
                      TextFormField(
                          decoration: InputDecoration(labelText: 'Resources'),
                          validator: (value) {
                            return null;
                          },
                          onSaved: (val) =>
                              setState(() => _workshop.resources = val)),
                      Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 16.0),
                          child: RaisedButton(
                              onPressed: () async {
                                final form = _formKey.currentState;
                                if (form.validate()) {
                                  form.save();
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text('Creating Workshop...')));
                                  final newWorkshop =
                                      BuiltWorkshopCreatePost((b) => b
                                        ..title = _workshop.title
                                        ..description = _workshop.description
                                        ..club = widget.clubId
                                        ..date = _workshop.date
                                        ..time = _workshop.time
                                        ..location = _workshop.location
                                        ..audience = _workshop.audience
                                        ..resources = _workshop.resources);

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
                              },
                              child: Text('Create'))),
                    ])))));
  }
}

class WorkshopCreater {
  String title;
  String description;
  int clubId;
  String date;
  String time;
  String location;
  String audience;
  String resources;
  // TODO: add contacts and image_url

  WorkshopCreater() {
    date = convertDate(DateTime.now());
    time = converTime(TimeOfDay.now());
  }
  String convertDate(DateTime date) {
    return date.toString().substring(0, 10);
  }

  String converTime(TimeOfDay time) {
    return time.toString().substring(10, 15);
  }
}
