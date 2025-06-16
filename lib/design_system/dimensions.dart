import 'package:flutter/material.dart';

class AppDimensions {
  AppDimensions._();

  static const double _referenceScreenWidth = 375.0;

  static double scale(BuildContext context, double value) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = (screenWidth / _referenceScreenWidth).clamp(0.8, 1.5); // Cap scaling
    return value * scaleFactor;
  }

  // Padding
  static double paddingSmall(BuildContext context) => scale(context, 8.0);
  static double padding(BuildContext context) => scale(context, 16.0);
  static double paddingLarge(BuildContext context) => scale(context, 24.0);

  // Margins
  static double marginSmall(BuildContext context) => scale(context, 8.0);
  static double margin(BuildContext context) => scale(context, 16.0);
  static double marginLarge(BuildContext context) => scale(context, 24.0);

  // Border Radius
  static double cardRadius(BuildContext context) => scale(context, 12.0);
  static double buttonRadius(BuildContext context) => scale(context, 8.0);
  static double dialogRadius(BuildContext context) => scale(context, 16.0);

  // Icon Sizes
  static double iconSizeSmall(BuildContext context) => scale(context, 14);
  static double iconSize(BuildContext context) => scale(context, 40.0);
  static double iconSizeLarge(BuildContext context) => scale(context, 90.0);

  // Elevation
  static double elevationLow(BuildContext context) => scale(context, 2.0);
  static double elevationMedium(BuildContext context) => scale(context, 4.0);
  static double elevationHigh(BuildContext context) => scale(context, 8.0);

  // Spacing
  static double spacingSmall(BuildContext context) => scale(context, 4.0);
  static double spacing(BuildContext context) => scale(context, 8.0);
  static double spacingLarge(BuildContext context) => scale(context, 16.0);

  // Non-scaled constants (for cases where fixed values are needed)
  static const double fixedPaddingSmall = 8.0;
  static const double fixedPadding = 16.0;
  static const double fixedPaddingLarge = 24.0;
  static const double fixedMarginSmall = 8.0;
  static const double fixedMargin = 16.0;
  static const double fixedMarginLarge = 24.0;
  static const double fixedCardRadius = 12.0;
  static const double fixedButtonRadius = 8.0;
  static const double fixedDialogRadius = 16.0;
  static const double fixedIconSizeSmall = 20.0;
  static const double fixedIconSize = 40.0;
  static const double fixedIconSizeLarge = 60.0;
  static const double fixedElevationLow = 2.0;
  static const double fixedElevationMedium = 4.0;
  static const double fixedElevationHigh = 8.0;
  static const double fixedSpacingSmall = 4.0;
  static const double fixedSpacing = 8.0;
  static const double fixedSpacingLarge = 16.0;
}