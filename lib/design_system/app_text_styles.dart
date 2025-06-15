import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'dimensions.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Poppins';

  static TextStyle _headingBase(BuildContext context) => TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700, // Bold
    color: AppColors.textPrimary,
  );

  static TextStyle _descriptionBase(BuildContext context) => TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400, // Regular
    color: AppColors.textPrimary,
  );

  static TextStyle _labelBase(BuildContext context) => TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.textSecondary,
  );

  static TextTheme textTheme(BuildContext context) => TextTheme(
    // Headlines
    displayLarge: _headingBase(context).copyWith(
      fontSize: AppDimensions.scale(context, 24), // Reduced for smaller text
    ),
    displayMedium: _headingBase(context).copyWith(
      fontSize: AppDimensions.scale(context, 20),
    ),
    displaySmall: _headingBase(context).copyWith(
      fontSize: AppDimensions.scale(context, 18),
    ),
    headlineLarge: _headingBase(context).copyWith(
      fontSize: AppDimensions.scale(context, 16),
    ),
    headlineMedium: _headingBase(context).copyWith(
      fontSize: AppDimensions.scale(context, 14),
    ),
    headlineSmall: _headingBase(context).copyWith(
      fontSize: AppDimensions.scale(context, 12), // Increased from 10
    ),
    // Titles
    titleLarge: _headingBase(context).copyWith(
      fontSize: AppDimensions.scale(context, 16),
      fontWeight: FontWeight.w600, // SemiBold
    ),
    titleMedium: _headingBase(context).copyWith(
      fontSize: AppDimensions.scale(context, 14),
      fontWeight: FontWeight.w600, // SemiBold
    ),
    titleSmall: _headingBase(context).copyWith(
      fontSize: AppDimensions.scale(context, 12),
      fontWeight: FontWeight.w400, // SemiBold
    ),
    // Body
    bodyLarge: _descriptionBase(context).copyWith(
      fontSize: AppDimensions.scale(context, 14),
    ),
    bodyMedium: _descriptionBase(context).copyWith(
      fontSize: AppDimensions.scale(context, 12),
    ),
    bodySmall: _descriptionBase(context).copyWith(
      fontSize: AppDimensions.scale(context, 10), // Increased from 6
      color: AppColors.textSecondary,
    ),
    // Labels
    labelLarge: _labelBase(context).copyWith(
      fontSize: AppDimensions.scale(context, 12),
    ),
    labelMedium: _labelBase(context).copyWith(
      fontSize: AppDimensions.scale(context, 10),
    ),
    labelSmall: _labelBase(context).copyWith(
      fontSize: AppDimensions.scale(context, 8), // Reduced for drawer
      color: AppColors.textDisabled,
    ),
  );
}