import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/swipe_model.dart';
import '../services/supabase_service.dart';

/// SwipeProvider tracks swipes locally AND persists them to Supabase
/// `swipe_history` table so the feed generator can exclude seen items.
class SwipeProvider extends ChangeNotifier {
  final SupabaseClient _client = SupabaseService.client;

  final List<SwipeModel> _swipes = [];
  final List<String> _swipedRepoIds = [];
  final List<String> _swipedHackathonIds = [];
  final List<String> _swipedMentorIds = [];

  List<SwipeModel> get swipes => _swipes;
  List<String> get swipedRepoIds => _swipedRepoIds;
  List<String> get swipedHackathonIds => _swipedHackathonIds;
  List<String> get swipedMentorIds => _swipedMentorIds;

  Future<void> recordSwipe({
    required String userId,
    required String itemId,
    required SwipeItemType itemType,
    required SwipeDirection direction,
  }) async {
    final swipe = SwipeModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      itemId: itemId,
      itemType: itemType,
      direction: direction,
      timestamp: DateTime.now(),
    );

    _swipes.add(swipe);

    switch (itemType) {
      case SwipeItemType.repo:
        _swipedRepoIds.add(itemId);
        break;
      case SwipeItemType.hackathon:
        _swipedHackathonIds.add(itemId);
        break;
      case SwipeItemType.mentor:
        _swipedMentorIds.add(itemId);
        break;
    }

    notifyListeners();

    // Persist to Supabase swipe_history
    try {
      await _client.from('swipe_history').insert({
        'user_id': userId,
        'item_id': itemId,
        'item_type': itemType.name, // 'repo' | 'hackathon' | 'mentor'
        'direction': direction.name, // 'left' | 'right'
      });
    } catch (_) {
      // Silently fail — local state is source of truth during session
    }
  }

  /// Load swipe history from Supabase on app start (for deduplication)
  Future<void> loadSwipeHistory(String userId) async {
    try {
      _swipes.clear();
      _swipedRepoIds.clear();
      _swipedHackathonIds.clear();
      _swipedMentorIds.clear();

      final response = await _client
          .from('swipe_history')
          .select()
          .eq('user_id', userId);

      for (final row in response as List) {
        final id = row['item_id'] as String;
        final type = row['item_type'] as String;
        if (type == 'repo') _swipedRepoIds.add(id);
        if (type == 'hackathon') _swipedHackathonIds.add(id);
        if (type == 'mentor') _swipedMentorIds.add(id);
      }

      notifyListeners();
    } catch (_) {
      // Fail silently
    }
  }

  bool hasSwipedRepo(String id) => _swipedRepoIds.contains(id);
  bool hasSwipedHackathon(String id) => _swipedHackathonIds.contains(id);
  bool hasSwipedMentor(String id) => _swipedMentorIds.contains(id);

  List<SwipeModel> getSavedSwipes() => _swipes.where((s) => s.isSaved).toList();
}
