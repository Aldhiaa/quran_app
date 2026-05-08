class MessageModel {
  final int id;
  final String senderName;
  final String content;
  final bool isRead;
  final DateTime createdAt;
  final bool isFromTeacher;

  MessageModel({
    required this.id,
    required this.senderName,
    required this.content,
    required this.isRead,
    required this.createdAt,
    required this.isFromTeacher,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final sender = json['sender'] ?? {};
    final receiver = json['receiver'] ?? {};
    return MessageModel(
      id: json['id'] ?? 0,
      senderName: json['sender_name'] ?? sender['name'] ?? json['name'] ?? '',
      content: json['content'] ?? json['body'] ?? json['last'] ?? '',
      isRead: json['is_read'] ?? json['unread'] == false ?? false,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      isFromTeacher: json['is_from_teacher'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_name': senderName,
      'content': content,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
      'is_from_teacher': isFromTeacher,
    };
  }
}
