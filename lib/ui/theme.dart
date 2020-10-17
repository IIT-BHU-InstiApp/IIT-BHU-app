import 'package:flutter/material.dart';

import '../model/colorConstants.dart';

class AppTheme {
 static dark() {
    ColorConstants.homeBackground = Colors.blue[200];
    ColorConstants.circularRingBackground = Colors.blue.withOpacity(0.8);
    ColorConstants.shimmerSkeletonColor = Colors.grey[300];
    ColorConstants.workshopContainerBackground = Color(0xFF736AB7);
    ColorConstants.workshopCardContainer = Color(0xFF333366);
    ColorConstants.backgroundThemeColor = Color(0xFF736AB7);
    ColorConstants.panelColor = Colors.white;
    ColorConstants.headingColor = Color(0xFF736AB7);
    ColorConstants.porHolderBackground = Colors.grey[300];
    ColorConstants.allWorkshopsBackground = Colors.white;
    ColorConstants.accountScreenBackground = Colors.white;
    ColorConstants.settingBackground = Colors.white;
  }

  //TODO - Add relevent colors - variable according to theme
static  light() {
    ColorConstants.homeBackground = Color(0xff95d8ea);
    ColorConstants.circularRingBackground = Colors.black.withOpacity(0.2);
    ColorConstants.shimmerSkeletonColor = Color(0xff95d8ea);
    ColorConstants.workshopContainerBackground = Color(0xff95d8ea);
    ColorConstants.workshopCardContainer = Color(0xfffec647);
    ColorConstants.backgroundThemeColor = Color(0xFF736AB7);
    ColorConstants.panelColor = Color(0xff5dbcd2);
    ColorConstants.headingColor = Color(0xFF5dbcd2);
    ColorConstants.porHolderBackground = Color(0xff5dbcd2);
    ColorConstants.allWorkshopsBackground = Color(0xff5dbcd2);
    ColorConstants.accountScreenBackground = Color(0xff5dbcd2);
    ColorConstants.settingBackground = Color(0xff5dbcd2);
  }
}
