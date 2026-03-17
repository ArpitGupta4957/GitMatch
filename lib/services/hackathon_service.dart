import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';
import '../models/hackathon_model.dart';

class HackathonService {
  final SupabaseClient _client = SupabaseService.client;

  /// Fetch hackathons for feed
  Future<List<HackathonModel>> fetchFeed({
    int page = 0,
    int pageSize = 10,
    String? filter, // for_you, remote, nearby
  }) async {
    try {
      final response = await _client
          .from('hackathons')
          .select()
          .order('start_date', ascending: true)
          .range(page * pageSize, (page + 1) * pageSize - 1);
      return (response as List)
          .map((json) => HackathonModel.fromJson(json))
          .toList();
    } catch (e) {
      return _getDemoHackathons();
    }
  }

  /// Save hackathon
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

  static List<HackathonModel> _getDemoHackathons() {
    return [
      HackathonModel(
        id: 'h1',
        title: 'Global AI Hackathon 2024',
        startDate: DateTime(2024, 8, 12),
        endDate: DateTime(2024, 8, 14),
        location: 'San Francisco & Remote',
        category: 'Generative AI',
        prizePool: 50000,
        techStack: ['Python', 'PyTorch', 'OpenAI API', 'Next.js'],
        status: 'LIVE',
        isTrending: true,
      ),
      HackathonModel(
        id: 'h2',
        title: 'Web3 Builder Summit',
        startDate: DateTime(2024, 9, 5),
        endDate: DateTime(2024, 9, 7),
        location: 'New York & Remote',
        category: 'Blockchain',
        prizePool: 30000,
        techStack: ['Solidity', 'React', 'Ethereum', 'IPFS'],
        status: 'UPCOMING',
        isTrending: false,
      ),
      HackathonModel(
        id: 'h3',
        title: 'Flutter Forward Challenge',
        startDate: DateTime(2024, 10, 1),
        endDate: DateTime(2024, 10, 3),
        location: 'Remote',
        category: 'Mobile Development',
        prizePool: 25000,
        techStack: ['Flutter', 'Dart', 'Firebase', 'Supabase'],
        status: 'UPCOMING',
        isTrending: true,
      ),
      HackathonModel(
        id: 'h4',
        title: 'Green Tech Innovation Hack',
        startDate: DateTime(2024, 11, 15),
        endDate: DateTime(2024, 11, 17),
        location: 'London & Remote',
        category: 'Climate Tech',
        prizePool: 40000,
        techStack: ['Python', 'TensorFlow', 'React', 'AWS'],
        status: 'UPCOMING',
        isTrending: false,
      ),
    ];
  }
}
