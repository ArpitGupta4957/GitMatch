import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';
import '../models/user_model.dart';

class AuthService {
  final SupabaseClient _client = SupabaseService.client;

  String _githubAvatarUrl(String username) {
    if (username.isEmpty) return '';
    return 'https://github.com/$username.png?size=200';
  }

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

  /// Get or create user profile in the `profiles` table
  Future<UserModel?> getOrCreateProfile() async {
    final user = currentUser;
    if (user == null) return null;

    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (response != null) {
        return UserModel.fromJson(response);
      }

      // Create new profile (trigger usually handles this, but as a safety net)
      final newProfile = {
        'id': user.id,
        'email': user.email ?? '',
        'username':
            user.userMetadata?['user_name'] ??
            user.userMetadata?['preferred_username'] ??
            user.email?.split('@').first ??
            'user',
        'display_name':
            user.userMetadata?['full_name'] ?? user.userMetadata?['name'],
        'avatar_url':
            user.userMetadata?['avatar_url'] ??
            user.userMetadata?['picture'] ??
            _githubAvatarUrl(
              user.userMetadata?['user_name'] ??
                  user.userMetadata?['preferred_username'] ??
                  user.email?.split('@').first ??
                  'user',
            ),
        'github_url': 'https://github.com/${user.userMetadata?['user_name']}',
      };

      await _client.from('profiles').insert(newProfile);
      return UserModel.fromJson(newProfile);
    } catch (e) {
      // Return a minimal profile using auth data if DB isn't reachable
      return UserModel(
        id: user.id,
        username: user.userMetadata?['user_name'] ?? 'user',
        email: user.email ?? '',
        displayName: user.userMetadata?['full_name'],
        avatarUrl:
            user.userMetadata?['avatar_url'] ??
            user.userMetadata?['picture'] ??
            _githubAvatarUrl(user.userMetadata?['user_name'] ?? 'user'),
        githubUrl: 'https://github.com/${user.userMetadata?['user_name']}',
      );
    }
  }

  /// Update user profile in the `profiles` table
  Future<void> updateProfile(UserModel profile) async {
    try {
      await _client
          .from('profiles')
          .update(profile.toJson())
          .eq('id', profile.id);
    } catch (e) {
      // silently fail if DB not configured
    }
  }

  /// Check if user has completed onboarding (has role + skills set)
  Future<bool> hasCompletedOnboarding() async {
    final user = currentUser;
    if (user == null) return false;

    try {
      final response = await _client
          .from('profiles')
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
