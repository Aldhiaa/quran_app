class AnnouncementModel {
  final int id;
  final String title;
  final String? subtitle;
  final String content;
  final DateTime createdAt;
  final String? type;

  AnnouncementModel({
    required this.id,
    required this.title,
    this.subtitle,
    required this.content,
    required this.createdAt,
    this.type,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      subtitle: json['subtitle'],
      content: json['content'] ?? '',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'type': type,
    };
  }
}
