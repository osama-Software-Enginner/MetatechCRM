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
    final formWidth = isMobile ? MediaQuery.of(context).size.width * 0.9 : MediaQuery.of(context).size.width * 0.4;

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
          body: Container(
            color: AppColors.background,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.padding(context)),
                  child: Form(
                    key: formKey,
                    child: Container(
                      width: formWidth,
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Login',
                            style: AppTextStyles.textTheme(context).headlineSmall,
                          ),
                          SizedBox(height: AppDimensions.spacing(context)),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: AppTextStyles.textTheme(context).labelSmall,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppDimensions.cardRadius(context)),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: AppDimensions.spacingSmall(context)),
                          TextFormField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: AppTextStyles.textTheme(context).labelSmall,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppDimensions.cardRadius(context)),
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
                          BlocBuilder<LoginBloc, LoginState>(
                            builder: (context, state) {
                              if (state is LoginLoading) {
                                return const CircularProgressIndicator();
                              }
                              return Column(
                                children: [
                                  if (state is LoginFailure)
                                    Padding(
                                      padding: EdgeInsets.only(bottom: AppDimensions.spacingSmall(context)),
                                      child: Text(
                                        state.error,
                                        style: AppTextStyles.textTheme(context).labelSmall?.copyWith(
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        context.read<LoginBloc>().add(
                                          LoginSubmitted(
                                            email: emailController.text.trim(),
                                            password: passwordController.text,
                                          ),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.brand,
                                      foregroundColor: AppColors.surface,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(AppDimensions.buttonRadius(context)),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: AppDimensions.spacingSmall(context),
                                        horizontal: AppDimensions.spacing(context),
                                      ),
                                    ),
                                    child: Text(
                                      'Login',
                                      style: AppTextStyles.textTheme(context).titleSmall,
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
          ),
        ),
      ),
    );
  }
}