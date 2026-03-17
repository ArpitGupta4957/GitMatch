class HackathonModel {
  final String id;
  final String title;
  final String? imageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String category;
  final double prizePool;
  final List<String> techStack;
  final String status; // LIVE, UPCOMING, ENDED
  final bool isTrending;
  final String? description;
  final String? organizer;
  final String? registrationUrl;
  final DateTime? createdAt;

  HackathonModel({
    required this.id,
    required this.title,
    this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.category,
    this.prizePool = 0,
    this.techStack = const [],
    this.status = 'UPCOMING',
    this.isTrending = false,
    this.description,
    this.organizer,
    this.registrationUrl,
    this.createdAt,
  });

  factory HackathonModel.fromJson(Map<String, dynamic> json) {
    return HackathonModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['image_url'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      location: json['location'] ?? '',
      category: json['category'] ?? '',
      prizePool: (json['prize_pool'] as num?)?.toDouble() ?? 0,
      techStack: List<String>.from(json['tech_stack'] ?? []),
      status: json['status'] ?? 'UPCOMING',
      isTrending: json['is_trending'] ?? false,
      description: json['description'],
      organizer: json['organizer'],
      registrationUrl: json['registration_url'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image_url': imageUrl,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'location': location,
      'category': category,
      'prize_pool': prizePool,
      'tech_stack': techStack,
      'status': status,
      'is_trending': isTrending,
      'description': description,
      'organizer': organizer,
      'registration_url': registrationUrl,
    };
  }

  String get dateRange {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[startDate.month - 1]} ${startDate.day} - ${endDate.day}, ${endDate.year}';
  }

  String get prizeFormatted {
    if (prizePool >= 1000) {
      return '\$${(prizePool / 1000).toStringAsFixed(0)},000';
    }
    return '\$${prizePool.toStringAsFixed(0)}';
  }

  bool get isLive => status == 'LIVE';
  bool get isUpcoming => status == 'UPCOMING';
}
