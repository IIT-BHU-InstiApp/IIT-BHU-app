import 'package:flutter/material.dart';

// TODO: a set of final colors for light and dark theme
// TODO: maintain shadow colors
class ColorConstants {
  static Color homeBackground;
  static Color circularRingBackground;
  static Color shimmerSkeletonColor;
  static Color workshopContainerBackground;
  static Color workshopCardContainer;

  static Color backgroundThemeColor;
  static Color panelColor;
  static Color headingColor;
  static Color porHolderBackground;


  static light() {
    ColorConstants.homeBackground = Colors.blue[200];
    ColorConstants.circularRingBackground = Colors.blue.withOpacity(0.8);
    ColorConstants.shimmerSkeletonColor = Colors.grey[300];
    ColorConstants.workshopContainerBackground = Color(0xFF736AB7);
    ColorConstants.workshopCardContainer = Color(0xFF333366);
    ColorConstants.backgroundThemeColor = Color(0xFF736AB7);
    ColorConstants.panelColor = Colors.white;
    ColorConstants.headingColor = Color(0xFF736AB7);
    ColorConstants.porHolderBackground = Colors.grey[300];
  }

  static dark() {
    ColorConstants.homeBackground = Color(0xff333a42);
    ColorConstants.circularRingBackground = Colors.black.withOpacity(0.2);
    ColorConstants.shimmerSkeletonColor = Color(0xff95d8ea);
    ColorConstants.workshopContainerBackground = Color(0xff20232a);
    ColorConstants.workshopCardContainer = Color(0xff333a42);
    ColorConstants.backgroundThemeColor = Color(0xFF736AB7);
    ColorConstants.panelColor = Color(0xff000000);
    ColorConstants.headingColor = Color(0xFF5dbcd2);
    ColorConstants.porHolderBackground = Color(0xff5dbcd2);
  }
}
