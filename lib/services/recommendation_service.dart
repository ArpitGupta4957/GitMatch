import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/repo_model.dart';
import '../models/hackathon_model.dart';
import '../models/mentor_model.dart';
import '../models/user_model.dart';
import 'supabase_service.dart';

class RecommendationService {
  static final SupabaseClient _client = SupabaseService.client;

  /// Score a repo based on user's tech stack match
  static double scoreRepo(RepoModel repo, UserModel user) {
    if (user.skills.isEmpty) return 0.5;
    final matchCount = repo.techStack
        .where((tech) =>
            user.skills.any((s) => s.toLowerCase() == tech.toLowerCase()))
        .length;
    return matchCount / user.skills.length;
  }

  /// Score a hackathon (UserModel) based on matching skills
  static double scoreHackathon(HackathonModel hackathon, UserModel user) {
    if (user.skills.isEmpty) return 0.5;
    final techMatch = hackathon.techStack
        .where((tech) =>
            user.skills.any((s) => s.toLowerCase() == tech.toLowerCase()))
        .length;
    return techMatch / user.skills.length;
  }

  /// Score a mentor (UserModel) based on skill overlap
  static double scoreMentor(MentorModel mentor, UserModel user) {
    if (user.skills.isEmpty) return 0.5;
    final matchCount = mentor.skills
        .where((skill) =>
            user.skills.any((s) => s.toLowerCase() == skill.toLowerCase()))
        .length;
    return matchCount / user.skills.length;
  }

  /// Sort repos by relevance to user
  static List<RepoModel> sortReposByRelevance(
      List<RepoModel> repos, UserModel user) {
    final sorted = List<RepoModel>.from(repos);
    sorted.sort((a, b) => scoreRepo(b, user).compareTo(scoreRepo(a, user)));
    return sorted;
  }

  /// Filter out already-swiped items
  static List<T> filterSwiped<T>(
    List<T> items,
    List<String> swipedIds,
    String Function(T) getId,
  ) {
    return items.where((item) => !swipedIds.contains(getId(item))).toList();
  }

  /// Fetch mentors from `profiles` where mentorship_mode=true.
  /// Maps UserModel → MentorModel for the existing UI.
  static Future<List<MentorModel>> getMentors(
      {String? domain, String? level, String? selfId}) async {
    try {
      var query = _client
          .from('profiles')
          .select()
          .eq('mentorship_mode', true);

      if (level != null && level != 'Any') {
        query = query.eq('experience_level', level);
      }

      final response = await query;
      var users = (response as List)
          .map((json) => UserModel.fromJson(json))
          .toList();

      // Remove own profile
      if (selfId != null) {
        users = users.where((u) => u.id != selfId).toList();
      }

      // Domain filter: match against skills (client-side for now)
      if (domain != null && domain != 'Any') {
        users = users
            .where((u) =>
                u.skills.any((s) => s.toLowerCase().contains(domain.toLowerCase())) ||
                u.interests.any((i) => i.toLowerCase().contains(domain.toLowerCase())))
            .toList();
      }

      return users.map((u) => _mapUserToMentor(u)).toList();
    } catch (e) {
      return getDemoMentors(domain: domain, level: level);
    }
  }

  static MentorModel _mapUserToMentor(UserModel user) {
    return MentorModel(
      id: user.id,
      name: user.displayName ?? user.username,
      title: user.role ?? 'Developer',
      company: null,
      avatarUrl: user.avatarUrl,
      skills: user.skills,
      bio: user.bio,
      lookingFor: user.bio,
      isOffering: user.mentorshipMode,
      level: user.experienceLevel,
      githubUrl: user.githubUrl,
    );
  }

  /// Demo fallback with local filter support
  static List<MentorModel> getDemoMentors({String? domain, String? level}) {
    var mentors = [
      MentorModel(
        id: 'm1',
        name: 'Alex Rivera',
        title: 'Senior Software Architect',
        company: 'Tech Corp',
        skills: ['Python', 'Microservices', 'AWS'],
        lookingFor:
            'Aspiring devs interested in high-scale distributed systems.',
        isOffering: true,
        level: 'Senior',
      ),
      MentorModel(
        id: 'm2',
        name: 'Sarah Chen',
        title: 'Principal Frontend Engineer',
        skills: ['React', 'TypeScript', 'Web Perf'],
        lookingFor:
            'Developers wanting to master modern frontend architecture.',
        isOffering: true,
        level: 'Senior',
      ),
      MentorModel(
        id: 'm3',
        name: 'Jordan Smith',
        title: 'Full Stack Developer',
        skills: ['Go', 'Kubernetes', 'Docker'],
        lookingFor: 'Looking for a mentor in cloud-native development.',
        isOffering: false,
        level: 'Junior',
      ),
      MentorModel(
        id: 'm4',
        name: 'Priya Patel',
        title: 'ML Engineer',
        company: 'AI Labs',
        skills: ['Python', 'TensorFlow', 'PyTorch'],
        lookingFor: 'Students interested in machine learning and AI research.',
        isOffering: true,
        level: 'Senior',
      ),
    ];

    if (level != null && level != 'Any') {
      mentors = mentors
          .where((m) => m.level?.toLowerCase() == level.toLowerCase())
          .toList();
    }
    if (domain != null && domain != 'Any') {
      mentors = mentors
          .where((m) =>
              (m.lookingFor?.toLowerCase().contains(domain.toLowerCase()) ??
                  false) ||
              m.skills.any(
                  (s) => s.toLowerCase().contains(domain.toLowerCase())))
          .toList();
    }

    return mentors;
  }
}
