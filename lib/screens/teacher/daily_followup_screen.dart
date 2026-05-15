import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_theme.dart';
import '../../data/quran_surahs.dart';
import '../../providers/teacher_provider.dart';
import '../../widgets/common_widgets.dart';

/// The "دفتر المتابعة" (Daily Follow-up Notebook) — the core teacher screen
/// for tracking every student's daily progress in memorization, review,
/// attendance, quality, and notes.
class DailyFollowupScreen extends StatefulWidget {
  final int? circleId;

  const DailyFollowupScreen({super.key, this.circleId});

  @override
  State<DailyFollowupScreen> createState() => _DailyFollowupScreenState();
}

class _DailyFollowupScreenState extends State<DailyFollowupScreen> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initSession();
    });
  }

  Future<void> _initSession() async {
    final provider = context.read<TeacherProvider>();
    final circleId = widget.circleId ?? _extractCircleId(provider.selectedCircle);
    if (circleId != null) {
      await provider.loadTodaySession(circleId);
    } else {
      // No circle selected, load circles first
      await provider.loadCircles();
      if (provider.circles.isNotEmpty && mounted) {
        final first = provider.circles.first;
        provider.selectCircle(first);
        await provider.loadTodaySession(_extractInt(first['id']) ?? 0);
      }
    }
    if (mounted) setState(() => _initialized = true);
  }

  Future<void> _refresh() async {
    final provider = context.read<TeacherProvider>();
    final circleId = widget.circleId ?? _extractCircleId(provider.selectedCircle);
    if (circleId != null) {
      await provider.loadTodaySession(circleId);
    }
  }

  /// Safely extract an integer ID from a dynamic value (handles both int and string IDs from API).
  static int? _extractInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse('$value');
  }

  /// Safely extract the circle ID from a circle map.
  static int? _extractCircleId(Map<String, dynamic>? circle) {
    if (circle == null) return null;
    return _extractInt(circle['id']);
  }

  @override
  Widget build(BuildContext context) {
    final teacher = context.watch<TeacherProvider>();
    final session = teacher.todaySession;
    final entries = teacher.sessionEntries;
    final circle = teacher.selectedCircle;
    final isLoading = teacher.isLoading;

    final circleName = circle?['name'] ?? circle?['circle_name'] ?? 'الحلقة';
    final studentCount = circle?['students_count'] ?? circle?['active_students_count'] ?? entries.length;
    final sessionDate = session?['session_date'] ?? session?['date_hijri'] ?? 'اليوم';
    final sessionStatus = session?['status'] as String?;

    return GreenHeaderScaffold(
      title: 'دفتر المتابعة',
      headerExtra: _buildHeaderInfo(circleName, studentCount, sessionDate, sessionStatus),
      bottomNavigationBar: _buildBottomBar(teacher, entries),
      child: _buildBody(context, teacher, entries, isLoading),
    );
  }

  Widget _buildHeaderInfo(String circleName, dynamic studentCount, String sessionDate, String? status) {
    final isDraft = status == 'draft' || status == 'مسودة';
    final isSubmitted = status == 'submitted' || status == 'مُقدم';
    return AppCard(
      color: Colors.white.withValues(alpha: .12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(children: [
        Icon(Icons.calendar_month_rounded, color: AppColors.accentGold, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$circleName • $studentCount طالب',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
              const SizedBox(height: 2),
              Text(sessionDate,
                  style: TextStyle(color: Colors.white.withValues(alpha: .7), fontSize: 12)),
            ],
          ),
        ),
        if (isDraft)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: .2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('مسودة', style: TextStyle(color: AppColors.warning, fontSize: 11, fontWeight: FontWeight.w700)),
          )
        else if (isSubmitted)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: .2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('مُقدم', style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w700)),
          ),
      ]),
    );
  }

  Widget _buildBody(BuildContext context, TeacherProvider teacher, List<Map<String, dynamic>> entries, bool isLoading) {
    if (isLoading && entries.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (entries.isEmpty) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: const [
          AppCard(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(children: [
                Icon(Icons.person_off_rounded, size: 48, color: AppColors.muted),
                SizedBox(height: 12),
                Text('لا يوجد طلاب في هذه الحلقة',
                    style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.muted)),
              ]),
            ),
          ),
        ],
      );
    }

    // Count attendance summary
    final present = entries.where((e) => e['attendance_status'] == 'present').length;
    final absent = entries.where((e) => e['attendance_status'] == 'absent').length;
    final late = entries.where((e) => e['attendance_status'] == 'late').length;
    final excused = entries.where((e) => e['attendance_status'] == 'excused').length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      children: [
        // Attendance summary chips
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _AttendanceChip(icon: Icons.check_circle, label: 'حاضر', count: present, color: AppColors.success),
              _AttendanceChip(icon: Icons.access_time, label: 'متأخر', count: late, color: AppColors.warning),
              _AttendanceChip(icon: Icons.person_off, label: 'معذور', count: excused, color: AppColors.info),
              _AttendanceChip(icon: Icons.cancel, label: 'غائب', count: absent, color: AppColors.danger),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Student entries
        ...List.generate(entries.length, (i) {
          final entry = entries[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _StudentEntryCard(
              entry: entry,
              index: i,
              onTap: () => _openStudentEntrySheet(context, teacher, entry, i),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildBottomBar(TeacherProvider teacher, List<Map<String, dynamic>> entries) {
    if (entries.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: teacher.isLoading
                  ? null
                  : () async {
                      final saved = await teacher.saveSessionAsDraft();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(saved ? 'تم حفظ المسودة' : 'فشل الحفظ'),
                            backgroundColor: saved ? AppColors.success : AppColors.danger,
                          ),
                        );
                      }
                    },
              icon: const Icon(Icons.save_rounded, size: 18),
              label: const Text('حفظ كمسودة'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: teacher.isLoading
                  ? null
                  : () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (c) => AlertDialog(
                          title: const Text('تقديم الجلسة'),
                          content: const Text('هل أنت متأكد من تقديم جلسة اليوم؟ لن تتمكن من تعديلها بعد التقديم.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('إلغاء')),
                            ElevatedButton(onPressed: () => Navigator.pop(c, true), child: const Text('تقديم')),
                          ],
                        ),
                      );
                      if (confirm == true && mounted) {
                        final submitted = await teacher.submitSession();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(submitted ? 'تم تقديم الجلسة بنجاح' : 'فشل التقديم'),
                              backgroundColor: submitted ? AppColors.success : AppColors.danger,
                            ),
                          );
                          if (submitted) Navigator.pop(context, true);
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.send_rounded, size: 18),
              label: const Text('تقديم'),
            ),
          ),
        ]),
      ),
    );
  }

  /// Opens the detailed student entry form as a modal bottom sheet.
  void _openStudentEntrySheet(
      BuildContext context, TeacherProvider teacher, Map<String, dynamic> entry, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => _StudentEntrySheet(
        entry: Map<String, dynamic>.from(entry),
        index: index,
        onSave: (updated) {
          teacher.updateStudentEntry(index, updated);
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  ATTENDANCE CHIP
// ═══════════════════════════════════════════════════════════════

class _AttendanceChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _AttendanceChip({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 2),
        Text('$count', style: TextStyle(fontWeight: FontWeight.w800, color: color, fontSize: 16)),
        Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 10)),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  STUDENT ENTRY CARD
// ═══════════════════════════════════════════════════════════════

class _StudentEntryCard extends StatelessWidget {
  final Map<String, dynamic> entry;
  final int index;
  final VoidCallback onTap;

  const _StudentEntryCard({
    required this.entry,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final name = entry['student_name'] as String? ?? 'طالب';
    final status = entry['attendance_status'] as String? ?? 'present';

    // Build status info
    String statusText;
    BadgeKind badgeKind;
    Color statusColor;
    switch (status) {
      case 'late':
        statusText = 'متأخر';
        badgeKind = BadgeKind.warning;
        statusColor = AppColors.warning;
        break;
      case 'excused':
        statusText = 'معذور';
        badgeKind = BadgeKind.info;
        statusColor = AppColors.info;
        break;
      case 'absent':
        statusText = 'غائب';
        badgeKind = BadgeKind.danger;
        statusColor = AppColors.danger;
        break;
      default:
        statusText = 'حاضر';
        badgeKind = BadgeKind.success;
        statusColor = AppColors.success;
    }

    // Build memorization range text
    final fromSurah = entry['new_memorization_from_surah'] as int?;
    final fromAyah = entry['new_memorization_from_ayah'] as int?;
    final toSurah = entry['new_memorization_to_surah'] as int?;
    final toAyah = entry['new_memorization_to_ayah'] as int?;

    String memRange = '';
    if (fromSurah != null && toSurah != null) {
      final fromName = _surahName(fromSurah);
      final toName = _surahName(toSurah);
      if (fromSurah == toSurah) {
        memRange = '$fromName ${fromAyah ?? 1} → ${toAyah ?? ''}';
      } else {
        memRange = '$fromName ${fromAyah ?? 1} → $toName ${toAyah ?? ''}';
      }
    } else {
      memRange = 'لم يُدخل';
    }

    // Quality
    final quality = (entry['performance'] as num?)?.toDouble() ?? 0.0;

    // Flags
    final hasWeakness = entry['weakness_flag'] == true;
    final hasParentContact = entry['parent_contacted'] == true;
    final hasNotes = (entry['notes'] as String?)?.isNotEmpty == true ||
        (entry['tajweed_observations'] as String?)?.isNotEmpty == true;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Name + Status + Flags
          Row(children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.accentGold.withValues(alpha: .18),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                name[0],
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(memRange, style: const TextStyle(color: AppColors.muted, fontSize: 11.5)),
                ],
              ),
            ),
            // Flag icons
            Row(mainAxisSize: MainAxisSize.min, children: [
              if (hasWeakness)
                const Icon(Icons.priority_high_rounded, color: AppColors.danger, size: 18),
              if (hasParentContact)
                const Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Icon(Icons.phone_in_talk_rounded, color: AppColors.info, size: 18),
                ),
              if (hasNotes)
                const Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Icon(Icons.description_rounded, color: AppColors.accentGold, size: 18),
                ),
              const SizedBox(width: 6),
              StatusBadge(text: statusText, kind: badgeKind),
            ]),
          ]),
          const SizedBox(height: 10),

          // Row 2: Quality bar + Review info
          Row(children: [
            const Text('جودة الحفظ',
                style: TextStyle(color: AppColors.muted, fontSize: 11, fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: LinearProgressIndicator(
                  value: quality > 0 ? quality : 0,
                  minHeight: 6,
                  backgroundColor: AppColors.primary.withValues(alpha: .1),
                  color: statusColor,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(quality > 0 ? '${(quality * 100).round()}٪' : '--',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: quality > 0 ? AppColors.primary : AppColors.muted,
                  fontSize: 13,
                )),
          ]),

          // Row 3: Review range (if any)
          if (entry['review_from_surah'] != null) ...[
            const SizedBox(height: 6),
            Row(children: [
              const Icon(Icons.replay_rounded, size: 14, color: AppColors.muted),
              const SizedBox(width: 4),
              Text('مراجعة: ${_buildReviewText(entry)}',
                  style: const TextStyle(color: AppColors.muted, fontSize: 11)),
            ]),
          ],
        ],
      ),
    );
  }

  String _buildReviewText(Map<String, dynamic> entry) {
    final fromSurah = entry['review_from_surah'] as int?;
    final fromAyah = entry['review_from_ayah'] as int?;
    final toSurah = entry['review_to_surah'] as int?;
    final toAyah = entry['review_to_ayah'] as int?;

    if (fromSurah == null) return '--';
    final fromName = _surahName(fromSurah);
    if (toSurah == null) return fromName;
    final toName = _surahName(toSurah);
    if (fromSurah == toSurah) {
      return '$fromName ${fromAyah ?? 1} → ${toAyah ?? ''}';
    }
    return '$fromName ${fromAyah ?? 1} → $toName ${toAyah ?? ''}';
  }

  static String _surahName(int number) {
    if (number >= 1 && number <= kQuranSurahs.length) {
      return kQuranSurahs[number - 1].arabicName;
    }
    return 'سورة $number';
  }
}

// ═══════════════════════════════════════════════════════════════
//  STUDENT ENTRY BOTTOM SHEET  (the detailed form)
// ═══════════════════════════════════════════════════════════════

class _StudentEntrySheet extends StatefulWidget {
  final Map<String, dynamic> entry;
  final int index;
  final void Function(Map<String, dynamic>) onSave;

  const _StudentEntrySheet({
    required this.entry,
    required this.index,
    required this.onSave,
  });

  @override
  State<_StudentEntrySheet> createState() => _StudentEntrySheetState();
}

class _StudentEntrySheetState extends State<_StudentEntrySheet> {
  late Map<String, dynamic> _data;

  // Controllers
  final _tajweedCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _newFromAyahCtrl = TextEditingController();
  final _newToAyahCtrl = TextEditingController();
  final _reviewFromAyahCtrl = TextEditingController();
  final _reviewToAyahCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _data = Map<String, dynamic>.from(widget.entry);

    // Initialize controllers from existing data
    _tajweedCtrl.text = _data['tajweed_observations'] as String? ?? '';
    _notesCtrl.text = _data['notes'] as String? ?? '';
    _newFromAyahCtrl.text = _data['new_memorization_from_ayah']?.toString() ?? '';
    _newToAyahCtrl.text = _data['new_memorization_to_ayah']?.toString() ?? '';
    _reviewFromAyahCtrl.text = _data['review_from_ayah']?.toString() ?? '';
    _reviewToAyahCtrl.text = _data['review_to_ayah']?.toString() ?? '';
  }

  @override
  void dispose() {
    _tajweedCtrl.dispose();
    _notesCtrl.dispose();
    _newFromAyahCtrl.dispose();
    _newToAyahCtrl.dispose();
    _reviewFromAyahCtrl.dispose();
    _reviewToAyahCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = _data['student_name'] as String? ?? 'طالب';
    final status = _data['attendance_status'] as String? ?? 'present';
    final quality = (_data['performance'] as num?)?.toDouble() ?? 0.0;
    final hasWeakness = _data['weakness_flag'] == true;
    final hasParentContact = _data['parent_contacted'] == true;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.accentGold.withValues(alpha: .18),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(name[0],
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 16)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                      Text('تعديل متابعة الطالب',
                          style: TextStyle(color: AppColors.muted, fontSize: 12)),
                    ],
                  ),
                ),
              ]),
            ),
            const Divider(),

            // ─── Attendance ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('الحضور', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(children: [
                    _AttendanceOption(
                      label: 'حاضر',
                      icon: Icons.check_circle,
                      color: AppColors.success,
                      selected: status == 'present',
                      onTap: () => setState(() => _data['attendance_status'] = 'present'),
                    ),
                    const SizedBox(width: 6),
                    _AttendanceOption(
                      label: 'متأخر',
                      icon: Icons.access_time,
                      color: AppColors.warning,
                      selected: status == 'late',
                      onTap: () => setState(() => _data['attendance_status'] = 'late'),
                    ),
                    const SizedBox(width: 6),
                    _AttendanceOption(
                      label: 'معذور',
                      icon: Icons.person_off,
                      color: AppColors.info,
                      selected: status == 'excused',
                      onTap: () => setState(() => _data['attendance_status'] = 'excused'),
                    ),
                    const SizedBox(width: 6),
                    _AttendanceOption(
                      label: 'غائب',
                      icon: Icons.cancel,
                      color: AppColors.danger,
                      selected: status == 'absent',
                      onTap: () => setState(() => _data['attendance_status'] = 'absent'),
                    ),
                  ]),
                ],
              ),
            ),
            const Divider(),

            // ─── New Memorization ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(children: [
                    Icon(Icons.menu_book_rounded, size: 18, color: AppColors.primary),
                    SizedBox(width: 6),
                    Text('الحفظ الجديد', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  ]),
                  const SizedBox(height: 10),
                  // From
                  Row(children: [
                    const Text('من:', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                    const SizedBox(width: 8),
                    Expanded(child: _SurahDropdown(
                      value: _data['new_memorization_from_surah'] as int?,
                      onChanged: (v) => _data['new_memorization_from_surah'] = v,
                    )),
                    const SizedBox(width: 6),
                    SizedBox(
                      width: 60,
                      child: _AyahField(
                        controller: _newFromAyahCtrl,
                        onChanged: (v) => _data['new_memorization_from_ayah'] = v,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  // To
                  Row(children: [
                    const Text('إلى:', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                    const SizedBox(width: 8),
                    Expanded(child: _SurahDropdown(
                      value: _data['new_memorization_to_surah'] as int?,
                      onChanged: (v) => _data['new_memorization_to_surah'] = v,
                    )),
                    const SizedBox(width: 6),
                    SizedBox(
                      width: 60,
                      child: _AyahField(
                        controller: _newToAyahCtrl,
                        onChanged: (v) => _data['new_memorization_to_ayah'] = v,
                      ),
                    ),
                  ]),
                ],
              ),
            ),
            const Divider(),

            // ─── Review ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(children: [
                    Icon(Icons.replay_rounded, size: 18, color: AppColors.info),
                    const SizedBox(width: 6),
                    Text('المراجعة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    const Text('من:', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                    const SizedBox(width: 8),
                    Expanded(child: _SurahDropdown(
                      value: _data['review_from_surah'] as int?,
                      onChanged: (v) => _data['review_from_surah'] = v,
                    )),
                    const SizedBox(width: 6),
                    SizedBox(
                      width: 60,
                      child: _AyahField(
                        controller: _reviewFromAyahCtrl,
                        onChanged: (v) => _data['review_from_ayah'] = v,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    const Text('إلى:', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                    const SizedBox(width: 8),
                    Expanded(child: _SurahDropdown(
                      value: _data['review_to_surah'] as int?,
                      onChanged: (v) => _data['review_to_surah'] = v,
                    )),
                    const SizedBox(width: 6),
                    SizedBox(
                      width: 60,
                      child: _AyahField(
                        controller: _reviewToAyahCtrl,
                        onChanged: (v) => _data['review_to_ayah'] = v,
                      ),
                    ),
                  ]),
                ],
              ),
            ),
            const Divider(),

            // ─── Quality ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(children: [
                    Icon(Icons.star_rate_rounded, size: 18, color: AppColors.accentGold),
                    SizedBox(width: 6),
                    Text('جودة الحفظ', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(
                      child: Slider(
                        value: quality,
                        min: 0,
                        max: 1,
                        divisions: 20,
                        activeColor: AppColors.primary,
                        label: '${(quality * 100).round()}%',
                        onChanged: (v) => setState(() => _data['performance'] = v),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: Text('${(quality * 100).round()}%',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary)),
                    ),
                  ]),
                ],
              ),
            ),
            const Divider(),

            // ─── Tajweed Observations ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ملاحظات التجويد', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _tajweedCtrl,
                    decoration: const InputDecoration(
                      hintText: 'أدخل ملاحظات التجويد...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    textInputAction: TextInputAction.next,
                    onChanged: (v) => _data['tajweed_observations'] = v,
                  ),
                ],
              ),
            ),
            const Divider(),

            // ─── General Notes ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ملاحظات عامة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _notesCtrl,
                    decoration: const InputDecoration(
                      hintText: 'أدخل ملاحظات إضافية...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    maxLines: 2,
                    onChanged: (v) => _data['notes'] = v,
                  ),
                ],
              ),
            ),
            const Divider(),

            // ─── Toggles ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Row(children: [
                    Icon(Icons.priority_high_rounded, color: AppColors.danger, size: 20),
                    SizedBox(width: 8),
                    Text('ضعف في الحفظ / بحاجة متابعة', style: TextStyle(fontSize: 13)),
                  ]),
                  value: hasWeakness,
                  activeColor: AppColors.danger,
                  onChanged: (v) => setState(() => _data['weakness_flag'] = v),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Row(children: [
                    Icon(Icons.phone_in_talk_rounded, color: AppColors.info, size: 20),
                    SizedBox(width: 8),
                    Text('تم التواصل مع ولي الأمر', style: TextStyle(fontSize: 13)),
                  ]),
                  value: hasParentContact,
                  activeColor: AppColors.info,
                  onChanged: (v) => setState(() => _data['parent_contacted'] = v),
                ),
              ]),
            ),

            const SizedBox(height: 8),

            // ─── Save Button ───
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onSave(_data);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('حفظ', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  ATTENDANCE OPTION BUTTON
// ═══════════════════════════════════════════════════════════════

class _AttendanceOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _AttendanceOption({
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? color.withValues(alpha: .12) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? color : Colors.grey.shade200,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: selected ? color : AppColors.muted, size: 22),
              const SizedBox(height: 4),
              Text(label,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    color: selected ? color : AppColors.muted,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SURAH DROPDOWN
// ═══════════════════════════════════════════════════════════════

class _SurahDropdown extends StatelessWidget {
  final int? value;
  final void Function(int?) onChanged;

  const _SurahDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: value,
          isExpanded: true,
          hint: const Text('اختر', style: TextStyle(fontSize: 12)),
          items: [
            const DropdownMenuItem(value: null, child: Text('--', style: TextStyle(fontSize: 12))),
            ...kQuranSurahs.map((surah) => DropdownMenuItem(
                  value: surah.number,
                  child: Text('${surah.number}. ${surah.arabicName}',
                      style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
                )),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  AYAH NUMBER FIELD
// ═══════════════════════════════════════════════════════════════

class _AyahField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(int?) onChanged;

  const _AyahField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: 'آية',
        hintStyle: const TextStyle(fontSize: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        isDense: true,
      ),
      style: const TextStyle(fontSize: 13),
      onChanged: (v) => onChanged(int.tryParse(v)),
    );
  }
}
