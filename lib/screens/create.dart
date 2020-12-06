import 'dart:ui';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/data/internet_connection_interceptor.dart';
import 'package:iit_app/external_libraries/spin_kit.dart';
import 'package:iit_app/model/appConstants.dart';
import 'dart:async';
import 'package:iit_app/model/built_post.dart';
import 'package:built_collection/built_collection.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/model/workshopCreator.dart';
import 'package:iit_app/ui/dialogBoxes.dart';
import 'package:image_picker/image_picker.dart';

class CreateEditScreen extends StatefulWidget {
  final ClubListPost club;
  final String title;
  final EntityListPost entity;
  final BuiltWorkshopDetailPost workshopData;
  final String isWorkshopOrEvent;
  const CreateEditScreen(
      {Key key,
      @required this.club,
      @required this.title,
      this.workshopData,
      @required this.entity,
      @required this.isWorkshopOrEvent})
      : super(key: key);
  @override
  _CreateEditScreenState createState() => _CreateEditScreenState();
}

class _CreateEditScreenState extends State<CreateEditScreen> {
  final _formKey = GlobalKey<FormState>();
  WorkshopCreater _workshop;

  bool _isEntity = false;

  MemoryImage _newImage;
  NetworkImage _oldImage;

  TextEditingController _titleController;
  TextEditingController _descriptionController;
  TextEditingController _locationController;
  TextEditingController _audienceController;
  TextEditingController _tagSearchController;
  TextEditingController _tagCreateController;

  String _editingDate;
  String _editingTime;

  TextEditingController _searchContactsController;
  BuiltProfileSearchPost _searchPost;
  bool _isSearchingContacts = false;

  final _searchContactFormKey = GlobalKey<FormState>();

  BuiltList<BuiltProfilePost> _searchedProfileresult;
  String _searchByValue = 'name';

  TagSearch _tagSearchPost; // Tag to search for
  bool _tagDataFetched = false; // Has the created tag data been fetched?
  bool _isSearchingTags = false; // Has the user searched for the tag?
  bool _searchedDataFetched = false; // Have the searched tags been fetched?
  bool _allTagDataFetched =
      false; // Have all the tags of this club/entity been fetched?
  bool _allTagDataShow =
      false; // Should all the tags of the club/entity be shown?

  BuiltList<TagDetail> _searchedTagResult;
  BuiltList<TagDetail> _allTagsOfClubOrEntity;

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
    this._isEntity = widget.entity != null;

    this._titleController = TextEditingController();
    this._descriptionController = TextEditingController();
    this._locationController = TextEditingController();
    this._audienceController = TextEditingController();
    this._tagSearchController = TextEditingController();
    this._tagCreateController = TextEditingController();

    this._searchContactsController = TextEditingController();

    if (widget.workshopData != null) {
      if (widget.workshopData.image_url != null &&
          widget.workshopData.image_url.isNotEmpty) {
        this._oldImage = NetworkImage(widget.workshopData.image_url);
      }

      this._titleController.text = widget.workshopData.title;
      this._descriptionController.text = widget.workshopData.description;
      this._editingDate = widget.workshopData.date;
      this._editingTime = widget.workshopData.time;
      this._locationController.text = widget.workshopData.location;
      this._audienceController.text = widget.workshopData.audience;
      _workshop = WorkshopCreater(
          editingDate: this._editingDate, editingTime: this._editingTime);

      for (var contact in widget.workshopData.contacts) {
        this._workshop.contactIds.add(contact.id);
        this._workshop.contactNameofId[contact.id] =
            WorkshopCreater.nameOfContact(contact.name);
      }
      for (var tag in widget.workshopData.tags) {
        this._workshop.tagNameofId[tag.id] = tag.tag_name;
      }
      this._workshop.latitude = widget.workshopData.latitude;
      this._workshop.longitude = widget.workshopData.longitude;
      this._workshop.is_workshop = widget.workshopData.is_workshop;
    } else {
      _workshop = WorkshopCreater();
      this._workshop.is_workshop = widget.isWorkshopOrEvent == 'workshop';
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
                child: Text('Ok.'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  tagCreateDialog() async {
    final GlobalKey<FormState> _tagFormKey = GlobalKey<FormState>();
    bool errorMessageShown = false;
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, refreshState) {
          return AlertDialog(
              content: Form(
                key: _tagFormKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: this._tagCreateController,
                        validator: (value) {
                          if (value == '') {
                            return 'The tag cannot be empty';
                          }
                          if (value.length > 50) {
                            return 'Must be less than 50 characters';
                          }
                          return null;
                        },
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
                        final tagForm = _tagFormKey.currentState;
                        if (tagForm.validate()) {
                          tagForm.save();
                          print(this._tagCreateController.text);
                          final newTag = TagCreate((b) =>
                              b..tag_name = this._tagCreateController.text);

                          await (_isEntity
                                  ? AppConstants.service.createEntityTag(
                                      widget.entity.id,
                                      AppConstants.djangoToken,
                                      newTag)
                                  : AppConstants.service.createClubTag(
                                      widget.club.id,
                                      AppConstants.djangoToken,
                                      newTag))
                              .then((value) {
                            if (value != null) {
                              tagAlertDialog('Tag Created',
                                  'The Tag has been created for ${_isEntity ? widget.entity.name : widget.club.name} succesfully. Search for it again, and add it to the ${widget.isWorkshopOrEvent} if you wish.');

                              refreshState(
                                  () => this._tagCreateController.clear());
                            } else if (errorMessageShown == false) {
                              tagAlertDialog('Error',
                                  'There was an error creating this tag.');
                            }
                          }).catchError((onError) {
                            if (onError is InternetConnectionException) {
                              AppConstants.internetErrorFlushBar
                                  .showFlushbar(context);
                              return;
                            }

                            final error = onError as Response<dynamic>;
                            print(error.body);
                            if (error.body
                                .toString()
                                .contains('The tag already exists for this')) {
                              tagAlertDialog('Tag Exists',
                                  'This tag already exists. Search for it if you wish to add it to the ${widget.isWorkshopOrEvent}.');
                              errorMessageShown = true;
                              refreshState(
                                  () => this._tagCreateController.clear());
                            }
                            print(
                                'Error while creating Tag: ${onError.toString()} ${onError.runtimeType}');
                          });
                        }
                      },
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok.'),
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

  tagDeleteDialog(String tagName) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, refreshState) {
            return AlertDialog(
              title: Text(
                  'PERMANENTLY Delete Tag for ${_isEntity ? widget.entity.name : widget.club.name}'),
              content: Text(
                  '''Are you sure you want to delete this tag for this club?\nNote that this option is NOT to be used to remove the tag for the ${widget.isWorkshopOrEvent}.\nThis is to permanently delete this tag for ${_isEntity ? widget.entity.name : widget.club.name}.'''),
              actions: <Widget>[
                FlatButton(
                  child: Text('No.'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('Yes.'),
                  onPressed: () async {
                    final deleteTag = TagDelete((b) => b..tag_name = tagName);
                    await (_isEntity
                            ? AppConstants.service.deleteEntityTag(
                                widget.entity.id,
                                AppConstants.djangoToken,
                                deleteTag)
                            : AppConstants.service.deleteClubTag(widget.club.id,
                                AppConstants.djangoToken, deleteTag))
                        .then((value) async {
                      if (value != null) {
                        await tagAlertDialog('Tag Deleted',
                            'The Tag has been deleted from ${_isEntity ? widget.entity.name : widget.club.name} succesfully.');
                        refreshState(() {});
                      }
                    }).catchError((onError) {
                      if (onError is InternetConnectionException) {
                        AppConstants.internetErrorFlushBar
                            .showFlushbar(context);
                        return;
                      }

                      final error = onError as Response<dynamic>;
                      print(error.body);
                      print(
                          'Error while deleting Tag: ${onError.toString()} ${onError.runtimeType}');
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
        });
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

  Future<bool> _onWillPop() async {
    FocusScope.of(context).unfocus();
    final res = await CreatePageDialogBoxes.confirmDialog(
        context: context, title: 'Exit', action: 'Exit');
    return res == true ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        minimum: const EdgeInsets.all(2.0),
        child: Scaffold(
          // backgroundColor: ColorConstants.homeBackground,
          appBar: AppBar(
              backgroundColor: ColorConstants.homeBackground,
              title: widget.workshopData == null
                  ? Text(_workshop.is_workshop
                      ? 'Create Workshop'
                      : 'Create Event')
                  : Text(
                      _workshop.is_workshop ? 'Edit Workshop' : 'Edit Event')),
          body: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Builder(
              builder: (context) => Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Text(
                      widget.title,
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
                                    ? (_newImage == null
                                        ? null
                                        : DecorationImage(image: _newImage))
                                    : DecorationImage(image: this._oldImage),
                              ),
                              child: InkWell(
                                  onTap: _pickImage,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(child: Icon(Icons.add, size: 40)),
                                      _newImage == null
                                          ? Text(
                                              'By default, ${_isEntity ? widget.entity.name : widget.club.name}\'s logo will be shown')
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
                      decoration: InputDecoration(
                          labelText: _workshop.is_workshop
                              ? 'Title of the Workshop'
                              : 'Title of the Event'),
                      controller: this._titleController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter the title';
                        }
                        if (value.length > 50) {
                          return 'The title cannot be longer than 50 characters';
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
                            return 'Please describe the ${widget.isWorkshopOrEvent} in detail.';
                          }
                          return null;
                        },
                        onSaved: (val) =>
                            setState(() => _workshop.description = val)),
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
                              validator: (value) {
                                if (value.length > 100) {
                                  return 'The location cannot be longer than 100 characters';
                                }
                                return null;
                              },
                              onSaved: (val) => _workshop.location = val),
                        ),
                        this._workshop.latitude != null &&
                                this._workshop.latitude != ''
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
                            final location = await Navigator.of(context)
                                    .pushNamed('/mapPage',
                                        arguments: {'fromWorkshopCreate': true})
                                as List<String>;
                            this._workshop.latitude =
                                location == null ? null : location[0];
                            this._workshop.longitude =
                                location == null ? null : location[1];
                            _locationController.text = location == null
                                ? _locationController.text
                                : location[2];
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    this._workshop.latitude != null &&
                            this._workshop.longitude != null
                        ? Text(
                            '${this._workshop.latitude}, ${this._workshop.longitude}')
                        : Container(),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Audience',
                        hintText:
                            'Who should attend the ${widget.isWorkshopOrEvent}?',
                      ),
                      controller: this._audienceController,
                      validator: (value) {
                        if (value.length > 100) {
                          return 'The audience cannot be longer than 100 characters';
                        }
                        return null;
                      },
                      onSaved: (val) => _workshop.audience = val,
                    ),
                    Form(
                      key: this._searchContactFormKey,
                      child: Row(
                        children: <Widget>[
                          _searchCategoryDropDown(),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText:
                                      'Search contacts by ${this._searchByValue}'),
                              onFieldSubmitted: (value) async {
                                if (value.isEmpty) return;

                                if (!this
                                    ._searchContactFormKey
                                    .currentState
                                    .validate()) return;

                                this._searchPost = BuiltProfileSearchPost((b) =>
                                    b
                                      ..search_by = this._searchByValue
                                      ..search_string =
                                          this._searchContactsController.text);

                                if (!this.mounted) return;
                                setState(() {
                                  this._isSearchingContacts = true;
                                  this._searchedDataFetched = false;

                                  this._searchedProfileresult = null;
                                });
                                await AppConstants.service
                                    .searchProfile(AppConstants.djangoToken,
                                        this._searchPost)
                                    .then((result) {
                                  if (result != null)
                                    this._searchedProfileresult = result.body;
                                }).catchError((onError) {
                                  if (onError is InternetConnectionException) {
                                    AppConstants.internetErrorFlushBar
                                        .showFlushbar(context);
                                    return;
                                  }
                                  print(
                                      'Error while fetching search results: $onError');
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
                                      int _id =
                                          this._workshop.contactIds[index];
                                      return Container(
                                        padding: EdgeInsets.all(2),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(this
                                                ._workshop
                                                .contactNameofId[_id]),
                                            InkWell(
                                              splashColor: Colors.red,
                                              onTap: () {
                                                setState(() {
                                                  this
                                                      ._workshop
                                                      .contactIds
                                                      .remove(_id);
                                                  this
                                                      ._workshop
                                                      .contactNameofId
                                                      .remove(_id);
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
                    Row(children: [
                      Expanded(
                        child: TextFormField(
                          controller: this._tagSearchController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
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

                            this._tagSearchPost = TagSearch((b) =>
                                b..tag_name = this._tagSearchController.text);

                            if (!this.mounted) return;
                            setState(() {
                              this._isSearchingTags = true;
                              this._tagDataFetched = false;
                              this._searchedTagResult = null;
                              this._allTagDataShow = false;
                            });
                            await (_isEntity
                                    ? AppConstants.service.searchEntityTag(
                                        widget.entity.id,
                                        AppConstants.djangoToken,
                                        this._tagSearchPost)
                                    : AppConstants.service.searchClubTag(
                                        widget.club.id,
                                        AppConstants.djangoToken,
                                        this._tagSearchPost))
                                .then((result) {
                              if (result != null)
                                this._searchedTagResult = result.body;
                            }).catchError((onError) {
                              if (onError is InternetConnectionException) {
                                AppConstants.internetErrorFlushBar
                                    .showFlushbar(context);
                                return;
                              }
                              print('Error while fetching tags $onError');
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
                                this._allTagsOfClubOrEntity = null;
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
                                if (!_isEntity) {
                                  await AppConstants.service
                                      .getClubTags(widget.club.id,
                                          AppConstants.djangoToken)
                                      .then((result) {
                                    if (result != null) {
                                      this._allTagsOfClubOrEntity =
                                          result.body.club_tags;
                                      this._allTagDataShow = true;
                                      this._allTagDataFetched = true;
                                      setState(() {});
                                    }
                                  }).catchError((onError) {
                                    if (onError
                                        is InternetConnectionException) {
                                      AppConstants.internetErrorFlushBar
                                          .showFlushbar(context);
                                      return;
                                    }
                                    print(
                                        'Error while fetching all tags $onError');
                                  });
                                } else {
                                  await AppConstants.service
                                      .getEntityTags(widget.entity.id,
                                          AppConstants.djangoToken)
                                      .then((result) {
                                    if (result != null) {
                                      this._allTagsOfClubOrEntity =
                                          result.body.entity_tags;
                                      this._allTagDataShow = true;
                                      this._allTagDataFetched = true;
                                      setState(() {});
                                    }
                                  }).catchError((onError) {
                                    if (onError
                                        is InternetConnectionException) {
                                      AppConstants.internetErrorFlushBar
                                          .showFlushbar(context);
                                      return;
                                    }
                                    print(
                                        'Error while fetching all tags $onError');
                                  });
                                }
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
                                  maxHeight:
                                      MediaQuery.of(context).size.height / 10,
                                ),
                                child: this._isSearchingTags
                                    ? _buildTagsFromSearchPosts(context)
                                    : this._allTagDataShow
                                        ? _buildAllTagsOfClubOrEntity(context)
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
                                    itemCount:
                                        this._workshop.tagNameofId.keys.length,
                                    itemBuilder: (context, index) {
                                      int _id = this
                                          ._workshop
                                          .tagNameofId
                                          .keys
                                          .toList()[index];
                                      return Container(
                                        padding: EdgeInsets.all(2),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(this
                                                ._workshop
                                                .tagNameofId[_id]),
                                            InkWell(
                                              child: Icon(Icons.cancel),
                                              splashColor: Colors.red,
                                              onTap: () {
                                                setState(() {
                                                  this
                                                      ._workshop
                                                      .tagNameofId
                                                      .remove(_id);
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 64.0),
                      child: RaisedButton(
                        color: ColorConstants.homeBackground,
                        onPressed: () async {
                          final form = _formKey.currentState;
                          if (form.validate()) {
                            form.save();

                            bool isconfirmed =
                                await CreatePageDialogBoxes.confirmDialog(
                                    context: context,
                                    title: widget.workshopData == null
                                        ? 'Create'
                                        : 'Edit',
                                    action: widget.workshopData == null
                                        ? 'Create'
                                        : 'Edit');

                            if (isconfirmed == false || isconfirmed == null)
                              return;

                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: widget.workshopData == null
                                    ? Text('Creating ...')
                                    : Text('Editing ...'),
                              ),
                            );

                            if (widget.workshopData == null) {
                              // if creation is successfull , then automatically user will reach at homePage.
                              await _workshop.create(
                                  context: context,
                                  club: widget.club,
                                  entity: widget.entity,
                                  image: _newImage);
                            } else {
                              final success = await _workshop.edit(
                                context: context,
                                widgetWorkshopData: widget.workshopData,
                                oldImage: _oldImage,
                                newImage: _newImage,
                              );

                              if (success == true)
                                Navigator.of(context).pop(true);
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
                child: (this._searchedProfileresult == null ||
                        this._searchedProfileresult.isEmpty)
                    ? Center(
                        child: Text(
                          'No such Contact.',
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
                          bool _isAdded = this
                              ._workshop
                              .contactIds
                              .contains(_searchedProfileresult[index].id);

                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3, vertical: 10),
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
                                        image: (_searchedProfileresult[index]
                                                        .photo_url ==
                                                    null ||
                                                _searchedProfileresult[index]
                                                    .photo_url
                                                    .isEmpty)
                                            ? Image.asset(
                                                'assets/profile_test.jpg')
                                            : NetworkImage(
                                                _searchedProfileresult[index]
                                                    .photo_url),
                                      )),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 10.0),
                                      child: Column(
                                        children: <Widget>[
                                          Text(_searchedProfileresult[index]
                                              .name),
                                          Text(_searchedProfileresult[index]
                                              .email),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: OutlineButton(
                                      onPressed: () {
                                        int _id =
                                            _searchedProfileresult[index].id;
                                        String _name =
                                            WorkshopCreater.nameOfContact(
                                                _searchedProfileresult[index]
                                                    .name);

                                        if (_isAdded) {
                                          _isAdded = false;
                                          this._workshop.contactIds.remove(_id);
                                          this
                                              ._workshop
                                              .contactNameofId
                                              .remove(_id);
                                        } else {
                                          _isAdded = true;
                                          this._workshop.contactIds.add(_id);
                                          this._workshop.contactNameofId[_id] =
                                              _name;
                                        }
                                        if (!this.mounted) return;
                                        setState(() {});
                                      },
                                      child: Icon(
                                          _isAdded ? Icons.remove : Icons.add),
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
            child: (this._searchedTagResult == null ||
                    this._searchedTagResult.isEmpty)
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
                            Flexible(
                              child: Text(
                                  this._searchedTagResult[index].tag_name,
                                  maxLines: 1),
                            ),
                            InkWell(
                              child: (this
                                      ._workshop
                                      .tagNameofId
                                      .keys
                                      .contains(_id))
                                  ? Icon(Icons.close)
                                  : Icon(Icons.add),
                              splashColor: Colors.green,
                              onTap: () {
                                setState(() {
                                  if (this
                                      ._workshop
                                      .tagNameofId
                                      .keys
                                      .contains(_id))
                                    this._workshop.tagNameofId.remove(_id);
                                  else
                                    this._workshop.tagNameofId[_id] =
                                        this._searchedTagResult[index].tag_name;
                                });
                              },
                            ),
                            InkWell(
                              child: (Icon(
                                Icons.delete_forever_sharp,
                                color: Colors.red,
                              )),
                              splashColor: Colors.red,
                              onTap: () {
                                setState(() async {
                                  await tagDeleteDialog(
                                      this._searchedTagResult[index].tag_name);
                                  if (this
                                      ._workshop
                                      .tagNameofId
                                      .keys
                                      .contains(_id))
                                    this._workshop.tagNameofId.remove(_id);
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

  Widget _buildAllTagsOfClubOrEntity(
    BuildContext context,
  ) {
    return this._allTagDataFetched
        ? Container(
            child: (this._allTagsOfClubOrEntity == null ||
                    this._allTagsOfClubOrEntity.isEmpty)
                ? Center(
                    child: Text(
                      'No Tags of ${_isEntity ? widget.entity.name : widget.club.name} available',
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
                    itemCount: this._allTagsOfClubOrEntity.length,
                    padding: EdgeInsets.all(2),
                    itemBuilder: (context, index) {
                      int _id = this._allTagsOfClubOrEntity[index].id;
                      return Container(
                        padding: EdgeInsets.all(2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                  this._allTagsOfClubOrEntity[index].tag_name,
                                  maxLines: 1),
                            ),
                            InkWell(
                              child: (this
                                      ._workshop
                                      .tagNameofId
                                      .keys
                                      .contains(_id))
                                  ? Icon(Icons.close)
                                  : Icon(Icons.add),
                              splashColor: (this
                                      ._workshop
                                      .tagNameofId
                                      .keys
                                      .contains(_id))
                                  ? Colors.red
                                  : Colors.green,
                              onTap: () {
                                setState(() {
                                  if (this
                                      ._workshop
                                      .tagNameofId
                                      .keys
                                      .contains(_id))
                                    this._workshop.tagNameofId.remove(_id);
                                  else
                                    this._workshop.tagNameofId[_id] = this
                                        ._allTagsOfClubOrEntity[index]
                                        .tag_name;
                                });
                              },
                            ),
                            InkWell(
                              child: (Icon(
                                Icons.delete_forever_sharp,
                                color: Colors.red,
                              )),
                              splashColor: Colors.red,
                              onTap: () async {
                                await tagDeleteDialog(this
                                    ._allTagsOfClubOrEntity[index]
                                    .tag_name);
                                setState(() {
                                  if (this
                                      ._workshop
                                      .tagNameofId
                                      .keys
                                      .contains(_id))
                                    this._workshop.tagNameofId.remove(_id);
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
