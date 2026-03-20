import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/repo_model.dart';
import '../models/hackathon_model.dart';
import '../models/mentor_model.dart';
import '../services/repo_service.dart';
import '../services/supabase_service.dart';

/// SavedProvider tracks saved items locally AND persists them to Supabase
/// `saved_items` table using item_type: 'repo' | 'hackathon' | 'mentor'.
class SavedProvider extends ChangeNotifier {
  final SupabaseClient _client = SupabaseService.client;
  
  final List<RepoModel> _savedRepos = [];
  final List<HackathonModel> _savedHackathons = [];
  final List<MentorModel> _savedMentors = [];

  List<RepoModel> get savedRepos => _savedRepos;
  List<HackathonModel> get savedHackathons => _savedHackathons;
  List<MentorModel> get savedMentors => _savedMentors;

  int get totalSaved =>
      _savedRepos.length + _savedHackathons.length + _savedMentors.length;

  // ─── REPOS ────────────────────────────────────────────────────────────────

  Future<void> saveRepo(RepoModel repo, String userId) async {
    if (!_savedRepos.any((r) => r.id == repo.id)) {
      _savedRepos.add(repo);
      notifyListeners();
      try {
        await _client.from('saved_items').insert({
          'user_id': userId,
          'item_id': repo.id,
          'item_type': 'repo',
        });
      } catch (_) {}
    }
  }

  Future<void> unsaveRepo(String id, String userId) async {
    _savedRepos.removeWhere((r) => r.id == id);
    notifyListeners();
    try {
      await _client
          .from('saved_items')
          .delete()
          .eq('user_id', userId)
          .eq('item_id', id)
          .eq('item_type', 'repo');
    } catch (_) {}
  }

  // ─── HACKATHONS ───────────────────────────────────────────────────────────

  Future<void> saveHackathon(HackathonModel hackathon, String userId) async {
    if (!_savedHackathons.any((h) => h.id == hackathon.id)) {
      _savedHackathons.add(hackathon);
      notifyListeners();
      try {
        await _client.from('saved_items').insert({
          'user_id': userId,
          'item_id': hackathon.id,
          'item_type': 'hackathon',
        });
      } catch (_) {}
    }
  }

  Future<void> unsaveHackathon(String id, String userId) async {
    _savedHackathons.removeWhere((h) => h.id == id);
    notifyListeners();
    try {
      await _client
          .from('saved_items')
          .delete()
          .eq('user_id', userId)
          .eq('item_id', id)
          .eq('item_type', 'hackathon');
    } catch (_) {}
  }

  // ─── MENTORS ──────────────────────────────────────────────────────────────

  Future<void> saveMentor(MentorModel mentor, String userId) async {
    if (!_savedMentors.any((m) => m.id == mentor.id)) {
      _savedMentors.add(mentor);
      notifyListeners();
      try {
        await _client.from('saved_items').insert({
          'user_id': userId,
          'item_id': mentor.id,
          'item_type': 'mentor',
        });
      } catch (_) {}
    }
  }

  Future<void> unsaveMentor(String id, String userId) async {
    _savedMentors.removeWhere((m) => m.id == id);
    notifyListeners();
    try {
      await _client
          .from('saved_items')
          .delete()
          .eq('user_id', userId)
          .eq('item_id', id)
          .eq('item_type', 'mentor');
    } catch (_) {}
  }

  // ─── HELPERS ──────────────────────────────────────────────────────────────

  bool isRepoSaved(String id) => _savedRepos.any((r) => r.id == id);
  bool isHackathonSaved(String id) => _savedHackathons.any((h) => h.id == id);
  bool isMentorSaved(String id) => _savedMentors.any((m) => m.id == id);

  /// Load saved repos from Supabase on startup
  Future<void> loadSavedItems(String userId) async {
    final repoService = RepoService();
    try {
      final repos = await repoService.getSavedRepos(userId);
      _savedRepos.clear();
      _savedRepos.addAll(repos);
      notifyListeners();
    } catch (_) {}
  }
}
