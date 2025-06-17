// Profile BLoC
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ProfileEvent.dart';
import 'ProfileState.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<ToggleEditMode>(_onToggleEditMode);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      // Simulate fetching user profile data
      await Future.delayed(const Duration(seconds: 1));
      final userProfile = UserProfile(
        name: 'John Doe',
        email: 'john.doe@example.com',
        phone: '+1 123-456-7890',
        location: 'San Francisco, CA',
        avatarUrl: 'https://picsum.photos/200/300',
      );
      emit(ProfileLoaded(userProfile));
    } catch (e) {
      emit(ProfileError('Failed to load profile'));
    }
  }

  void _onToggleEditMode(ToggleEditMode event, Emitter<ProfileState> emit) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(ProfileLoaded(currentState.userProfile, isEditing: !currentState.isEditing));
    }
  }

  void _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) {
    if (state is ProfileLoaded) {
      emit(ProfileLoaded(event.updatedProfile, isEditing: false));
    }
  }
}