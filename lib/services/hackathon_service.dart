import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';
import '../models/hackathon_model.dart';
import '../models/user_model.dart';

/// HackathonService now queries the `profiles` table for users with
/// `hackathon_mode = true`, mapping UserModel → HackathonModel for the UI.
class HackathonService {
  final SupabaseClient _client = SupabaseService.client;

  Future<List<HackathonModel>> fetchFeed({
    int page = 0,
    int pageSize = 10,
    String? role,
    String? status,
    String? selfId,
  }) async {
    try {
      var query = _client
          .from('profiles')
          .select()
          .eq('hackathon_mode', true)
          .range(page * pageSize, (page + 1) * pageSize - 1);

      final response = await query;
      var users = (response as List)
          .map((json) => UserModel.fromJson(json))
          .toList();

      // Remove own profile
      if (selfId != null) {
        users = users.where((u) => u.id != selfId).toList();
      }

      // Client-side role filter — matches against skills
      if (role != null && role != 'Any') {
        users = users.where((u) => u.skills.any(
          (s) => s.toLowerCase() == role.toLowerCase())).toList();
      }

      // Client-side availability filter
      if (status != null && status != 'Any') {
        users = users.where((u) => u.availability == status).toList();
      }

      // Map UserModel → HackathonModel for the existing UI
      return users.map((u) => _mapUserToHackathon(u)).toList();
    } catch (e) {
      return _getDemoHackathons();
    }
  }

  /// Save a hackathon swipe to saved_items
  Future<void> saveHackathon(String userId, String hackathonId) async {
    try {
      await _client.from('saved_items').insert({
        'user_id': userId,
        'item_id': hackathonId,
        'item_type': 'hackathon',
      });
    } catch (e) {
      // silently fail
    }
  }

  /// Record a swipe in swipe_history
  Future<void> recordSwipe(
      String userId, String itemId, String direction) async {
    try {
      await _client.from('swipe_history').insert({
        'user_id': userId,
        'item_id': itemId,
        'item_type': 'hackathon',
        'direction': direction,
      });
    } catch (e) {
      // silently fail
    }
  }

  static HackathonModel _mapUserToHackathon(UserModel user) {
    return HackathonModel(
      id: user.id,
      title: user.displayName ?? user.username,
      location: 'Remote',
      category: user.interests.isNotEmpty ? user.interests.first : 'Open Source',
      techStack: user.skills,
      status: user.availability ?? 'UPCOMING',
      isTrending: false,
      description: user.bio,
      imageUrl: user.avatarUrl,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 3)),
    );
  }

  static List<HackathonModel> _getDemoHackathons() {
    return [
      HackathonModel(
        id: 'h1',
        title: 'Alex Rivera',
        startDate: DateTime(2024, 8, 12),
        endDate: DateTime(2024, 8, 14),
        location: 'Remote',
        category: 'Generative AI',
        prizePool: 0,
        techStack: ['Python', 'PyTorch', 'OpenAI API'],
        status: 'Upcoming',
        isTrending: true,
        description: 'Looking for a teammate for AI hackathons.',
      ),
      HackathonModel(
        id: 'h2',
        title: 'Jamie Park',
        startDate: DateTime(2024, 9, 5),
        endDate: DateTime(2024, 9, 7),
        location: 'New York & Remote',
        category: 'Blockchain',
        prizePool: 0,
        techStack: ['Solidity', 'React', 'Ethereum'],
        status: 'Registration Open',
        isTrending: false,
        description: 'Web3 developer looking for team members.',
      ),
    ];
  }
}
