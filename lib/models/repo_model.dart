class RepoModel {
  final String id;
  final String name;
  final String owner;
  final String? ownerAvatarUrl;
  final String description;
  final String? longDescription;
  final int stars;
  final int forks;
  final int watchers;
  final List<String> techStack;
  final String? imageUrl;
  final String? githubUrl;
  final String? license;
  final String? version;
  final bool isVerified;
  final bool isPublic;
  final double? commitGrowth;
  final String? readmeSnippet;
  final DateTime? createdAt;

  RepoModel({
    required this.id,
    required this.name,
    required this.owner,
    this.ownerAvatarUrl,
    required this.description,
    this.longDescription,
    this.stars = 0,
    this.forks = 0,
    this.watchers = 0,
    this.techStack = const [],
    this.imageUrl,
    this.githubUrl,
    this.license,
    this.version,
    this.isVerified = false,
    this.isPublic = true,
    this.commitGrowth,
    this.readmeSnippet,
    this.createdAt,
  });

  factory RepoModel.fromJson(Map<String, dynamic> json) {
    return RepoModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      owner: json['owner'] ?? '',
      ownerAvatarUrl: json['owner_avatar_url'],
      description: json['description'] ?? '',
      longDescription: json['long_description'],
      stars: json['stars'] ?? 0,
      forks: json['forks'] ?? 0,
      watchers: json['watchers'] ?? 0,
      techStack: List<String>.from(json['tech_stack'] ?? []),
      imageUrl: json['image_url'],
      githubUrl: json['github_url'],
      license: json['license'],
      version: json['version'],
      isVerified: json['is_verified'] ?? false,
      isPublic: json['is_public'] ?? true,
      commitGrowth: (json['commit_growth'] as num?)?.toDouble(),
      readmeSnippet: json['readme_snippet'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'owner': owner,
      'owner_avatar_url': ownerAvatarUrl,
      'description': description,
      'long_description': longDescription,
      'stars': stars,
      'forks': forks,
      'watchers': watchers,
      'tech_stack': techStack,
      'image_url': imageUrl,
      'github_url': githubUrl,
      'license': license,
      'version': version,
      'is_verified': isVerified,
      'is_public': isPublic,
      'commit_growth': commitGrowth,
      'readme_snippet': readmeSnippet,
    };
  }

  String get fullName => '$owner / $name';

  String get starsFormatted {
    if (stars >= 1000) return '${(stars / 1000).toStringAsFixed(1)}k';
    return stars.toString();
  }

  String get forksFormatted {
    if (forks >= 1000) return '${(forks / 1000).toStringAsFixed(1)}k';
    return forks.toString();
  }

  String get watchersFormatted {
    if (watchers >= 1000) return '${(watchers / 1000).toStringAsFixed(1)}k';
    return watchers.toString();
  }
}
