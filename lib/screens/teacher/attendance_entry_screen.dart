import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_theme.dart';
import '../../providers/teacher_provider.dart';
import '../../widgets/common_widgets.dart';

/// Attendance entry screen where teacher can mark attendance for all students.
/// Connected to the TeacherProvider for real data.
class AttendanceEntryScreen extends StatefulWidget {
  const AttendanceEntryScreen({super.key});

  @override
  State<AttendanceEntryScreen> createState() => _AttendanceEntryScreenState();
}

class _AttendanceEntryScreenState extends State<AttendanceEntryScreen> {
  int _selectedCircleIndex = 0;
  List<Map<String, dynamic>> _students = [];
  List<String> _statuses = [];
  bool _loading = false;

  // Attendance statuses
  static const _statusLabels = ['حاضر', 'متأخر', 'معذور', 'غائب'];
  static const _statusValues = ['present', 'late', 'excused', 'absent'];
  static const _statusColors = [AppColors.success, AppColors.warning, AppColors.info, AppColors.danger];
  static const _statusIcons = [Icons.check_circle, Icons.access_time, Icons.person_off, Icons.cancel];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadStudents();
    });
  }

  Future<void> _loadStudents() async {
    final teacher = context.read<TeacherProvider>();
    setState(() => _loading = true);

    // Load circles if not already loaded
    if (teacher.circles.isEmpty) {
      await teacher.loadCircles();
    }

    if (teacher.circles.isNotEmpty) {
      final circleId = teacher.circles[_selectedCircleIndex]['id'] as int;
      await teacher.loadCircleStudents(circleId);
      setState(() {
        _students = List.from(teacher.circleStudents);
        _statuses = List.filled(_students.length, 'present');
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final teacher = context.watch<TeacherProvider>();
    final circles = teacher.circles;

    // Count statuses
    final present = _statuses.where((s) => s == 'present').length;
    final late = _statuses.where((s) => s == 'late').length;
    final excused = _statuses.where((s) => s == 'excused').length;
    final absent = _statuses.where((s) => s == 'absent').length;

    return GreenHeaderScaffold(
      title: 'تسجيل الحضور',
      headerExtra: AppCard(
        color: Colors.white.withValues(alpha: .12),
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          const Icon(Icons.calendar_today_rounded, color: AppColors.accentGold),
          const SizedBox(width: 8),
          Text('اليوم',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          const Spacer(),
          Text('$present / ${_students.length}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        ]),
      ),
      bottomNavigationBar: _buildBottomBar(teacher),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          // Circle selector
          if (circles.isNotEmpty)
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('اختر الحلقة', style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  FilterChipsBar(
                    items: circles.map((c) => c['name'] as String? ?? 'حلقة').toList(),
                    selected: _selectedCircleIndex,
                    onChanged: (i) {
                      setState(() {
                        _selectedCircleIndex = i;
                        _loading = true;
                      });
                      _loadStudents();
                    },
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),

          // Status summary
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatusSummary(label: 'حاضر', count: present, color: AppColors.success),
                _StatusSummary(label: 'متأخر', count: late, color: AppColors.warning),
                _StatusSummary(label: 'معذور', count: excused, color: AppColors.info),
                _StatusSummary(label: 'غائب', count: absent, color: AppColors.danger),
              ],
            ),
          ),
          const SizedBox(height: 12),

          if (_loading)
            const Center(child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            ))
          else if (_students.isEmpty)
            const AppCard(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(children: [
                  Icon(Icons.person_off_rounded, size: 48, color: AppColors.muted),
                  SizedBox(height: 12),
                  Text('لا يوجد طلاب',
                      style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.muted)),
                ]),
              ),
            )
          else
            ...List.generate(_students.length, (i) {
              final student = _students[i];
              final name = student['full_name'] as String? ?? student['name'] as String? ?? 'طالب';
              final statusIdx = _statusValues.indexOf(_statuses[i]);
              final color = _statusColors[statusIdx >= 0 ? statusIdx : 0];

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: AppCard(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: .15),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(_statusIcons[statusIdx >= 0 ? statusIdx : 0],
                          color: color, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(name,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(4, (j) {
                        final selected = _statuses[i] == _statusValues[j];
                        return GestureDetector(
                          onTap: () => setState(() => _statuses[i] = _statusValues[j]),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              color: selected
                                  ? _statusColors[j].withValues(alpha: .15)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: selected ? _statusColors[j] : Colors.grey.shade200,
                                width: selected ? 1.5 : 1,
                              ),
                            ),
                            child: Text(
                              _statusLabels[j],
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: selected ? _statusColors[j] : AppColors.muted,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ]),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildBottomBar(TeacherProvider teacher) {
    if (_students.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: _loading
                ? null
                : () async {
                    if (teacher.circles.isEmpty) return;
                    final circleId = teacher.circles[_selectedCircleIndex]['id'] as int;

                    final entries = List.generate(_students.length, (i) => {
                      'student_id': _students[i]['id'],
                      'status': _statuses[i],
                    });

                    final success = await teacher.submitAttendance(
                      circleId: circleId,
                      date: DateTime.now().toIso8601String().split('T')[0],
                      entries: entries,
                    );

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(success ? 'تم حفظ الحضور بنجاح' : 'فشل حفظ الحضور'),
                          backgroundColor: success ? AppColors.success : AppColors.danger,
                        ),
                      );
                      if (success) Navigator.pop(context);
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.save_rounded),
            label: const Text('حفظ الحضور', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          ),
        ),
      ),
    );
  }
}

class _StatusSummary extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatusSummary({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$count', style: TextStyle(fontWeight: FontWeight.w800, color: color, fontSize: 18)),
        Text(label,
            style: const TextStyle(color: AppColors.muted, fontSize: 11)),
      ],
    );
  }
}
