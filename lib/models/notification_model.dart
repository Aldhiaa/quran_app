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
    final data = json['data'];
    String? msg = json['message'];
    if (msg == null && data is Map) msg = data['message']?.toString();
    if (msg == null && data is String) msg = data;
    return NotificationModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString(),
      message: msg,
      isRead: json['is_read'] == true || json['read_at'] != null,
      createdAt: _safeParse(json['created_at']),
      type: json['type']?.toString(),
      color: json['color']?.toString(),
    );
  }

  static DateTime _safeParse(dynamic v) {
    if (v is String && v.isNotEmpty) {
      return DateTime.tryParse(v) ?? DateTime.now();
    }
    return DateTime.now();
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
