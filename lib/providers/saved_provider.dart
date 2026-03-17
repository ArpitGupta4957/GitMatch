import 'package:flutter/material.dart';
import '../models/repo_model.dart';
import '../models/hackathon_model.dart';
import '../models/mentor_model.dart';
import '../services/repo_service.dart';

class SavedProvider extends ChangeNotifier {
  final List<RepoModel> _savedRepos = [];
  final List<HackathonModel> _savedHackathons = [];
  final List<MentorModel> _savedMentors = [];

  List<RepoModel> get savedRepos => _savedRepos;
  List<HackathonModel> get savedHackathons => _savedHackathons;
  List<MentorModel> get savedMentors => _savedMentors;

  int get totalSaved =>
      _savedRepos.length + _savedHackathons.length + _savedMentors.length;

  void saveRepo(RepoModel repo) {
    if (!_savedRepos.any((r) => r.id == repo.id)) {
      _savedRepos.add(repo);
      notifyListeners();
    }
  }

  void unsaveRepo(String id) {
    _savedRepos.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  void saveHackathon(HackathonModel hackathon) {
    if (!_savedHackathons.any((h) => h.id == hackathon.id)) {
      _savedHackathons.add(hackathon);
      notifyListeners();
    }
  }

  void unsaveHackathon(String id) {
    _savedHackathons.removeWhere((h) => h.id == id);
    notifyListeners();
  }

  void saveMentor(MentorModel mentor) {
    if (!_savedMentors.any((m) => m.id == mentor.id)) {
      _savedMentors.add(mentor);
      notifyListeners();
    }
  }

  void unsaveMentor(String id) {
    _savedMentors.removeWhere((m) => m.id == id);
    notifyListeners();
  }

  bool isRepoSaved(String id) => _savedRepos.any((r) => r.id == id);
  bool isHackathonSaved(String id) => _savedHackathons.any((h) => h.id == id);
  bool isMentorSaved(String id) => _savedMentors.any((m) => m.id == id);

  Future<void> loadSavedItems(String userId) async {
    final repoService = RepoService();
    try {
      final repos = await repoService.getSavedRepos(userId);
      _savedRepos.clear();
      _savedRepos.addAll(repos);
      notifyListeners();
    } catch (e) {
      // Use existing saved items
    }
  }
}
