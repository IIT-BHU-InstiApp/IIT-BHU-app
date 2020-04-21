import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iit_app/model/appConstants.dart';
import 'dart:async';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/pages/clubs.dart';
import 'package:built_collection/built_collection.dart';

class CreateScreen extends StatefulWidget {
  final int clubId;
  final String clubName;
  final dynamic workshopData;
  const CreateScreen(
      {Key key,
      @required this.clubId,
      @required this.clubName,
      this.workshopData})
      : super(key: key);
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _formKey = GlobalKey<FormState>();
  var _workshop;

  TextEditingController _titleController;
  TextEditingController _descriptionController;
  TextEditingController _locationController;
  TextEditingController _audienceController;
  TextEditingController _resourcesController;
  TextEditingController _contactsController;
  String _editingDate;
  String _editingTime;

  TextEditingController _searchContactsController;
  BuiltProfileSearchPost _searchPost;
  bool _isSearchingContacts = false;
  BuiltList<BuiltContacts> _searchedContactresult;
  String _searchByValue = 'name';
  String _searchString = '';

  final dropDownButtonTextStyle = TextStyle(fontSize: 12);
  DropdownButton _searchCategoryDropDown() => DropdownButton<String>(
        items: [
          DropdownMenuItem(
            value: "name",
            child: Text('Name', style: dropDownButtonTextStyle),
          ),
          DropdownMenuItem(
            value: "email",
            child: Text('Email', style: dropDownButtonTextStyle),
          ),
        ],
        onChanged: (value) {
          if (value == this._searchByValue) return;
          setState(() {
            if (value != this._searchByValue) {
              this._searchContactsController.text = '';
              this._isSearchingContacts = false;
            }
            this._searchByValue = value;
          });
        },
        value: this._searchByValue,
        hint: Text('category'),
      );

  FutureBuilder<Response> _buildContactsFromSearch(BuildContext context) {
    return FutureBuilder<Response<BuiltList<BuiltProfilePost>>>(
      future: AppConstants.service
          .searchProfile("token ${AppConstants.djangoToken}", this._searchPost),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null || snapshot.data.body.isEmpty) {
            return Center(
              child: Text(
                'No such contact found........',
                textAlign: TextAlign.center,
                textScaleFactor: 1.5,
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                textAlign: TextAlign.center,
                textScaleFactor: 1.3,
              ),
            );
          }

          final posts = snapshot.data.body;
          // print(posts);

          return _buildContactsFromSearchPosts(context, posts);
        } else {
          // Show a loading indicator while waiting for the posts
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildContactsFromSearchPosts(
      BuildContext context, BuiltList<BuiltProfilePost> posts) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
          child: ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: posts.length,
            padding: EdgeInsets.all(8),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 3, vertical: 10),
                child: Container(
                  // color: Colors.lightBlue.withOpacity(0.3),
                  height: MediaQuery.of(context).size.height / 11,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: (posts[index].photo_url == null ||
                                    posts[index].photo_url.isEmpty)
                                ? Image.asset('assets/profile_test.jpg')
                                : NetworkImage(posts[index].photo_url),
                          )),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 8.0, right: 10.0),
                          child: Column(
                            children: <Widget>[
                              Text(posts[index].name),
                              Text(posts[index].email),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: OutlineButton(
                          onPressed: null,
                          child: Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    this._titleController = TextEditingController();
    this._descriptionController = TextEditingController();
    this._locationController = TextEditingController();
    this._audienceController = TextEditingController();
    this._resourcesController = TextEditingController();
    this._contactsController = TextEditingController();

    this._searchContactsController = TextEditingController();

    if (widget.workshopData != null) {
      this._titleController.text = widget.workshopData.title;
      this._descriptionController.text = widget.workshopData.description;
      this._editingDate = widget.workshopData.date;
      this._editingTime = widget.workshopData.time;
      this._locationController.text = widget.workshopData.location;
      this._audienceController.text = widget.workshopData.audience;
      this._resourcesController.text = widget.workshopData.resources;
      _workshop = WorkshopCreater(
          editingDate: this._editingDate, editingTime: this._editingTime);
    } else {
      _workshop = WorkshopCreater();
    }

    super.initState();
  }

  showSuccessfulDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Successful!"),
          content: widget.workshopData == null
              ? Text("Workshop succesfully created!")
              : Text("Workshop edited succesfully!"),
          actions: <Widget>[
            FlatButton(
              child: new Text("yay"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                if (widget.workshopData != null) {
                  Navigator.pop(context);
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ClubPage(clubId: widget.clubId, editMode: true)));
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

  Future<bool> confirmDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: widget.workshopData == null
              ? Text("Create workshop")
              : Text("Edit workshop"),
          content: widget.workshopData == null
              ? Text("Are you sure to create this new workshop?")
              : Text("Are you sure to edit this workshop?"),
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
    int _editingyear = int.parse(this._editingDate.substring(0, 4));
    int _editingmonth = int.parse(this._editingDate.substring(5, 7));
    int _editingday = int.parse(this._editingDate.substring(8, 10));
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: widget.workshopData == null
            ? DateTime.now()
            : DateTime(_editingyear, _editingmonth, _editingday),
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
      appBar: AppBar(
          title: widget.workshopData == null
              ? Text('Create Workshop')
              : Text('Edit Workshop')),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Builder(
          builder: (context) => Form(
            key: _formKey,
            child: ListView(
              children: [
                Text(widget.clubName),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Title of the Workshop'),
                  controller: this._titleController,
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
                    controller: this._descriptionController,
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
                    controller: this._locationController,
                    validator: (value) {
                      return null;
                    },
                    onSaved: (val) => setState(() => _workshop.location = val)),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Audience'),
                  controller: this._audienceController,
                  validator: (value) {
                    return null;
                  },
                  onSaved: (val) => setState(() => _workshop.audience = val),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Resources'),
                  controller: this._resourcesController,
                  validator: (value) {
                    return null;
                  },
                  onSaved: (val) => setState(() => _workshop.resources = val),
                ),
                // TextFormField(
                //   keyboardType: TextInputType.number,
                //   inputFormatters: [
                //     WhitelistingTextInputFormatter.digitsOnly,
                //   ],
                //   decoration: InputDecoration(labelText: 'Contacts'),
                //   controller: this._contactsController,
                //   validator: (value) {
                //     return null;
                //   },
                //   onSaved: (val) =>
                //       setState(() => _workshop.contactIds.add(int.parse(val))),
                // ),
                Row(
                  children: <Widget>[
                    _searchCategoryDropDown(),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText:
                                'Search contacts by ${this._searchByValue}'),
                        onFieldSubmitted: (value) async {
                          if (value.isEmpty) return;

                          this._searchPost = BuiltProfileSearchPost((b) => b
                            ..search_by = this._searchByValue
                            ..search_string =
                                this._searchContactsController.text);

                          if (!this.mounted) return;
                          setState(() {
                            this._isSearchingContacts = true;
                          });
                        },
                        controller: this._searchContactsController,
                        validator: (value) {
                          if (value.isNotEmpty && value.length < 3)
                            return '${this._searchByValue} must contain atleast 3 characters';
                        },
                      ),
                    ),
                    this._isSearchingContacts
                        ? RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            onPressed: () {
                              this._searchContactsController.text = '';
                              this._isSearchingContacts = false;
                              if (!this.mounted) return;
                              setState(() {});
                            },
                            child: Text('X Clear'),
                          )
                        : Container()
                  ],
                ),
                this._isSearchingContacts
                    ? Column(
                        children: <Widget>[
                          Divider(
                            height: 2,
                            thickness: 2,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height / 6,
                            child: _buildContactsFromSearch(context),
                          ),
                          Divider(
                            height: 2,
                            thickness: 2,
                          ),
                        ],
                      )
                    : Container(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: RaisedButton(
                    onPressed: () async {
                      final form = _formKey.currentState;
                      if (form.validate()) {
                        form.save();
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: widget.workshopData == null
                                ? Text('Creating Workshop...')
                                : Text('Editing Workshop...'),
                          ),
                        );

                        bool isconfirmed = await confirmDialog();

                        if (isconfirmed == false) return;

                        if (widget.workshopData == null) {
                          final newWorkshop = BuiltWorkshopCreatePost((b) => b
                            ..title = _workshop.title
                            ..description = _workshop.description
                            ..club = widget.clubId
                            ..date = _workshop.date
                            ..time = _workshop.time
                            ..location = _workshop.location
                            ..audience = _workshop.audience
                            ..resources = _workshop.resources
                            ..contacts = _workshop.contacts.toBuilder());

                          await AppConstants.service
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
                          });
                        } else {
                          final editedWorkshop =
                              BuiltWorkshopDetailPost((b) => b
                                ..title = _workshop.title
                                ..description = _workshop.description
                                ..date = _workshop.date
                                ..time = _workshop.time
                                ..location = _workshop.location
                                ..audience = _workshop.audience
                                ..resources = _workshop.resources
                                ..contacts = _workshop.contacts.toBuilder());

                          await AppConstants.service
                              .updateWorkshopByPatch(
                                  widget.workshopData.id,
                                  "token ${AppConstants.djangoToken}",
                                  editedWorkshop)
                              .catchError((onError) {
                            print(
                                'Error editing workshop: ${onError.toString()}');
                            showUnSuccessfulDialog();
                          }).then((value) {
                            if (value.isSuccessful) {
                              print('Edited!');
                              showSuccessfulDialog();
                            }
                          }).catchError((onError) {
                            print(
                                'Error printing EDITED workshop: ${onError.toString()}');
                          });
                        }
                      }
                    },
                    child: widget.workshopData == null
                        ? Text('Create')
                        : Text('Edit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
  List<int> contactIds = [];
  // TODO: add contacts and image_url

  WorkshopCreater({String editingDate, String editingTime}) {
    if (editingDate == null) {
      date = convertDate(DateTime.now());
      time = converTime(TimeOfDay.now());
    } else {
      date = editingDate;
      time = editingTime;
    }
  }
  String convertDate(DateTime date) {
    return date.toString().substring(0, 10);
  }

  String converTime(TimeOfDay time) {
    return time.toString().substring(10, 15);
  }
}
