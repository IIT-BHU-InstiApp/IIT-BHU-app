import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iit_app/external_libraries/fab_circular_menu.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/pages/council/councilPage.dart';
import 'package:iit_app/pages/club_entity/entityPage.dart';

Widget homeFAB(context, {fabKey}) =>
    AppConstants.councilsSummaryfromDatabase == null
        ? FloatingActionButton(onPressed: null, child: Icon(Icons.menu))
        : FabCircularMenu(
            key: fabKey,
            ringColor: ColorConstants.circularRingBackground,
            ringDiameter: 400,
            ringWidth: 75,
            fabSize: 45,
            innerRingDiameter: 200,
            innerRingWidth: 55,
            // animationDuration: Duration(milliseconds: 500),
            fabOpenColor: Colors.red,
            children: AppConstants.councilsSummaryfromDatabase
                    ?.map((council) => _fabButtons(context, 50,
                        council: council,
                        entity: null,
                        imageUrl: council.small_image_url))
                    ?.toList() ??
                [],

            innerRingChildren: AppConstants.entitiesSummaryFromDatabase
                    ?.where((entity) => entity.is_permanent == true)
                    ?.map((entity) => _fabButtons(context, 42,
                        council: null,
                        entity: entity,
                        imageUrl: entity.small_image_url))
                    ?.toList() ??
                [],
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
    _imageFile = AppConstants.getImageFile(council.small_image_url);
  } else {
    _imageFile = AppConstants.getImageFile(entity.small_image_url);
  }

  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => council != null
              ? CouncilPage(council.id)
              : EntityPage(entityId: entity.id),
        ),
      );
    },
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
  );
}
