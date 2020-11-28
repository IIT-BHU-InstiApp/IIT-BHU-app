import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';

class ResourceCreateScreen extends StatefulWidget {
  @override
  BuiltWorkshopDetailPost workshop;
  int id;
  ResourceCreateScreen(this.workshop, [this.id]);
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

  final _resourceFormKey = GlobalKey<FormState>();
  TextEditingController _nameController;
  TextEditingController _linkController;

  @override
  void initState() {
    this._nameController = TextEditingController();
    this._linkController = TextEditingController();
    editMode = (widget.id != null) ? true : false;
    if (editMode) {
      _fetchedResources = getResourceById(widget.id);
      this._nameController.text = _fetchedResources.name;
      this._linkController.text = _fetchedResources.link;
      this.resource_type = _fetchedResources.resource_type;
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  WorkshopResources getResourceById(int id) {
    for (int i = 0; i < widget.workshop.resources.length; i++) {
      if (widget.workshop.resources[i].id == id) {
        return widget.workshop.resources[i];
      }
    }
    return null;
  }

  Future<bool> createResource({
    @required BuildContext context,
    @required WorkshopResources resource,
  }) async {
    bool done = false;

    await AppConstants.service
        .createResource(widget.workshop.id, AppConstants.djangoToken, resource)
        .then((value) {
      if (value.isSuccessful) {
        done = true;
      }
    }).catchError((onError) {
      print('Error printing CREATED resource: ${onError.toString()}');
    });
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
              content: done
                  ? Text("Succesfully added")
                  : Text("Unsuccessful. Please try again"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Okay"),
                  onPressed: () => Navigator.pop(context),
                )
              ]);
        });
    return done;
  }

  Future<bool> editResource({
    @required BuildContext context,
    @required WorkshopResources resource,
    @required int id,
  }) async {
    bool done = false;
    await AppConstants.service
        .updateWorkshopResourcesByPatch(
            widget.id, AppConstants.djangoToken, resource)
        .then((value) {
      if (value.isSuccessful) {
        done = true;
      }
    }).catchError((onError) {
      print('Error printing edited resource: ${onError.toString()}');
    });
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: done
                  ? Text("Succesfully edited")
                  : Text("Unsuccessful! Please try again"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Okay"),
                  onPressed: () => Navigator.pop(context),
                )
              ]);
        });
    return done;
  }

  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(5.0),
      child: Scaffold(
        appBar:
            AppBar(title: Text(editMode ? "Edit Resources" : "Add Resources")),
        body: Builder(builder: (context) {
          return Container(
            padding: EdgeInsets.all(15),
            child: Form(
              key: _resourceFormKey,
              child: ListView(
                children: [
                  TextFormField(
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
                    decoration: InputDecoration(labelText: 'Link'),
                    controller: this._linkController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some resource link';
                      }
                      if (!value.startsWith("https://") &&
                          !value.startsWith("http://")) {
                        return 'The link must begin with https:// or http://';
                      }
                      return null;
                    },
                    onSaved: (val) => setState(() => link = val),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  resource_type == null
                      ? Container()
                      : Text("Resource type",
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Container(
                    height: 75,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButton(
                            isExpanded: true,
                            hint: Text("Resource type"),
                            value: resource_type,
                            iconSize: 30,
                            underline: Container(
                              height: 1,
                              color: resource_type == null
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            items: [
                              DropdownMenuItem(
                                child: Text("Prerequisite"),
                                value: "Prerequisite",
                              ),
                              DropdownMenuItem(
                                child: Text("Material"),
                                value: "Material",
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                resource_type = value;
                              });
                            }),
                        resource_type == null
                            ? Text(
                                "Please choose a resource type",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 12),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16.0),
                    child: RaisedButton(
                        child:
                            Text(editMode ? "Edit Resource" : "Add Resource"),
                        onPressed: () async {
                          final form = _resourceFormKey.currentState;
                          if (form.validate()) {
                            form.save();

                            this._resources = WorkshopResources((b) => b
                              ..name = name
                              ..link = link
                              ..resource_type = resource_type);

                            final success = await (editMode
                                ? editResource(
                                    context: context,
                                    resource: _resources,
                                    id: widget.id)
                                : createResource(
                                    context: context, resource: _resources));

                            if (success) Navigator.of(context).pop(true);

                            Scaffold.of(context).showSnackBar(SnackBar(
                                content: editMode
                                    ? Text("Editing resource")
                                    : Text("Creating Resource")));
                          }
                        }),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
