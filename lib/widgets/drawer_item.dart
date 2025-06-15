import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_text_styles.dart';
import '../design_system/dimensions.dart';

class DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final String route;
  final Color? iconColor;
  final Color? textColor;
  final VoidCallback? onTap;

  const DrawerItem({
    super.key,
    required this.title,
    required this.icon,
    required this.route,
    this.iconColor,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? AppColors.brand,
        size: AppDimensions.iconSizeSmall(context),
      ),
      title: Text(
        title,
        style: AppTextStyles.textTheme(context).labelSmall?.copyWith(
          color: textColor ?? AppColors.textPrimary,
          fontFamily: 'Poppins',
        ),
      ),
      onTap: onTap ??
              () {
            Navigator.pop(context);
            if (route.isNotEmpty) {
              Navigator.pushNamed(context, route);
            }
          },
    );
  }
}