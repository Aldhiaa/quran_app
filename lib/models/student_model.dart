class StudentModel {
  final int id;
  final String name;
  final String? email;
  final double progress;
  final String parts;
  final String status;
  final String? role;
  final String? avatar;
  final int? teacherId;

  StudentModel({
    required this.id,
    required this.name,
    this.email,
    required this.progress,
    required this.parts,
    required this.status,
    this.role,
    this.avatar,
    this.teacherId,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    final teacherProfile = json['teacher_profile'];
    return StudentModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'],
      progress: (json['progress'] ?? 0).toDouble(),
      parts: json['parts'] ?? '',
      status: json['status'] ?? '',
      role: json['role'],
      avatar: json['avatar'],
      teacherId: teacherProfile is Map ? teacherProfile['id'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'progress': progress,
      'parts': parts,
      'status': status,
      'role': role,
      'avatar': avatar,
    };
  }
}
