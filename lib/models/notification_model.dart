class NotificationModel {
  final int id;
  final String title;
  final String? subtitle;
  final String? message;
  final bool isRead;
  final DateTime createdAt;
  final String? type;
  final String? color;

  NotificationModel({
    required this.id,
    required this.title,
    this.subtitle,
    this.message,
    required this.isRead,
    required this.createdAt,
    this.type,
    this.color,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      subtitle: json['subtitle'],
      message: json['message'] ?? json['data']['message'] ?? json['data'],
      isRead: json['is_read'] ?? (json['read_at'] != null),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      type: json['type'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'message': message,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
      'type': type,
      'color': color,
    };
  }
}
