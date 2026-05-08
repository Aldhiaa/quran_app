class AchievementModel {
  final int id;
  final String title;
  final String? description;
  final DateTime dateEarned;
  final String? icon;
  final String? awardedBy;

  AchievementModel({
    required this.id,
    required this.title,
    this.description,
    required this.dateEarned,
    this.icon,
    this.awardedBy,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'],
      dateEarned: json['date_earned'] != null
          ? DateTime.parse(json['date_earned'])
          : json['awarded_at'] != null
              ? DateTime.parse(json['awarded_at'])
              : DateTime.now(),
      icon: json['icon'] ?? json['icon_url'],
      awardedBy: json['awarded_by'] is Map
          ? json['awarded_by']['name']
          : json['awarded_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date_earned': dateEarned.toIso8601String(),
      'icon': icon,
      'awarded_by': awardedBy,
    };
  }
}
