import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iit_app/external_libraries/fab_circular_menu.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/pages/council/councilPage.dart';

Widget homeFAB(context, {fabKey}) =>
    AppConstants.councilsSummaryfromDatabase == null
        ? FloatingActionButton(onPressed: null, child: Icon(Icons.menu))
        : FabCircularMenu(
            key: fabKey,
            ringColor: ColorConstants.circularRingBackground,
            ringDiameter: 400,
            ringWidth: 84,
            fabSize: 65,
            innerRingDiameter: 240,
            innerRingWidth: 60,
            // animationDuration: Duration(milliseconds: 500),
            fabOpenColor: Colors.red,
            children: AppConstants.councilsSummaryfromDatabase
                .map((council) => _fabButtons(context, 52,
                    council: council,
                    entity: null,
                    imageUrl: council.small_image_url))
                .toList(),

            innerRingChildren: AppConstants.entitiesSummaryFromDatabase
                // .where((entity) =>entity.is_permanent == true ) //TODO: uncomment this line when appropriate fields are added to model
                .map((entity) => _fabButtons(context, 52,
                    council: null,
                    entity: entity,
                    imageUrl: entity.small_image_url))
                .toList(),
          );

Widget _fabButtons(BuildContext context, double size,
    {@required BuiltAllCouncilsPost council,
    @required EntityListPost entity,
    @required String imageUrl}) {
  int nullCounter = 0;
  if (council == null) nullCounter++;
  if (entity == null) nullCounter++;
  assert(nullCounter == 1);

  File _imageFile;
  if (council != null) {
    _imageFile = AppConstants.getImageFile(
        isCouncil: true, isSmall: true, id: council.id);
  } else {
    _imageFile =
        AppConstants.getImageFile(isSmall: true, id: entity.id, isEntity: true);
  }

  return GestureDetector(
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
      padding: const EdgeInsets.all(0),
      // color: Colors.blue,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: _imageFile != null
                ? FileImage(_imageFile)
                : imageUrl?.isEmpty != false
                    ? AssetImage('assets/iitbhu.jpeg')
                    : NetworkImage(imageUrl),
            fit: BoxFit.fill,
          ),
        ),
        height: size,
        width: size,
      ),
    ),
  );
}
