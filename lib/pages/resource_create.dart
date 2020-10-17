import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';

class ResourceCreateScreen extends StatefulWidget {
  @override
  BuiltWorkshopDetailPost workshop;
  int id;
  ResourceCreateScreen(@required this.workshop, [this.id]);
  _ResourceCreateScreenState createState() => _ResourceCreateScreenState();
}

class _ResourceCreateScreenState extends State<ResourceCreateScreen> {
  bool editMode;
  WorkshopResources _fetchedResources = WorkshopResources();
  WorkshopResources _resources = WorkshopResources();
  String name;
  String link;
  String resource_type;

  _ResourceCreateScreenState();

  @override
  final _resourceFormKey = GlobalKey<FormState>();
  TextEditingController _nameController;
  TextEditingController _linkController;
  TextEditingController _resource_typeController;

  void initState() {
    this._nameController = TextEditingController();
    this._linkController = TextEditingController();
    this._resource_typeController = TextEditingController();
    editMode = (widget.id != null) ? true : false;
    if (editMode) {
      _fetchedResources = getResourceById(widget.id);
      this._nameController.text = _fetchedResources.name;
      this._linkController.text = _fetchedResources.link;
      this._resource_typeController.text = _fetchedResources.resource_type;
    }

    super.initState();
  }

  WorkshopResources getResourceById(int id) {
    for (int i = 0; i < widget.workshop.resources.length; i++) {
      if (widget.workshop.resources[i].id == id) {
        return widget.workshop.resources[i];
      }
    }
  }

  createResource({
    @required BuildContext context,
    @required WorkshopResources resource,
  }) async {
    bool done = false;
    print(resource.name);
    print(resource.link);
    print(resource.id);
    print(widget.workshop.id);
    await AppConstants.service
        .postNewResource(widget.workshop.id, AppConstants.djangoToken, resource)
        .catchError((onError) {
      final error = onError as Response<dynamic>;
      print(error.body);
      print(
          'Error creating resource: ${onError.toString()} ${onError.runtimeType}');
    }).then((value) {
      if(value.isSuccessful) {
        done = true;
      }
    }).catchError((onError) {
      print('Error printing CREATED resource: ${onError.toString()}');
    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(content: done
              ? Text("Succesfully added")
              : Text("UnSuccessful. Please try again"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Okay"),
                  onPressed: () => {
                    if (done)
                      {
                        Navigator.pop(context),
                        Navigator.pop(context),
                        Navigator.pop(context),
                      }
                    else
                      {Navigator.pop(context)}
                  },
            )
          ]);
        });
  }

  editResource({
    @required BuildContext context,
    @required WorkshopResources resource,
    @required int id,
  }) async {
    bool done = false;
    await AppConstants.service
        .updateWorkshopResourcesByPatch(
            widget.id, AppConstants.djangoToken, resource)
        .catchError((onError) {
          final error = onError as Response<dynamic>;
          print(error.body);
          print(
              'Error editing resource: ${onError.toString()} ${onError.runtimeType}');
        })
        .then((value) {
      if(value.isSuccessful) {
        done = true;
      }
    })
        .catchError((onError) {
          print('Error printing edited resource: ${onError.toString()}');
        });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: done
                  ? Text("Succesfully edited")
                  : Text("UnSuccessful! Please try again"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Okay"),
                  onPressed: () => {
                    if (done)
                      {
                        Navigator.pop(context),
                        Navigator.pop(context),
                        Navigator.pop(context),
                      }
                    else
                      {Navigator.pop(context)}
                  },
                )
              ]);
        });
  }

  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(5.0),
      child: Scaffold(
        appBar: AppBar(title: Text("Add and edit resources")),
        body: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: _resourceFormKey,
            child: ListView(
              children: [
                TextFormField(
                  autovalidate: true,
                  decoration:
                      InputDecoration(labelText: 'Name of the resource'),
                  controller: this._nameController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter the name of the resource';
                    }
                    return null;
                  },
                  onSaved: (val) => setState(() => name = val),
                ),
                TextFormField(
                  autovalidate: true,
                  decoration: InputDecoration(labelText: 'Link'),
                  controller: this._linkController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some resource link';
                    }
                    return null;
                  },
                  onSaved: (val) => setState(() => link = val),
                ),
                TextFormField(
                  autovalidate: true,
                  decoration: InputDecoration(
                      labelText: 'Resource type(Prerequisite/Material)'),
                  controller: this._resource_typeController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter the resource type';
                    }
                    return null;
                  },
                  onSaved: (val) => setState(() => resource_type = val),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: RaisedButton(
                      child: Text(editMode ? "Edit Resource" : "Add Resource"),
                      onPressed: () async {
                        final form = _resourceFormKey.currentState;
                        if (form.validate()) {
                          form.save();

                          this._resources = WorkshopResources((b) => b
                            ..name = name
                            ..link = link
                            ..resource_type = resource_type);

                          FutureBuilder<int>(
                            future: editMode
                                ? editResource(
                                    context: context,
                                    resource: _resources,
                                    id: widget.id)
                                : createResource(
                                    context: context, resource: _resources),
                            builder: (BuildContext context,
                                AsyncSnapshot<int> snapshot) {
                              if (snapshot.hasData) {
                                return Text('${snapshot.data}');
                              }
                              return Container();
                            },
                          );
                          SnackBar(
                              content: editMode
                                  ? Text("Editing resource")
                                  : Text("Creating Resource"));
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
