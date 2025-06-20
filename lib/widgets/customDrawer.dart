import 'package:flutter/material.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/dimensions.dart';

class CustomDrawer extends StatelessWidget {
  final String selectedRoute;

  const CustomDrawer({
    super.key,
    this.selectedRoute = '/dashboard',
  });

  @override
  Widget build(BuildContext context) {
    final drawerWidth = AppDimensions.scale(context, 50);
    final iconSize = AppDimensions.iconSizeSmall(context);
    final selectedSize = AppDimensions.scale(context, 40);
    final unselectedSize = AppDimensions.scale(context, 30);
    final padding = AppDimensions.paddingSmall(context);

    final drawerItems = [
      {'title': 'Dashboard', 'icon': Icons.dashboard, 'route': '/dashboard'},
      {'title': 'Profile', 'icon': Icons.person, 'route': '/profile'},
      {'title': 'Invoices', 'icon': Icons.receipt_long, 'route': '/invoices'},
      {'title': 'Support', 'icon': Icons.support_agent, 'route': '/support'},
    ];

    return Container(
      width: drawerWidth,
      decoration: BoxDecoration(
        color: AppColors.brand,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(AppDimensions.cardRadius(context)),
          bottomRight: Radius.circular(AppDimensions.cardRadius(context)),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo + Icons
          Column(
            children: [
              const SizedBox(height: 12),
              Image.asset(
                'assets/logo/webicon.png',
                width: AppDimensions.iconSize(context),
                height: AppDimensions.iconSize(context),
              ),
              const SizedBox(height: 12),

              // Drawer Icons
              Column(
                children: drawerItems.map((item) {
                  final isSelected = selectedRoute == item['route'];
                  final size = isSelected ? selectedSize : unselectedSize;

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: padding),
                    child: GestureDetector(
                      onTap: () {
                        if (ModalRoute.of(context)?.settings.name != item['route']) {
                          Navigator.pushReplacementNamed(context, item['route'] as String);
                        }
                      },
                      child: Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.buttonRadius(context),
                          ),
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          size: iconSize,
                          color: isSelected
                              ? AppColors.brand.shade700
                              : Colors.white,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // Logout Button
          Padding(
            padding: EdgeInsets.only(bottom: padding * 2),
            child: GestureDetector(
              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
              child: Container(
                width: unselectedSize,
                height: unselectedSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(
                  Icons.logout,
                  color: AppColors.error,
                  size: iconSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
