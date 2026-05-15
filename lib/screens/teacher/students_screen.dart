import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_theme.dart';
import '../../providers/teacher_provider.dart';
import '../../widgets/common_widgets.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  int _filter = 0;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<TeacherProvider>().loadAllStudents();
    });
  }

  Future<void> _refresh() async {
    await context.read<TeacherProvider>().loadAllStudents();
  }

  @override
  Widget build(BuildContext context) {
    final teacher = context.watch<TeacherProvider>();
    final allStudents = teacher.students;
    final isLoading = teacher.isLoading;

    // Filter students
    List<Map<String, dynamic>> filtered = List.from(allStudents);

    // Search filter
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filtered = filtered.where((s) {
        final name = (s['full_name'] as String? ?? s['name'] as String? ?? '').toLowerCase();
        return name.contains(q);
      }).toList();
    }

    // Performance filter
    if (_filter == 1) {
      // Top students (attendance_rate > 90%)
      filtered = filtered.where((s) => (s['attendance_rate'] as num? ?? 0) >= 0.9).toList();
    } else if (_filter == 2) {
      // Needs follow-up (attendance_rate < 80%)
      filtered = filtered.where((s) => (s['attendance_rate'] as num? ?? 0) < 0.8).toList();
    } else if (_filter == 3) {
      // Weak (attendance_rate < 60% or has memorization issues)
      filtered = filtered.where((s) => (s['attendance_rate'] as num? ?? 0) < 0.6).toList();
    }

    return GreenHeaderScaffold(
      title: 'طلابي',
      showBack: false,
      headerExtra: SearchFilterBar(
        hint: 'بحث عن طالب',
        onChanged: (v) => setState(() => _searchQuery = v),
      ),
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          children: [
            FilterChipsBar(
              items: const ['الكل', 'متفوقون', 'متابعة', 'ضعاف'],
              selected: _filter,
              onChanged: (i) => setState(() => _filter = i),
            ),
            const SizedBox(height: 12),

            if (isLoading && filtered.isEmpty)
              const Center(child: Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(),
              ))
            else if (filtered.isEmpty)
              const AppCard(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(children: [
                    Icon(Icons.person_search_rounded, size: 48, color: AppColors.muted),
                    SizedBox(height: 12),
                    Text('لا يوجد طلاب مطابقين',
                        style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.muted)),
                  ]),
                ),
              )
            else
              ...filtered.map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _StudentListCard(
                      student: s,
                      onTap: () {
                        teacher.selectStudent(s);
                        Navigator.pushNamed(context, '/teacher/student-detail');
                      },
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}

class _StudentListCard extends StatelessWidget {
  final Map<String, dynamic> student;
  final VoidCallback onTap;

  const _StudentListCard({required this.student, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final name = student['full_name'] as String? ?? student['name'] as String? ?? 'طالب';
    final circleName = student['circle_name'] as String? ??
        student['circle']?['name'] as String? ??
        '';
    final parts = student['memorized_parts'] as int? ?? 0;
    final attendanceRate = (student['attendance_rate'] as num?)?.toDouble() ?? 0;
    final behavior = student['behavior'] as String? ?? '';
    final isActive = student['is_active'] as bool? ?? true;

    // Determine status based on attendance rate
    BadgeKind kind;
    String statusText;
    if (attendanceRate >= 0.9) {
      kind = BadgeKind.success;
      statusText = 'متفوق';
    } else if (attendanceRate >= 0.7) {
      kind = BadgeKind.info;
      statusText = 'جيد';
    } else if (attendanceRate >= 0.5) {
      kind = BadgeKind.warning;
      statusText = 'متابعة';
    } else {
      kind = BadgeKind.danger;
      statusText = 'ضعيف';
    }

    return AppCard(
      onTap: onTap,
      child: Row(children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.accentGold.withValues(alpha: .2),
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? AppColors.accentGold : AppColors.muted,
              width: 1.2,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            name[0],
            style: TextStyle(
              color: isActive ? AppColors.primary : AppColors.muted,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                  child: Text(name,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: isActive ? AppColors.text : AppColors.muted,
                      )),
                ),
                StatusBadge(text: statusText, kind: kind),
              ]),
              const SizedBox(height: 3),
              Text(
                circleName.isNotEmpty ? '$circleName • الجزء $parts' : 'الجزء $parts',
                style: const TextStyle(color: AppColors.muted, fontSize: 12.5),
              ),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: LinearProgressIndicator(
                      value: attendanceRate,
                      minHeight: 5,
                      backgroundColor: AppColors.primary.withValues(alpha: .1),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${(attendanceRate * 100).round()}٪',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: isActive ? AppColors.primary : AppColors.muted,
                    fontSize: 13,
                  ),
                ),
              ]),
            ],
          ),
        ),
      ]),
    );
  }
}
