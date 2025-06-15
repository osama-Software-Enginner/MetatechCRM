import 'package:flutter/material.dart';
import '../../design_system/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Profile')),
      body: Container(
        color: AppColors.background,
        padding: const EdgeInsets.all(16),
        child: Center(child: Text('Profile details go here')),
      ),
    );
  }
}
