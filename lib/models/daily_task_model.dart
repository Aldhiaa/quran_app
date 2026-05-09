class DailyTaskModel {
  final int id;
  final String title;
  bool done;
  final String? description;
  final DateTime? dueDate;

  DailyTaskModel({
    required this.id,
    required this.title,
    required this.done,
    this.description,
    this.dueDate,
  });

  factory DailyTaskModel.fromJson(Map<String, dynamic> json) {
    return DailyTaskModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      done: json['done'] ?? json['completed'] ?? false,
      description: json['description'],
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'done': done,
      'description': description,
      'due_date': dueDate?.toIso8601String(),
    };
  }
}
