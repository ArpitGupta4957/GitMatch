import 'package:shared_preferences/shared_preferences.dart';

class RateLimiter {
  static const String _swipeTimestampsKey = 'swipe_timestamps';
  static const int maxSwipesPerHour = 10;

  /// Check if user can swipe
  static Future<bool> canSwipe() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamps = _getTimestamps(prefs);
    final now = DateTime.now();
    final oneHourAgo = now.subtract(const Duration(hours: 1));

    // Filter timestamps within the last hour
    final recentSwipes = timestamps
        .where((t) => DateTime.fromMillisecondsSinceEpoch(t).isAfter(oneHourAgo))
        .toList();

    return recentSwipes.length < maxSwipesPerHour;
  }

  /// Record a swipe
  static Future<void> recordSwipe() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamps = _getTimestamps(prefs);
    timestamps.add(DateTime.now().millisecondsSinceEpoch);

    // Clean up old timestamps (older than 1 hour)
    final oneHourAgo = DateTime.now().subtract(const Duration(hours: 1));
    timestamps.removeWhere(
        (t) => DateTime.fromMillisecondsSinceEpoch(t).isBefore(oneHourAgo));

    await prefs.setStringList(
      _swipeTimestampsKey,
      timestamps.map((t) => t.toString()).toList(),
    );
  }

  /// Get remaining swipes
  static Future<int> remainingSwipes() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamps = _getTimestamps(prefs);
    final now = DateTime.now();
    final oneHourAgo = now.subtract(const Duration(hours: 1));

    final recentSwipes = timestamps
        .where((t) => DateTime.fromMillisecondsSinceEpoch(t).isAfter(oneHourAgo))
        .toList();

    return maxSwipesPerHour - recentSwipes.length;
  }

  /// Get time until next swipe is available
  static Future<Duration> timeUntilNextSwipe() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamps = _getTimestamps(prefs);
    final now = DateTime.now();
    final oneHourAgo = now.subtract(const Duration(hours: 1));

    final recentSwipes = timestamps
        .where((t) => DateTime.fromMillisecondsSinceEpoch(t).isAfter(oneHourAgo))
        .toList();

    if (recentSwipes.length < maxSwipesPerHour) {
      return Duration.zero;
    }

    // Find the oldest recent swipe
    recentSwipes.sort();
    final oldestRecent = DateTime.fromMillisecondsSinceEpoch(recentSwipes.first);
    final nextAvailable = oldestRecent.add(const Duration(hours: 1));

    return nextAvailable.difference(now);
  }

  /// Reset rate limiter (for testing)
  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_swipeTimestampsKey);
  }

  static List<int> _getTimestamps(SharedPreferences prefs) {
    final stored = prefs.getStringList(_swipeTimestampsKey) ?? [];
    return stored.map((s) => int.parse(s)).toList();
  }
}
