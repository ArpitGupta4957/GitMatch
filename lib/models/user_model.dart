class UserModel {
  final String id;
  final String username;
  final String email;
  final String? displayName;
  final String? avatarUrl;
  final String? bio;
  final String? role; // student, professional, mentor
  final List<String> skills;
  final List<String> interests;
  final String? githubUrl;
  final String? twitterHandle;
  final bool hackathonMode;
  final bool mentorshipMode;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.displayName,
    this.avatarUrl,
    this.bio,
    this.role,
    this.skills = const [],
    this.interests = const [],
    this.githubUrl,
    this.twitterHandle,
    this.hackathonMode = false,
    this.mentorshipMode = false,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      displayName: json['display_name'],
      avatarUrl: json['avatar_url'],
      bio: json['bio'],
      role: json['role'],
      skills: List<String>.from(json['skills'] ?? []),
      interests: List<String>.from(json['interests'] ?? []),
      githubUrl: json['github_url'],
      twitterHandle: json['twitter_handle'],
      hackathonMode: json['hackathon_mode'] ?? false,
      mentorshipMode: json['mentorship_mode'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'bio': bio,
      'role': role,
      'skills': skills,
      'interests': interests,
      'github_url': githubUrl,
      'twitter_handle': twitterHandle,
      'hackathon_mode': hackathonMode,
      'mentorship_mode': mentorshipMode,
    };
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? displayName,
    String? avatarUrl,
    String? bio,
    String? role,
    List<String>? skills,
    List<String>? interests,
    String? githubUrl,
    String? twitterHandle,
    bool? hackathonMode,
    bool? mentorshipMode,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      role: role ?? this.role,
      skills: skills ?? this.skills,
      interests: interests ?? this.interests,
      githubUrl: githubUrl ?? this.githubUrl,
      twitterHandle: twitterHandle ?? this.twitterHandle,
      hackathonMode: hackathonMode ?? this.hackathonMode,
      mentorshipMode: mentorshipMode ?? this.mentorshipMode,
      createdAt: createdAt,
    );
  }
}
