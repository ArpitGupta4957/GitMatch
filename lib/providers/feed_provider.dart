import 'package:flutter/material.dart';
import '../models/repo_model.dart';
import '../models/hackathon_model.dart';
import '../models/mentor_model.dart';
import '../services/repo_service.dart';
import '../services/hackathon_service.dart';
import '../services/recommendation_service.dart';
import '../core/utils/rate_limiter.dart';

class FeedProvider extends ChangeNotifier {
  final RepoService _repoService = RepoService();
  final HackathonService _hackathonService = HackathonService();

  List<RepoModel> _repos = [];
  List<HackathonModel> _hackathons = [];
  List<MentorModel> _mentors = [];

  bool _isLoading = false;
  bool _isRateLimited = false;
  int _remainingSwipes = 10;
  Duration _timeUntilReset = Duration.zero;

  List<RepoModel> get repos => _repos;
  List<HackathonModel> get hackathons => _hackathons;
  List<MentorModel> get mentors => _mentors;
  bool get isLoading => _isLoading;
  bool get isRateLimited => _isRateLimited;
  int get remainingSwipes => _remainingSwipes;
  Duration get timeUntilReset => _timeUntilReset;

  Future<void> loadRepos({List<String>? techFilter, String? difficulty, String? size, Set<String> excludeIds = const {}}) async {
    _isLoading = true;
    notifyListeners();

    await _checkRateLimit();
    if (!_isRateLimited) {
      _repos = await _repoService.fetchFeed(
        techFilter: techFilter, 
        difficulty: difficulty, 
        size: size
      );
      // Remove duplicates
      _removeLocalDuplicates(excludeIds);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadHackathons({String? role, String? status, Set<String> excludeIds = const {}, String? selfId}) async {
    _isLoading = true;
    notifyListeners();

    await _checkRateLimit();
    if (!_isRateLimited) {
      _hackathons = await _hackathonService.fetchFeed(role: role, status: status, selfId: selfId);
      _removeLocalDuplicates(excludeIds);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMentors({String? domain, String? level, Set<String> excludeIds = const {}, String? selfId}) async {
    _isLoading = true;
    notifyListeners();

    await _checkRateLimit();
    if (!_isRateLimited) {
      _mentors = await RecommendationService.getMentors(domain: domain, level: level, selfId: selfId);
      _removeLocalDuplicates(excludeIds);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadAllFeeds({Set<String> excludeIds = const {}, String? selfId}) async {
    _isLoading = true;
    notifyListeners();

    await _checkRateLimit();
    if (!_isRateLimited) {
      _repos = await _repoService.fetchFeed();
      _hackathons = await _hackathonService.fetchFeed(selfId: selfId);
      _mentors = RecommendationService.getDemoMentors();

      _removeLocalDuplicates(excludeIds);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _checkRateLimit() async {
    _isRateLimited = !(await RateLimiter.canSwipe());
    _remainingSwipes = await RateLimiter.remainingSwipes();
    if (_isRateLimited) {
      _timeUntilReset = await RateLimiter.timeUntilNextSwipe();
    }
  }

  Future<void> recordSwipe() async {
    await RateLimiter.recordSwipe();
    await _checkRateLimit();
    notifyListeners();
  }

  void removeRepo(String id) {
    _repos.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  void removeHackathon(String id) {
    _hackathons.removeWhere((h) => h.id == id);
    notifyListeners();
  }

  void removeMentor(String id) {
    _mentors.removeWhere((m) => m.id == id);
    notifyListeners();
  }

  Future<void> refreshRateLimit() async {
    await _checkRateLimit();
    notifyListeners();
  }

  void _removeLocalDuplicates(Set<String> excludeIds) {
    if (excludeIds.isEmpty) return;
    
    _repos.removeWhere((repo) => excludeIds.contains(repo.id));
    _hackathons.removeWhere((h) => excludeIds.contains(h.id));
    _mentors.removeWhere((m) => excludeIds.contains(m.id));
  }
}
