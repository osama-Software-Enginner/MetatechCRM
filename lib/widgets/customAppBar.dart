import 'package:flutter/material.dart';
import '../../design_system/dimensions.dart'; // Adjust path as needed

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Image.asset(
        'assets/logo/Metatech-latest-logo.webp',
        width: AppDimensions.iconSizeLarge(context),
        height: AppDimensions.iconSizeLarge(context),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}