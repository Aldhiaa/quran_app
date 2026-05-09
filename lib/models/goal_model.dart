class GoalModel {
  final int id;
  final String title;
  final String? description;
  final String targetDate;
  final bool completed;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  GoalModel({
    required this.id,
    required this.title,
    this.description,
    required this.targetDate,
    required this.completed,
    this.createdAt,
    this.updatedAt,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'],
      targetDate: json['target_date'] ?? json['deadline'] ?? '',
      completed: json['completed'] ?? (json['status'] == 'completed'),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'target_date': targetDate,
      'completed': completed,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
