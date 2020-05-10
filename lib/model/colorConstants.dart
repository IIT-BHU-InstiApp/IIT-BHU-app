import 'package:flutter/material.dart';

// TODO: a set of final colors for light and dark theme
// TODO: maintain shadow colors
class ColorConstants {
  static Color homeBackground = Colors.blue[200];
  static Color circularRingBackground = Colors.blue.withOpacity(0.8);
  static Color shimmerSkeletonColor = Colors.grey[300];
  static Color workshopContainerBackground = Color(0xFF736AB7);
  static Color workshopCardContainer = Color(0xFF333366);

  static Color backgroundThemeColor = Color(0xFF736AB7);
  static Color panelColor = Colors.white;
  static Color headingColor = Color(0xFF736AB7);
  static Color porHolderBackground = Colors.grey[300];

// Other screens than home page
  static Color allWorkshopsBackground = Colors.white;
  static Color accountScreenBackground = Colors.white;
  static Color settingBackground = Colors.white;

// ?_______________permanent color settings (default)_____________________________

  static final Color homeBackgroundConstant = Colors.blue[200];
  static final Color circularRingBackgroundConstant =
      Colors.blue.withOpacity(0.8);
  static final Color shimmerSkeletonColorConstant = Colors.grey[300];
  static final Color workshopContainerBackgroundConstant = Color(0xFF736AB7);
  static final Color backgroundThemeColorConstant = Color(0xFF736AB7);
  static final Color panelColorConstant = Colors.white;
  static final Color workshopCardContainerConstant = Color(0xFF333366);
  static final Color headingColorConstant = Color(0xFF736AB7);
  static final Color porHolderBackgroundConstant = Colors.grey[300];

// Other  screens than home page
  static final Color allWorkshopsBackgroundConstant = Colors.white;
  static final Color accountScreenBackgroundConstant = Colors.white;
  static final Color settingBackgroundConstant = Colors.white;

  static resetToDefault() {
    homeBackground = homeBackgroundConstant;
    circularRingBackground = circularRingBackgroundConstant;
    shimmerSkeletonColor = shimmerSkeletonColorConstant;
    workshopContainerBackground = workshopContainerBackgroundConstant;
    workshopCardContainer = workshopCardContainerConstant;
    backgroundThemeColor = backgroundThemeColorConstant;
    panelColor = panelColorConstant;
    headingColor = headingColorConstant;
    porHolderBackground = porHolderBackgroundConstant;
    allWorkshopsBackground = allWorkshopsBackgroundConstant;
    accountScreenBackground = accountScreenBackgroundConstant;
    settingBackground = settingBackgroundConstant;
  }
}
