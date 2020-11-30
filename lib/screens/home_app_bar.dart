import 'package:flutter/material.dart';
import 'package:iit_app/external_libraries/fab_circular_menu.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/ui/search_workshop.dart';

import 'interestedScreen.dart';

AppBar homeAppBar(context,
        {SearchBarWidget searchBarWidget,
        GlobalKey<FabCircularMenuState> fabKey,
        FocusNode searchFocusNode}) =>
    AppBar(
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
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                          if (fabKey.currentState.isOpen) {
                            fabKey.currentState.close();
                          }
                        },
                        child: AppConstants.isGuest
                            ? Icon(
                                Icons.menu,
                                color: ColorConstants.textColor,
                              )
                            : null,
                      ),
                    ),
                    decoration: AppConstants.isGuest
                        ? BoxDecoration()
                        : BoxDecoration(
                            image: DecorationImage(
                                image: AppConstants.currentUser == null ||
                                        AppConstants.currentUser.photo_url == ''
                                    ? AssetImage('assets/guest.png')
                                    : NetworkImage(
                                        AppConstants.currentUser.photo_url),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                  ),
                  Expanded(
                      child: searchBarWidget.getSearchTextField(context,
                          fabKey: fabKey, searchFocusNode: searchFocusNode)),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8),
                    child: Container(
                      child: InkWell(
                        child: Icon(
                          Icons.star_half_rounded,
                          color: ColorConstants.textColor,
                          size: 35,
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => InterestedScreen()),
                          );
                          if (fabKey.currentState.isOpen) {
                            fabKey.currentState.close();
                          }
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
