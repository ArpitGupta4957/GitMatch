import '../models/repo_model.dart';
import '../models/hackathon_model.dart';
import '../models/mentor_model.dart';
import '../models/user_model.dart';

class RecommendationService {
  /// Score a repo based on user's tech stack match
  static double scoreRepo(RepoModel repo, UserModel user) {
    if (user.skills.isEmpty) return 0.5;
    final matchCount = repo.techStack
        .where((tech) =>
            user.skills.any((s) => s.toLowerCase() == tech.toLowerCase()))
        .length;
    return matchCount / user.skills.length;
  }

  /// Score a hackathon based on user's interests and tech stack
  static double scoreHackathon(HackathonModel hackathon, UserModel user) {
    if (user.skills.isEmpty) return 0.5;
    final techMatch = hackathon.techStack
        .where((tech) =>
            user.skills.any((s) => s.toLowerCase() == tech.toLowerCase()))
        .length;
    return techMatch / user.skills.length;
  }

  /// Score a mentor based on skill overlap
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

  /// Get demo mentors
  static List<MentorModel> getDemoMentors() {
    return [
      MentorModel(
        id: 'm1',
        name: 'Alex Rivera',
        title: 'Senior Software Architect',
        company: 'Tech Corp',
        skills: ['Python', 'Microservices', 'AWS'],
        lookingFor: 'Aspiring devs interested in high-scale distributed systems and clean code principles.',
        isOffering: true,
        level: 'Senior',
      ),
      MentorModel(
        id: 'm2',
        name: 'Sarah Chen',
        title: 'Principal Frontend Engineer',
        company: null,
        skills: ['React', 'TypeScript', 'Web Perf'],
        lookingFor: 'Developers wanting to master modern frontend architecture and performance optimization.',
        isOffering: true,
        level: 'Principal',
      ),
      MentorModel(
        id: 'm3',
        name: 'Jordan Smith',
        title: 'Full Stack Developer',
        company: null,
        skills: ['Go', 'Kubernetes', 'Docker'],
        lookingFor: 'Looking for a mentor in cloud-native development and container orchestration.',
        isOffering: false,
        level: 'Junior',
      ),
      MentorModel(
        id: 'm4',
        name: 'Priya Patel',
        title: 'ML Engineer',
        company: 'AI Labs',
        skills: ['Python', 'TensorFlow', 'PyTorch'],
        lookingFor: 'Students interested in machine learning, deep learning, and AI research.',
        isOffering: true,
        level: 'Senior',
      ),
    ];
  }
}
