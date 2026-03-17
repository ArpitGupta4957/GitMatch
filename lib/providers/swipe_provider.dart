import 'package:flutter/material.dart';
import '../models/swipe_model.dart';

class SwipeProvider extends ChangeNotifier {
  final List<SwipeModel> _swipes = [];
  final List<String> _swipedRepoIds = [];
  final List<String> _swipedHackathonIds = [];
  final List<String> _swipedMentorIds = [];

  List<SwipeModel> get swipes => _swipes;
  List<String> get swipedRepoIds => _swipedRepoIds;
  List<String> get swipedHackathonIds => _swipedHackathonIds;
  List<String> get swipedMentorIds => _swipedMentorIds;

  void recordSwipe({
    required String userId,
    required String itemId,
    required SwipeItemType itemType,
    required SwipeDirection direction,
  }) {
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
  }

  bool hasSwipedRepo(String id) => _swipedRepoIds.contains(id);
  bool hasSwipedHackathon(String id) => _swipedHackathonIds.contains(id);
  bool hasSwipedMentor(String id) => _swipedMentorIds.contains(id);

  List<SwipeModel> getSavedSwipes() =>
      _swipes.where((s) => s.isSaved).toList();
}
