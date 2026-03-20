import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'swipe_provider.dart';
import 'saved_provider.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  SwipeProvider? _swipeProvider;
  SavedProvider? _savedProvider;

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

  /// Call from main.dart after MultiProvider is set up
  void init(SwipeProvider swipeProvider, SavedProvider savedProvider) {
    _swipeProvider = swipeProvider;
    _savedProvider = savedProvider;
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

    // Load swipe history and saved items from Supabase for deduplication
    if (_user != null) {
      _swipeProvider?.loadSwipeHistory(_user!.id);
      _savedProvider?.loadSavedItems(_user!.id);
    }

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
