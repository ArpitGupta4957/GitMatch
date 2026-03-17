import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _init();
  }

  void _init() {
    _isAuthenticated = _authService.isAuthenticated;
    _authService.onAuthStateChange.listen((data) async {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        _isAuthenticated = true;
        await loadProfile();
      } else if (event == AuthChangeEvent.signedOut) {
        _isAuthenticated = false;
        _user = null;
      }
      notifyListeners();
    });
  }

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    _user = await _authService.getOrCreateProfile();
    _isAuthenticated = _authService.isAuthenticated;

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> signInWithGitHub() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final success = await _authService.signInWithGitHub();
    if (!success) {
      _errorMessage = 'GitHub sign-in failed';
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<bool> signInWithEmail(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signInWithEmail(email, password);
      await loadProfile();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> updateProfile(UserModel updatedUser) async {
    _user = updatedUser;
    await _authService.updateProfile(updatedUser);
    notifyListeners();
  }

  Future<bool> hasCompletedOnboarding() async {
    return await _authService.hasCompletedOnboarding();
  }

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  /// For demo mode - skip auth
  void enterDemoMode() {
    _user = UserModel(
      id: 'demo',
      username: 'alex_codes_7',
      email: 'alex@example.com',
      displayName: 'Alex Rivera',
      bio: 'Building the future of open-source collaboration. Coffee lover, Go enthusiast, and Distributed Systems architect.',
      role: 'professional',
      skills: ['TypeScript', 'Go', 'Rust', 'Python', 'React'],
      interests: ['Open Source', 'Hackathons', 'Mentorship'],
      hackathonMode: true,
      mentorshipMode: false,
    );
    _isAuthenticated = true;
    notifyListeners();
  }
}
