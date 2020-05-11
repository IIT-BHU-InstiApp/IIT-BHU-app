import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/screens/home/search_workshop.dart';
import 'notification.dart';

AppBar homeAppBar(context, {SearchBarWidget searchBarWidget}) => AppBar(
      backgroundColor: ColorConstants.homeBackground,
      automaticallyImplyLeading: false,
      elevation: 0,
      actions: <Widget>[
        Flexible(
          child: Container(
            padding: EdgeInsets.fromLTRB(15, 8, 15, 0),
            child: Card(
              elevation: 5.0,
              color: ColorConstants.homeBackground,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 5, right: 10),
                    height: 35.0,
                    width: 35.0,
                    child: Builder(
                      builder: (context) => GestureDetector(
                        onTap: () => Scaffold.of(context).openDrawer(),
                        child: AppConstants.isGuest
                            ? Icon(Icons.menu)
                            : Container(),
                      ),
                    ),
                    decoration: BoxDecoration(
                      image: AppConstants.isGuest
                          ? BoxDecoration()
                          : DecorationImage(
                              image: AppConstants.currentUser == null
                                  ? AssetImage('assets/profile_test.jpg')
                                  : NetworkImage(
                                      AppConstants.currentUser.photoUrl),
                              fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  Expanded(child: searchBarWidget.getSearchTextField(context)),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8),
                    child: Container(
                      child: InkWell(
                        child: Icon(Icons.notifications_active,
                            color: Colors.black),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => NotificationScreen()),
                          );
                        },
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
