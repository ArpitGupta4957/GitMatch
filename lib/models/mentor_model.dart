class MentorModel {
  final String id;
  final String name;
  final String title;
  final String? company;
  final String? avatarUrl;
  final List<String> skills;
  final String? bio;
  final String? lookingFor;
  final bool isOffering; // true = offering mentorship, false = seeking
  final String? level; // Senior, Junior, etc.
  final String? githubUrl;
  final String? linkedinUrl;
  final DateTime? createdAt;

  MentorModel({
    required this.id,
    required this.name,
    required this.title,
    this.company,
    this.avatarUrl,
    this.skills = const [],
    this.bio,
    this.lookingFor,
    this.isOffering = true,
    this.level,
    this.githubUrl,
    this.linkedinUrl,
    this.createdAt,
  });

  factory MentorModel.fromJson(Map<String, dynamic> json) {
    return MentorModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      company: json['company'],
      avatarUrl: json['avatar_url'],
      skills: List<String>.from(json['skills'] ?? []),
      bio: json['bio'],
      lookingFor: json['looking_for'],
      isOffering: json['is_offering'] ?? true,
      level: json['level'],
      githubUrl: json['github_url'],
      linkedinUrl: json['linkedin_url'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'company': company,
      'avatar_url': avatarUrl,
      'skills': skills,
      'bio': bio,
      'looking_for': lookingFor,
      'is_offering': isOffering,
      'level': level,
      'github_url': githubUrl,
      'linkedin_url': linkedinUrl,
    };
  }

  String get titleWithCompany =>
      company != null ? '$title @ $company' : title;

  String get statusLabel => isOffering ? 'OFFERING' : 'SEEKING';
}
