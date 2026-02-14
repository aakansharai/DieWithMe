class ChatRoom {
  final String id;
  final int memberCount;
  final bool isFull;
  final DateTime createdAt;

  ChatRoom({
    required this.id,
    required this.memberCount,
    required this.isFull,
    required this.createdAt,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      memberCount: json['member_count'],
      isFull: json['is_full'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
