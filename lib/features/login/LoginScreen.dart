import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../design_system/app_colors.dart';
import '../../design_system/app_text_styles.dart';
import '../../design_system/dimensions.dart';
import '../../utils/responsive_helper.dart';
import 'bloc/LoginBloc.dart';
import 'bloc/LoginEvent.dart';
import 'bloc/LoginState.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isDesktop = ResponsiveHelper.isDesktop(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final formWidth = isMobile
        ? screenWidth * 0.9
        : isTablet
        ? screenWidth * 0.6
        : screenWidth * 0.35;

    return BlocProvider(
      create: (context) => LoginBloc(),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.pushReplacementNamed(context, '/dashboard');
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  // Background
                  Container(color: AppColors.background),

                  // Top-left logo (wrapped with SafeArea to avoid overlaps)
                  Positioned(
                    left: AppDimensions.padding(context),
                    child: SafeArea(
                      child: Image.asset(
                        'assets/logo/Metatech-latest-logo.webp',
                        width: AppDimensions.iconSizeLarge(context),
                        height: AppDimensions.iconSizeLarge(context),
                      ),
                    ),
                  ),

                  // Centered login form
                  Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.padding(context),
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: formWidth),
                        child: Form(
                          key: formKey,
                          child: Container(
                            padding: EdgeInsets.all(
                              AppDimensions.padding(context),
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(
                                AppDimensions.cardRadius(context),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadow,
                                  blurRadius:
                                  AppDimensions.elevationLow(context),
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Log in',
                                  style: AppTextStyles.textTheme(context)
                                      .titleMedium,
                                ),
                                SizedBox(height: AppDimensions.spacing(context)),
                                Text(
                                  'Welcome back! Please enter your detail',
                                  style: AppTextStyles.textTheme(context)
                                      .labelSmall,
                                ),
                                SizedBox(height: AppDimensions.spacing(context)),

                                // Email
                                TextFormField(
                                  controller: emailController,
                                  style: AppTextStyles.textTheme(context)
                                      .bodySmall,
                                  decoration: InputDecoration(
                                    labelText: 'Enter Email',
                                    labelStyle:
                                    AppTextStyles.textTheme(context)
                                        .labelSmall,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppDimensions.buttonRadius(context),
                                      ),
                                    ),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!RegExp(
                                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                        .hasMatch(value)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: AppDimensions.spacing(context)),

                                // Password
                                TextFormField(
                                  controller: passwordController,
                                  style: AppTextStyles.textTheme(context)
                                      .bodySmall,
                                  decoration: InputDecoration(
                                    labelText: 'Enter Password',
                                    labelStyle:
                                    AppTextStyles.textTheme(context)
                                        .labelSmall,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppDimensions.buttonRadius(context),
                                      ),
                                    ),
                                  ),
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    if (value.length < 6) {
                                      return 'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: AppDimensions.spacing(context)),

                                // Bloc state handling
                                BlocBuilder<LoginBloc, LoginState>(
                                  builder: (context, state) {
                                    if (state is LoginLoading) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    return Column(
                                      children: [
                                        if (state is LoginFailure)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              bottom:
                                              AppDimensions.spacingSmall(
                                                  context),
                                            ),
                                            child: Text(
                                              state.error,
                                              style: AppTextStyles.textTheme(
                                                context,
                                              ).labelSmall?.copyWith(
                                                color: AppColors.error,
                                              ),
                                            ),
                                          ),
                                        SizedBox(height: 10),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: AppColors.surface,
                                            borderRadius:
                                            BorderRadius.circular(
                                              AppDimensions.buttonRadius(
                                                  context),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.shadow,
                                                blurRadius: AppDimensions
                                                    .elevationLow(context),
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: TextButton(
                                            onPressed: () {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                context
                                                    .read<LoginBloc>()
                                                    .add(LoginSubmitted(
                                                  email: emailController.text
                                                      .trim(),
                                                  password:
                                                  passwordController
                                                      .text,
                                                ));
                                              }
                                            },
                                            child: Text(
                                              'Sign in',
                                              style:
                                              AppTextStyles.textTheme(
                                                  context)
                                                  .labelLarge,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Bottom-left Text
                  Positioned(
                    bottom: AppDimensions.padding(context),
                    left: AppDimensions.padding(context),
                    child: SafeArea(
                      child: Text(
                        '@ 2025 Metatech FZ LLC. All rights reserved.',
                        style:
                        AppTextStyles.textTheme(context).labelSmall,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
