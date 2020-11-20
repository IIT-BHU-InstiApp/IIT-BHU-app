import 'dart:io';
import 'dart:ui';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/external_libraries/spin_kit.dart';
import 'package:iit_app/model/appConstants.dart';
import 'dart:async';
import 'package:iit_app/model/built_post.dart';
import 'package:built_collection/built_collection.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/model/workshopCreator.dart';
import 'package:iit_app/ui/dialogBoxes.dart';
import 'package:image_picker/image_picker.dart';

class CreateScreen extends StatefulWidget {
  final ClubListPost club;
  final String clubName;
  final BuiltWorkshopDetailPost workshopData;
  const CreateScreen({Key key, @required this.club, @required this.clubName, this.workshopData})
      : super(key: key);
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _formKey = GlobalKey<FormState>();
  WorkshopCreater _workshop;

  MemoryImage _newImage;
  NetworkImage _oldImage;

  TextEditingController _titleController;
  TextEditingController _descriptionController;
  TextEditingController _locationController;
  TextEditingController _audienceController;
  TextEditingController _tagSearchController;
  TextEditingController _tagCreateController;
  TextEditingController _linkController;

  String _editingDate;
  String _editingTime;

  TextEditingController _searchContactsController;
  BuiltProfileSearchPost _searchPost;
  bool _isSearchingContacts = false;

  final _searchContactFormKey = GlobalKey<FormState>();

  BuiltList<BuiltProfilePost> _searchedProfileresult;
  String _searchByValue = 'name';

  TagSearch _tagSearchPost; // Tag to search for
  TagDetail _createdTagResult; // Response of a created tag(may be null if the tag already exists)
  bool _tagDataFetched = false; // Has the created tag data been fetched?
  bool _isSearchingTags = false; // Has the user searched for the tag?
  bool _searchedDataFetched = false; // Have the searched tags been fetched?
  bool _allTagDataFetched = false; // Have all the tags of this club been fetched?
  bool _allTagDataShow = false; // Should all the tags of the club be shown?

  BuiltList<TagDetail> _searchedTagResult;
  BuiltList<TagDetail> _allTagsOfClub;

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
              this._searchContactFormKey.currentState.reset();
            }
            this._searchByValue = value;
          });
        },
        value: this._searchByValue,
        hint: Text('category'),
      );

  @override
  void initState() {
    this._titleController = TextEditingController();
    this._descriptionController = TextEditingController();
    this._locationController = TextEditingController();
    this._audienceController = TextEditingController();
    this._tagSearchController = TextEditingController();
    this._tagCreateController = TextEditingController();
    this._linkController = TextEditingController();

    this._searchContactsController = TextEditingController();

    if (widget.workshopData != null) {
      if (widget.workshopData.image_url != null) {
        this._oldImage = NetworkImage(widget.workshopData.image_url);
      }

      this._titleController.text = widget.workshopData.title;
      this._descriptionController.text = widget.workshopData.description;
      this._editingDate = widget.workshopData.date;
      this._editingTime = widget.workshopData.time;
      this._locationController.text = widget.workshopData.location;
      this._audienceController.text = widget.workshopData.audience;
      _workshop = WorkshopCreater(editingDate: this._editingDate, editingTime: this._editingTime);
      widget.workshopData.contacts.forEach((contact) {
        this._workshop.contactIds.add(contact.id);
        this._workshop.contactNameofId[contact.id] = WorkshopCreater.nameOfContact(contact.name);
      });
      widget.workshopData.tags.forEach((tag) {
        this._workshop.tagNameofId[tag.id] = tag.tag_name;
      });
      this._workshop.latitude = widget.workshopData.latitude;
      this._workshop.longitude = widget.workshopData.longitude;
    } else {
      _workshop = WorkshopCreater();
    }

    super.initState();
  }

  tagAlertDialog(String title, String innerText) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title ?? '(No Title)'),
            content: Text(innerText ?? '(No Inner Text)'),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  tagCreateDialog() async {
    bool errorMessageShown = false;
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, refreshState) {
          return AlertDialog(
              content: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: this._tagCreateController,
                      decoration: InputDecoration(
                        labelText: 'Create Tag',
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text('+ Create'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    onPressed: () async {
                      print(this._tagCreateController.text);
                      final newTag = TagCreate((b) => b
                        ..tag_name = this._tagCreateController.text
                        ..club = widget.club.id);
                      await AppConstants.service
                          .createTag(AppConstants.djangoToken, newTag)
                          .catchError((onError) {
                        final error = onError as Response<dynamic>;
                        print(error.body);
                        if (error.body
                            .toString()
                            .contains('The tag already exists for this club')) {
                          tagAlertDialog('Tag Exists',
                              'This tag already exists. Search for it if you wish to add it to the workshop.');
                          errorMessageShown = true;
                          refreshState(() => this._tagCreateController.clear());
                        }
                        print(
                            'Error while creating Tag: ${onError.toString()} ${onError.runtimeType}');
                      }).then((value) {
                        if (value != null) {
                          this._createdTagResult = value.body;
                          tagAlertDialog('Tag Created',
                              'The Tag has been created succesfully. Search for it again, and add it to the worshop if you wish.');

                          refreshState(() => this._tagCreateController.clear());
                        } else if (errorMessageShown == false) {
                          tagAlertDialog('Error', 'There was an error creating this tag.');
                        }
                      });
                    },
                  )
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    this._tagCreateController.text = '';
                    Navigator.of(context).pop();
                  },
                )
              ]);
        });
      },
    );
  }

  _pickImage() async {
    final _file = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxHeight: 520,
      maxWidth: 520,
    );
    if (_file == null) return;
    this._oldImage = null;
    _newImage = MemoryImage(await _file.readAsBytes());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(2.0),
      child: Scaffold(
        // backgroundColor: ColorConstants.homeBackground,
        appBar: AppBar(
            backgroundColor: ColorConstants.homeBackground,
            title: widget.workshopData == null ? Text('Create Workshop') : Text('Edit Workshop')),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Builder(
            builder: (context) => Form(
              key: _formKey,
              child: ListView(
                children: [
                  Text(
                    widget.clubName,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blue, fontSize: 24),
                  ),
                  SizedBox(height: 8),
                  Card(
                    elevation: 4,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      height: MediaQuery.of(context).size.height / 4,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              image: this._oldImage == null
                                  ? (_newImage == null ? null : DecorationImage(image: _newImage))
                                  : DecorationImage(image: this._oldImage),
                            ),
                            child: InkWell(
                                onTap: _pickImage,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(child: Icon(Icons.add, size: 40)),
                                    _newImage == null
                                        ? Text('By default, club image will be shown')
                                        : Container(),
                                  ],
                                )),
                          ),
                          _newImage != null
                              ? Align(
                                  alignment: Alignment.topRight,
                                  child: CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.yellow,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.red,
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        if (_oldImage != null) {
                                          this._oldImage = null;
                                        }
                                        setState(() {
                                          _newImage = null;
                                        });
                                      },
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Title of the Workshop'),
                    controller: this._titleController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter the title';
                      }
                      return null;
                    },
                    onSaved: (val) => _workshop.title = val,
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                      decoration: InputDecoration(labelText: 'Description'),
                      minLines: 3,
                      maxLines: 6,
                      controller: this._descriptionController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please describe the workshop in detail.';
                        }
                        return null;
                      },
                      onSaved: (val) => setState(() => _workshop.description = val)),
                  SizedBox(height: 8),
                  TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Link', hintText: 'Link should be valid url'),
                      controller: this._linkController,
                      onSaved: (val) => _workshop.link = val),
                  SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Date:"),
                      RaisedButton(
                        onPressed: () => _selectDate(context),
                        child: Text('${_workshop.date}'),
                      ),
                      Text("Time:"),
                      RaisedButton(
                        onPressed: () => _selectTime(context),
                        child: Text('${_workshop.time}'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Location',
                              hintText: 'Choose from Map or enter manually',
                            ),
                            controller: this._locationController,
                            onSaved: (val) => _workshop.location = val),
                      ),
                      this._workshop.latitude != null && this._workshop.latitude != ''
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                this._workshop.latitude = null;
                                this._workshop.longitude = null;
                                this._workshop.location = null;
                                _locationController.clear();
                                setState(() {});
                              })
                          : Container(),
                      RaisedButton(
                        child: Icon(Icons.map),
                        onPressed: () async {
                          final location = await Navigator.of(context).pushNamed('/mapPage',
                              arguments: {'fromWorkshopCreate': true}) as List<String>;
                          this._workshop.latitude = location == null ? null : location[0];
                          this._workshop.longitude = location == null ? null : location[1];
                          _locationController.text =
                              location == null ? _locationController.text : location[2];
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  this._workshop.latitude != null && this._workshop.longitude != null
                      ? Text('${this._workshop.latitude}, ${this._workshop.longitude}')
                      : Container(),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Audience',
                      hintText: 'Who should attend it?',
                    ),
                    controller: this._audienceController,
                    validator: (value) {
                      return null;
                    },
                    onSaved: (val) => _workshop.audience = val,
                  ),
                  widget.workshopData != null
                      ? Container()
                      : Form(
                          key: this._searchContactFormKey,
                          child: Row(
                            children: <Widget>[
                              _searchCategoryDropDown(),
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      labelText: 'Search contacts by ${this._searchByValue}'),
                                  onFieldSubmitted: (value) async {
                                    if (value.isEmpty) return;

                                    if (!this._searchContactFormKey.currentState.validate()) return;

                                    this._searchPost = BuiltProfileSearchPost((b) => b
                                      ..search_by = this._searchByValue
                                      ..search_string = this._searchContactsController.text);

                                    if (!this.mounted) return;
                                    setState(() {
                                      this._isSearchingContacts = true;
                                      this._searchedDataFetched = false;

                                      this._searchedProfileresult = null;
                                    });
                                    await AppConstants.service
                                        .searchProfile(AppConstants.djangoToken, this._searchPost)
                                        .catchError((onError) {
                                      print('Error while fetching search results: $onError');
                                    }).then((result) {
                                      if (result != null) this._searchedProfileresult = result.body;
                                    });

                                    if (!this.mounted) return;
                                    setState(() {
                                      this._searchedDataFetched = true;
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
                              child: _buildContactsFromSearchPosts(context),
                            ),
                            Divider(
                              height: 2,
                              thickness: 2,
                            ),
                          ],
                        )
                      : Container(),
                  this._workshop.contactIds.length > 0
                      ? Container(
                          height: 50,
                          child: Row(
                            children: [
                              Text('Contacts: '),
                              Expanded(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: this._workshop.contactIds.length,
                                  itemBuilder: (context, index) {
                                    int _id = this._workshop.contactIds[index];
                                    return Container(
                                      padding: EdgeInsets.all(2),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(this._workshop.contactNameofId[_id]),
                                          widget.workshopData != null
                                              ? Container()
                                              : InkWell(
                                                  splashColor: Colors.red,
                                                  onTap: () {
                                                    setState(() {
                                                      this._workshop.contactIds.remove(_id);
                                                      this._workshop.contactNameofId.remove(_id);
                                                    });
                                                  },
                                                  child: Icon(Icons.cancel),
                                                ),
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder: (_, __) {
                                    return Text(' | ');
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  widget.workshopData != null
                      ? Container()
                      : Row(children: [
                          Expanded(
                            child: TextFormField(
                              controller: this._tagSearchController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                labelText: 'Search tags by name',
                                suffix: IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    this._tagSearchController.text = '';
                                    if (!this.mounted) return;
                                  },
                                ),
                              ),
                              onFieldSubmitted: (value) async {
                                print("Submitted");
                                if (value.isEmpty) return;

                                this._tagSearchPost = TagSearch((b) => b
                                  ..club = widget.club.id
                                  ..tag_name = this._tagSearchController.text);

                                if (!this.mounted) return;
                                setState(() {
                                  this._isSearchingTags = true;
                                  this._tagDataFetched = false;
                                  this._searchedTagResult = null;
                                  this._allTagDataShow = false;
                                });
                                await AppConstants.service
                                    .searchTag(AppConstants.djangoToken, this._tagSearchPost)
                                    .catchError((onError) {
                                  print('Error while fetching tags $onError');
                                }).then((result) {
                                  if (result != null) this._searchedTagResult = result.body;
                                });
                                if (!this.mounted) return;
                                setState(() {
                                  this._tagDataFetched = true;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: RaisedButton(
                              child: Text('+ Create'),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              onPressed: () async {
                                await tagCreateDialog();
                              },
                            ),
                          ),
                          this._isSearchingTags || this._allTagDataShow
                              ? RaisedButton(
                                  child: Text('X Clear'),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    this._tagSearchController.text = '';
                                    this._isSearchingTags = false;
                                    this._allTagsOfClub = null;
                                    this._allTagDataShow = false;
                                    this._allTagDataFetched = false;
                                    if (!this.mounted) return;
                                    setState(() {});
                                  },
                                )
                              : RaisedButton(
                                  child: Text('All Tags'),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();
                                    await AppConstants.service
                                        .getClubTags(widget.club.id, AppConstants.djangoToken)
                                        .catchError((onError) {
                                      print('Error while fetching all tags $onError');
                                    }).then((result) {
                                      if (result != null) {
                                        this._allTagsOfClub = result.body.club_tags;
                                        this._allTagDataShow = true;
                                        this._allTagDataFetched = true;
                                        setState(() {});
                                      }
                                    });
                                  },
                                ),
                        ]),
                  this._isSearchingTags || this._allTagDataShow
                      ? Column(
                          children: <Widget>[
                            Divider(
                              height: 2,
                              thickness: 2,
                            ),
                            Container(
                              constraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.height / 10,
                              ),
                              child: this._isSearchingTags
                                  ? _buildTagsFromSearchPosts(context)
                                  : this._allTagDataShow
                                      ? _buildAllTagsOfClub(context)
                                      : Container(),
                            ),
                            Divider(
                              height: 2,
                              thickness: 2,
                            ),
                          ],
                        )
                      : Container(),
                  this._workshop.tagNameofId.keys.length > 0
                      ? Container(
                          height: 50,
                          child: Row(
                            children: [
                              Text('Tags: '),
                              Expanded(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: this._workshop.tagNameofId.keys.length,
                                  itemBuilder: (context, index) {
                                    int _id = this._workshop.tagNameofId.keys.toList()[index];
                                    return Container(
                                      padding: EdgeInsets.all(2),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(this._workshop.tagNameofId[_id]),
                                          widget.workshopData != null
                                              ? Container()
                                              : InkWell(
                                                  child: Icon(Icons.cancel),
                                                  splashColor: Colors.red,
                                                  onTap: () {
                                                    setState(() {
                                                      this._workshop.tagNameofId.remove(_id);
                                                    });
                                                  },
                                                ),
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder: (_, __) {
                                    return Text(' | ');
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 64.0),
                    child: RaisedButton(
                      color: ColorConstants.homeBackground,
                      onPressed: () async {
                        final form = _formKey.currentState;
                        if (form.validate()) {
                          form.save();

                          bool isconfirmed = await CreatePageDialogBoxes.confirmDialog(
                              context: context,
                              action: widget.workshopData == null ? 'Create' : 'Edit');

                          if (isconfirmed == false || isconfirmed == null) return;

                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: widget.workshopData == null
                                  ? Text('Creating Workshop...')
                                  : Text('Editing Workshop...'),
                            ),
                          );

                          if (widget.workshopData == null) {
                            await _workshop.create(
                                context: context, club: widget.club, image: _newImage);
                          } else {
                            await _workshop.edit(
                                context: context,
                                club: widget.club,
                                widgetWorkshopData: widget.workshopData);
                          }
                        }
                      },
                      child: Text(
                        widget.workshopData == null ? 'Create' : 'Edit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactsFromSearchPosts(
    BuildContext context,
  ) {
    return this._searchedDataFetched
        ? ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                child: (this._searchedProfileresult == null || this._searchedProfileresult.isEmpty)
                    ? Center(
                        child: Text(
                          'No such contact found........',
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.5,
                        ),
                      )
                    : ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: _searchedProfileresult.length,
                        padding: EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          bool _isAdded =
                              this._workshop.contactIds.contains(_searchedProfileresult[index].id);

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
                                        image: (_searchedProfileresult[index].photo_url == null ||
                                                _searchedProfileresult[index].photo_url.isEmpty)
                                            ? Image.asset('assets/profile_test.jpg')
                                            : NetworkImage(_searchedProfileresult[index].photo_url),
                                      )),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0, right: 10.0),
                                      child: Column(
                                        children: <Widget>[
                                          Text(_searchedProfileresult[index].name),
                                          Text(_searchedProfileresult[index].email),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: OutlineButton(
                                      onPressed: () {
                                        int _id = _searchedProfileresult[index].id;
                                        String _name = WorkshopCreater.nameOfContact(
                                            _searchedProfileresult[index].name);

                                        if (_isAdded) {
                                          _isAdded = false;
                                          this._workshop.contactIds.remove(_id);
                                          this._workshop.contactNameofId.remove(_id);
                                        } else {
                                          _isAdded = true;
                                          this._workshop.contactIds.add(_id);
                                          this._workshop.contactNameofId[_id] = _name;
                                        }
                                        if (!this.mounted) return;
                                        setState(() {});
                                      },
                                      child: Icon(_isAdded ? Icons.remove : Icons.add),
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
          )
        : Center(
            child: LoadingCircle,
          );
  }

  Widget _buildTagsFromSearchPosts(
    BuildContext context,
  ) {
    return this._tagDataFetched
        ? Container(
            child: (this._searchedTagResult == null || this._searchedTagResult.isEmpty)
                ? Center(
                    child: Text(
                      'No such Tag',
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.5,
                    ),
                  )
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, childAspectRatio: 4),
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: this._searchedTagResult.length,
                    padding: EdgeInsets.all(2),
                    itemBuilder: (context, index) {
                      int _id = this._searchedTagResult[index].id;
                      return Container(
                        padding: EdgeInsets.all(2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(this._searchedTagResult[index].tag_name),
                            InkWell(
                              child: (this._workshop.tagNameofId.keys.contains(_id))
                                  ? Icon(Icons.close)
                                  : Icon(Icons.add),
                              splashColor: Colors.green,
                              onTap: () {
                                setState(() {
                                  if (this._workshop.tagNameofId.keys.contains(_id))
                                    this._workshop.tagNameofId.remove(_id);
                                  else
                                    this._workshop.tagNameofId[_id] =
                                        this._searchedTagResult[index].tag_name;
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ))
        : Container();
  }

  Widget _buildAllTagsOfClub(
    BuildContext context,
  ) {
    return this._allTagDataFetched
        ? Container(
            child: (this._allTagsOfClub == null || this._allTagsOfClub.isEmpty)
                ? Center(
                    child: Text(
                      'No Tags of this club available',
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.5,
                    ),
                  )
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, childAspectRatio: 4),
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: this._allTagsOfClub.length,
                    padding: EdgeInsets.all(2),
                    itemBuilder: (context, index) {
                      int _id = this._allTagsOfClub[index].id;
                      return Container(
                        padding: EdgeInsets.all(2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(this._allTagsOfClub[index].tag_name),
                            InkWell(
                              child: (this._workshop.tagNameofId.keys.contains(_id))
                                  ? Icon(Icons.close)
                                  : Icon(Icons.add),
                              splashColor: (this._workshop.tagNameofId.keys.contains(_id))
                                  ? Colors.red
                                  : Colors.green,
                              onTap: () {
                                setState(() {
                                  if (this._workshop.tagNameofId.keys.contains(_id))
                                    this._workshop.tagNameofId.remove(_id);
                                  else
                                    this._workshop.tagNameofId[_id] =
                                        this._allTagsOfClub[index].tag_name;
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ))
        : Container();
  }

  Future<Null> _selectDate(BuildContext context) async {
    if (this._editingDate == null) {
      this._editingDate = DateTime.now().toString();
    }
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
}
