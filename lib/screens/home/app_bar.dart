import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/screens/home/search_workshop.dart';

AppBar homeAppBar(context, {SearchBarWidget searchBarWidget}) => AppBar(
      backgroundColor: Colors.blue[200],
      automaticallyImplyLeading: false,
      elevation: 0,
      actions: <Widget>[
        Flexible(
          child: Container(
            padding: EdgeInsets.fromLTRB(15, 8, 15, 0),
            child: Card(
              elevation: 5.0,
              color: Colors.blue[200],
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 5, right: 10),
                    height: 35.0,
                    width: 35.0,
                    child: Builder(
                      builder: (context) => GestureDetector(
                          onTap: () => Scaffold.of(context).openDrawer()),
                    ),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AppConstants.currentUser == null
                                ? AssetImage('assets/profile_test.jpg')
                                : NetworkImage(
                                    AppConstants.currentUser.photoUrl),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(50.0)),
                  ),
                  Expanded(child: searchBarWidget.getSearchTextFeild(context)),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8),
                    child: Container(
                      child: InkWell(
                        child: Icon(Icons.notifications_active,
                            color: Colors.black),
                        onTap: () {},
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
