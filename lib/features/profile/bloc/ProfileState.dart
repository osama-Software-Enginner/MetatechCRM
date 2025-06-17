import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ProfileEvent.dart';

// Profile State
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfile userProfile;
  final bool isEditing;
  ProfileLoaded(this.userProfile, {this.isEditing = false});
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}