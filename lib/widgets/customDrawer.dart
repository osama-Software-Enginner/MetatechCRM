import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../design_system/app_colors.dart'; // Adjust path as needed
import '../../widgets/drawer_item.dart';
import '../features/dashboard/bloc/dashboard_bloc.dart';
import '../features/dashboard/bloc/dashboard_event.dart'; // Adjust path as needed

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerItem(
            title: 'Dashboard',
            icon: Icons.dashboard,
            route: '/dashboard',
              onTap: () {
                Navigator.pushReplacementNamed(context, '/dashboard');
              }
          ),
          DrawerItem(
            title: 'Profile',
            icon: Icons.person,
            route: '/profile',
          ),
          DrawerItem(
            title: 'Projects',
            icon: Icons.work_outline,
            route: '/projects',
          ),
          DrawerItem(
            title: 'Invoices',
            icon: Icons.receipt_long,
            route: '/invoices',
          ),
          DrawerItem(
            title: 'Support',
            icon: Icons.support_agent,
            route: '/support',
          ),
          DrawerItem(
            title: 'Logout',
            icon: Icons.logout,
            route: '/login',
            iconColor: AppColors.error,
            textColor: AppColors.error,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}