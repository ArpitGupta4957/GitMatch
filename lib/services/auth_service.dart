import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';
import '../models/user_model.dart';

class AuthService {
  final SupabaseClient _client = SupabaseService.client;

  /// Sign in with GitHub OAuth
  Future<bool> signInWithGitHub() async {
    try {
      await _client.auth.signInWithOAuth(
        OAuthProvider.github,
        redirectTo: 'com.gitmatch.app://callback',
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Sign in with email and password
  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Sign up with email and password
  Future<AuthResponse> signUpWithEmail(String email, String password) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
    );
  }

  /// Sign out
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Get current session
  Session? get currentSession => _client.auth.currentSession;

  /// Get current user
  User? get currentUser => _client.auth.currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  /// Listen to auth state changes
  Stream<AuthState> get onAuthStateChange => _client.auth.onAuthStateChange;

  /// Get or create user profile in database
  Future<UserModel?> getOrCreateProfile() async {
    final user = currentUser;
    if (user == null) return null;

    try {
      final response = await _client
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (response != null) {
        return UserModel.fromJson(response);
      }

      // Create new profile
      final newProfile = {
        'id': user.id,
        'email': user.email ?? '',
        'username': user.userMetadata?['user_name'] ??
            user.userMetadata?['preferred_username'] ??
            user.email?.split('@').first ??
            'user',
        'display_name': user.userMetadata?['full_name'] ??
            user.userMetadata?['name'],
        'avatar_url': user.userMetadata?['avatar_url'],
      };

      await _client.from('users').insert(newProfile);
      return UserModel.fromJson(newProfile);
    } catch (e) {
      // Return a minimal profile if DB isn't set up
      return UserModel(
        id: user.id,
        username: user.userMetadata?['user_name'] ?? 'user',
        email: user.email ?? '',
        displayName: user.userMetadata?['full_name'],
        avatarUrl: user.userMetadata?['avatar_url'],
      );
    }
  }

  /// Update user profile
  Future<void> updateProfile(UserModel profile) async {
    try {
      await _client
          .from('users')
          .update(profile.toJson())
          .eq('id', profile.id);
    } catch (e) {
      // silently fail if DB not configured
    }
  }

  /// Check if user has completed onboarding
  Future<bool> hasCompletedOnboarding() async {
    final user = currentUser;
    if (user == null) return false;

    try {
      final response = await _client
          .from('users')
          .select('role, skills, interests')
          .eq('id', user.id)
          .maybeSingle();

      if (response == null) return false;
      return response['role'] != null &&
          (response['skills'] as List?)?.isNotEmpty == true;
    } catch (e) {
      return false;
    }
  }
}
