import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_text_styles.dart';

import '../../design_system/dimensions.dart';
import 'bloc/splash_bloc.dart';
import 'bloc/splash_event.dart';
import 'bloc/splash_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc()..add(StartSplash()),
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: BlocListener<SplashBloc, SplashState>(
          listener: (context, state) {
            if (state is SplashNavigateToLogin) {
              Navigator.pushReplacementNamed(context, '/login');
            }else if (state is SplashNavigateToDashboard) {
              Navigator.pushReplacementNamed(context, '/dashboard');
            }
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo/Metatech-latest-logo.webp',
                  width: AppDimensions.iconSizeLarge(context),
                  height: AppDimensions.iconSizeLarge(context),
                ),
                SizedBox(height: AppDimensions.spacingLarge(context)),
                Text(
                  'Client Portal',
                  style: AppTextStyles.textTheme(context).displaySmall,
                ),
                SizedBox(height: AppDimensions.spacingSmall(context)),
                Text(
                  'Welcome to your portal',
                  style: AppTextStyles.textTheme(context).bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}