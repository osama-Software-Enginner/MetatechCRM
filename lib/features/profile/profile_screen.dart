// Profile Page Widget

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../design_system/app_colors.dart';
import '../../design_system/dimensions.dart';
import '../../widgets/CustomAppBar.dart';
import '../../widgets/customDrawer.dart';
import 'bloc/ProfileBloc.dart';
import 'bloc/ProfileEvent.dart';
import 'bloc/ProfileState.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc()..add(LoadProfile()),
      child: Scaffold(
        appBar: CustomAppBar(),
        drawer: CustomDrawer(),
        body: CustomScrollView(
          slivers: [
            _buildSliverAppBar(context),
            SliverToBoxAdapter(child: _buildProfileContent(context)),
          ],
        ),
        floatingActionButton: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoaded) {
              return FloatingActionButton(
                backgroundColor: Colors.black,
                child: Icon(state.isEditing ? Icons.save : Icons.edit, color: Colors.white),
                onPressed: () {
                  if (state.isEditing) {
                    // Save logic handled in form
                  } else {
                    context.read<ProfileBloc>().add(ToggleEditMode());
                  }
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: AppDimensions.scale(context, 200),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
          ),
          child: Center(
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoaded) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAvatar(context, state.userProfile.avatarUrl),
                      SizedBox(height: AppDimensions.spacing(context)),
                      Text(
                        state.userProfile.name,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.black),
                      ),
                      Text(
                        state.userProfile.email,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
      // pinned: true,
      backgroundColor: AppColors.surface,
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildAvatar(BuildContext context, String avatarUrl) {
    return Hero(
      tag: 'profile-avatar',
      child: CircleAvatar(
        radius: AppDimensions.iconSizeLarge(context) / 2,
        backgroundImage: NetworkImage(avatarUrl),
        backgroundColor: AppColors.brand.shade100,
        child: avatarUrl.isEmpty
            ? Icon(Icons.person, size: AppDimensions.iconSizeLarge(context) / 2, color: AppColors.brand)
            : null,
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProfileLoaded) {
          return _buildEditableProfile(context, state.userProfile, state.isEditing);
        } else if (state is ProfileError) {
          return Center(child: Text(state.message, style: Theme.of(context).textTheme.bodyMedium));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEditableProfile(BuildContext context, UserProfile userProfile, bool isEditing) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: userProfile.name);
    final emailController = TextEditingController(text: userProfile.email);
    final phoneController = TextEditingController(text: userProfile.phone);
    final locationController = TextEditingController(text: userProfile.location);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.all(AppDimensions.padding(context)),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(context, 'Personal Information', [
              _buildProfileField(
                context,
                icon: Icons.person,
                label: 'Name',
                value: userProfile.name,
                isEditing: isEditing,
                controller: nameController,
                validator: (value) => value!.isEmpty ? 'Name is required' : null,
              ),
              _buildProfileField(
                context,
                icon: Icons.email,
                label: 'Email',
                value: userProfile.email,
                isEditing: isEditing,
                controller: emailController,
                validator: (value) {
                  if (value!.isEmpty) return 'Email is required';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
            ]),
            SizedBox(height: AppDimensions.spacingLarge(context)),
            _buildProfileCard(context, 'Contact Information', [
              _buildProfileField(
                context,
                icon: Icons.phone,
                label: 'Phone',
                value: userProfile.phone,
                isEditing: isEditing,
                controller: phoneController,
                validator: (value) => value!.isEmpty ? 'Phone is required' : null,
              ),
              _buildProfileField(
                context,
                icon: Icons.location_on,
                label: 'Location',
                value: userProfile.location,
                isEditing: isEditing,
                controller: locationController,
                validator: (value) => value!.isEmpty ? 'Location is required' : null,
              ),
            ]),
            if (isEditing)
              Padding(
                padding: EdgeInsets.only(top: AppDimensions.padding(context)),
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.buttonRadius(context)),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingLarge(context),
                        vertical: AppDimensions.paddingSmall(context),
                      ),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<ProfileBloc>().add(UpdateProfile(
                          UserProfile(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                            location: locationController.text,
                            avatarUrl: userProfile.avatarUrl,
                          ),
                        ));
                      }
                    },
                    child: Text(
                      'Save Changes',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, String title, List<Widget> children) {
    return Card(
      color: AppColors.background,
      elevation: AppDimensions.elevationLow(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius(context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.padding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.textPrimary),
            ),
            SizedBox(height: AppDimensions.spacing(context)),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String value,
        required bool isEditing,
        required TextEditingController controller,
        String? Function(String?)? validator,
      }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.spacingSmall(context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppDimensions.iconSizeSmall(context), color: AppColors.textPrimary),
          SizedBox(width: AppDimensions.spacing(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelLarge),
                SizedBox(height: AppDimensions.spacingSmall(context)),
                isEditing
                    ? TextFormField(
                  controller: controller,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.buttonRadius(context)),
                      borderSide: BorderSide(color: AppColors.divider),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingSmall(context),
                      vertical: AppDimensions.paddingSmall(context),
                    ),
                  ),
                  validator: validator,
                )
                    : Text(value, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}