// GitHub OAuth is handled through Supabase's built-in OAuth flow.
// The deep link callback is processed automatically by supabase_flutter.
// This file provides utility methods for the OAuth flow.

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/supabase_service.dart';

class GitHubOAuth {
  /// Initiate GitHub OAuth sign-in
  static Future<bool> signIn() async {
    try {
      await SupabaseService.client.auth.signInWithOAuth(
        OAuthProvider.github,
        redirectTo: 'com.gitmatch.app://callback',
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check if we have an active session from OAuth callback
  static bool hasActiveSession() {
    return SupabaseService.client.auth.currentSession != null;
  }

  /// Get current user data from GitHub profile
  static Map<String, dynamic>? getGitHubUserData() {
    final user = SupabaseService.client.auth.currentUser;
    return user?.userMetadata;
  }
}
