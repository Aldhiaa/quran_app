class AuthUser {
  final int id;
  final String name;
  final String? email;
  final String role;
  final String? phone;
  final String? avatarUrl;
  final int? branchId;
  final int? centerId;
  final List<int> branchIds;
  final List<int> centerIds;
  final List<int> circleIds;
  final Map<String, dynamic> permissions;

  const AuthUser({
    required this.id,
    required this.name,
    required this.role,
    this.email,
    this.phone,
    this.avatarUrl,
    this.branchId,
    this.centerId,
    this.branchIds = const [],
    this.centerIds = const [],
    this.circleIds = const [],
    this.permissions = const {},
  });

  bool get isStudent => role == 'student';
  bool get isTeacher => role == 'teacher';
  bool get isSupervisor => role == 'center_supervisor';
  bool get isGuide => role == 'guide';

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    final user = _unwrapUser(json);
    final teacherProfile = user['teacher_profile'];
    final studentProfile = user['student_profile'];

    return AuthUser(
      id: _asInt(user['id']),
      name: '${user['name'] ?? user['full_name'] ?? ''}',
      email: user['email']?.toString(),
      phone: user['phone']?.toString(),
      role: '${user['role'] ?? 'student'}',
      avatarUrl: (user['avatar_url'] ?? user['avatar'])?.toString(),
      branchId: _nullableInt(user['branch_id']),
      centerId: _nullableInt(user['center_id']),
      branchIds: _intList(user['branch_ids']),
      centerIds: _intList(user['center_ids']),
      circleIds: _intList(user['circle_ids'] ?? user['circles']),
      permissions: user['permissions'] is Map
          ? Map<String, dynamic>.from(user['permissions'] as Map)
          : const {},
    ).copyWithDerivedScopes(
      teacherProfile: teacherProfile,
      studentProfile: studentProfile,
    );
  }

  AuthUser copyWithDerivedScopes({
    dynamic teacherProfile,
    dynamic studentProfile,
  }) {
    final derivedCircleIds = <int>{...circleIds};
    if (teacherProfile is Map && teacherProfile['circle_ids'] is List) {
      derivedCircleIds.addAll(_intList(teacherProfile['circle_ids']));
    }
    if (studentProfile is Map && studentProfile['circle_id'] != null) {
      derivedCircleIds.add(_asInt(studentProfile['circle_id']));
    }

    return AuthUser(
      id: id,
      name: name,
      email: email,
      phone: phone,
      role: role,
      avatarUrl: avatarUrl,
      branchId: branchId,
      centerId: centerId,
      branchIds: branchIds,
      centerIds: centerIds,
      circleIds: derivedCircleIds.toList(growable: false),
      permissions: permissions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'avatar_url': avatarUrl,
      'branch_id': branchId,
      'center_id': centerId,
      'branch_ids': branchIds,
      'center_ids': centerIds,
      'circle_ids': circleIds,
      'permissions': permissions,
    };
  }

  static Map<String, dynamic> _unwrapUser(Map<String, dynamic> json) {
    final data = json['data'];
    if (json['user'] is Map) return Map<String, dynamic>.from(json['user'] as Map);
    if (data is Map && data['user'] is Map) return Map<String, dynamic>.from(data['user'] as Map);
    if (data is Map && data.containsKey('id')) return Map<String, dynamic>.from(data);
    return json;
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse('$value') ?? 0;
  }

  static int? _nullableInt(dynamic value) {
    if (value == null) return null;
    final parsed = _asInt(value);
    return parsed == 0 ? null : parsed;
  }

  static List<int> _intList(dynamic value) {
    if (value is! List) return const [];
    return value.map(_asInt).where((id) => id > 0).toList(growable: false);
  }
}

