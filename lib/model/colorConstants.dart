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
  static Color textColor;

  static setLight() {
    ColorConstants.homeBackground = Colors.blue[200];
    ColorConstants.circularRingBackground = Colors.blue.withOpacity(0.8);
    ColorConstants.shimmerSkeletonColor = Color(0x5F6237A0);
    ColorConstants.workshopContainerBackground = Color(0xFF736AB7);
    ColorConstants.workshopCardContainer = Color(0xFF333366);
    ColorConstants.backgroundThemeColor = Color(0xFF736AB7);
    ColorConstants.panelColor = Colors.white;
    ColorConstants.headingColor = Color(0xFF736AB7);
    ColorConstants.porHolderBackground = Colors.grey[300];
    ColorConstants.textColor = Colors.black;
  }

  static setDark() {
    ColorConstants.homeBackground = Color(0xff2c2c2c);
    ColorConstants.circularRingBackground = Colors.black.withOpacity(0.2);
    ColorConstants.shimmerSkeletonColor = Color(0xff3e3d32);
    ColorConstants.workshopContainerBackground = Color(0xff20232a);
    ColorConstants.workshopCardContainer = Color(0xff3e3e3e);
    ColorConstants.backgroundThemeColor = Color(0xFF272822);
    ColorConstants.panelColor = Color(0xff1e1f1c);
    ColorConstants.headingColor = Color(0xFF5dbcd2);
    ColorConstants.porHolderBackground = Color(0xff5dbcd2);
    ColorConstants.textColor = Colors.white;
  }
}
