import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/pages/council/councilPage.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';

Widget homeFAB(context, {fabKey}) => AppConstants.councilsSummaryfromDatabase == null
    ? FloatingActionButton(onPressed: null, child: Icon(Icons.menu))
    : FabCircularMenu(
        key: fabKey,
        ringColor: ColorConstants.circularRingBackground,
        ringDiameter: 400,
        ringWidth: 90,
        fabSize: 65,
        // animationDuration: Duration(milliseconds: 500),
        fabOpenColor: Colors.red,
        children: AppConstants.councilsSummaryfromDatabase.map((council) {
          File _imageFile =
              AppConstants.getImageFile(isCouncil: true, isSmall: true, id: council.id);
          return InkWell(
            onTap: () {
              // setting councilId in AppConstnts
              AppConstants.currentCouncilId = council.id;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CouncilPage(),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: _imageFile != null
                      ? FileImage(_imageFile)
                      : NetworkImage(council.small_image_url),
                  fit: BoxFit.fill,
                ),
              ),
              height: 50,
              width: 50,
            ),
          );
        }).toList());
