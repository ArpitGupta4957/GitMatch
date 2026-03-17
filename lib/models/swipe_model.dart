enum SwipeDirection { left, right }
enum SwipeItemType { repo, hackathon, mentor }

class SwipeModel {
  final String id;
  final String userId;
  final String itemId;
  final SwipeItemType itemType;
  final SwipeDirection direction;
  final DateTime timestamp;

  SwipeModel({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.itemType,
    required this.direction,
    required this.timestamp,
  });

  factory SwipeModel.fromJson(Map<String, dynamic> json) {
    return SwipeModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      itemId: json['item_id'] ?? '',
      itemType: SwipeItemType.values.firstWhere(
        (e) => e.name == json['item_type'],
        orElse: () => SwipeItemType.repo,
      ),
      direction: json['direction'] == 'right'
          ? SwipeDirection.right
          : SwipeDirection.left,
      timestamp: DateTime.parse(json['timestamp'] ?? json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'item_id': itemId,
      'item_type': itemType.name,
      'direction': direction.name,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  bool get isSaved => direction == SwipeDirection.right;
  bool get isRejected => direction == SwipeDirection.left;
}
