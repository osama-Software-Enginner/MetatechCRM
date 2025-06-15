import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_text_styles.dart';
import '../design_system/dimensions.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final double percent;
  final double width;
  final double percentNumber;

  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.percent,
    required this.percentNumber,
    required this.width,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: EdgeInsets.all(AppDimensions.padding(context)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius(context)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: AppDimensions.elevationLow(context),
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: AppTextStyles.textTheme(context).titleSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppDimensions.spacingSmall(context)),
            Text(
              percentNumber.toString(),
              style: AppTextStyles.textTheme(context).titleLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}