import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/recent_repo_visit.dart';
import '../models/repo_model.dart';
import '../services/supabase_service.dart';

class ActivityProvider extends ChangeNotifier {
  final SupabaseClient _client = SupabaseService.client;

  final List<RecentRepoVisit> _recentRepoVisits = [];

  List<RecentRepoVisit> get recentRepoVisits => _recentRepoVisits;

  Future<void> recordRepoVisit(String userId, RepoModel repo) async {
    try {
      await _client.from('recent_repo_visits').upsert({
        'user_id': userId,
        'repo_id': repo.id,
        'visited_at': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id,repo_id');
    } catch (_) {
      // Ignore DB errors; the dashboard can still render cached visits.
    }

    await loadRecentRepoVisits(userId);
  }

  Future<void> loadRecentRepoVisits(String userId) async {
    try {
      final response = await _client
          .from('recent_repo_visits')
          .select('id,user_id,repo_id,visited_at,repositories(*)')
          .eq('user_id', userId)
          .order('visited_at', ascending: false)
          .limit(5);

      _recentRepoVisits
        ..clear()
        ..addAll(
          (response as List)
              .map(
                (row) =>
                    RecentRepoVisit.fromJson(Map<String, dynamic>.from(row)),
              )
              .toList(),
        );
      notifyListeners();
    } catch (_) {
      _recentRepoVisits.clear();
      notifyListeners();
    }
  }
}
