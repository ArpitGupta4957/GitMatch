import 'repo_model.dart';

class RecentRepoVisit {
  final String id;
  final String userId;
  final String repoId;
  final DateTime visitedAt;
  final RepoModel repo;

  RecentRepoVisit({
    required this.id,
    required this.userId,
    required this.repoId,
    required this.visitedAt,
    required this.repo,
  });

  factory RecentRepoVisit.fromJson(Map<String, dynamic> json) {
    final repoJson = Map<String, dynamic>.from(
      json['repositories'] ?? <String, dynamic>{},
    );

    return RecentRepoVisit(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      repoId: json['repo_id'] ?? '',
      visitedAt: DateTime.parse(json['visited_at'] ?? json['created_at']),
      repo: RepoModel.fromJson(repoJson),
    );
  }
}
