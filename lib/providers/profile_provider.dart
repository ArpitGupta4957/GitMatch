import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class ProfileProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _profile;
  bool _isLoading = false;
  bool _isSaving = false;

  UserModel? get profile => _profile;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    _profile = await _authService.getOrCreateProfile();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile(UserModel updatedProfile) async {
    _isSaving = true;
    notifyListeners();

    _profile = updatedProfile;
    await _authService.updateProfile(updatedProfile);

    _isSaving = false;
    notifyListeners();
  }

  void updateField({
    String? displayName,
    String? bio,
    String? role,
    List<String>? skills,
    List<String>? interests,
    String? githubUrl,
    String? twitterHandle,
    bool? hackathonMode,
    bool? mentorshipMode,
  }) {
    if (_profile == null) return;
    _profile = _profile!.copyWith(
      displayName: displayName,
      bio: bio,
      role: role,
      skills: skills,
      interests: interests,
      githubUrl: githubUrl,
      twitterHandle: twitterHandle,
      hackathonMode: hackathonMode,
      mentorshipMode: mentorshipMode,
    );
    notifyListeners();
  }

  void setProfile(UserModel profile) {
    _profile = profile;
    notifyListeners();
  }
}
