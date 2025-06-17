// Profile Event
abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class ToggleEditMode extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final UserProfile updatedProfile;
  UpdateProfile(this.updatedProfile);
}

// User Profile Model
class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String location;
  final String avatarUrl;

  UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.avatarUrl,
  });
}
