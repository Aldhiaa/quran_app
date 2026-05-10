import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../services/teacher_service.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/quran_range_picker.dart';

const _kPerformanceLevels = ['ممتاز', 'جيد جداً', 'جيد', 'مقبول', 'ضعيف'];
const _kPerfApi = ['excellent', 'very_good', 'good', 'acceptable', 'weak'];

class _StudentEntry {
  final int studentId;
  final String name;
  String performance;
  QuranRange? memorization;
  QuranRange? review;
  String note;

  _StudentEntry({required this.studentId, required this.name, this.performance = 'جيد جداً', this.note = ''});

  Map<String, dynamic> toJson() {
    final perfIdx = _kPerformanceLevels.indexOf(performance);
    return {
      'student_id': studentId,
      'performance_level': perfIdx >= 0 ? _kPerfApi[perfIdx] : 'good',
      if (memorization != null) ...{
        'memorization_from_surah': memorization!.fromSurah,
        'memorization_from_ayah': memorization!.fromAyah,
        'memorization_to_surah': memorization!.toSurah,
        'memorization_to_ayah': memorization!.toAyah,
      },
      if (review != null) ...{
        'review_from_surah': review!.fromSurah,
        'review_from_ayah': review!.fromAyah,
        'review_to_surah': review!.toSurah,
        'review_to_ayah': review!.toAyah,
      },
      if (note.isNotEmpty) 'teacher_note': note,
    };
  }
}

class DailyReportEntryScreen extends StatefulWidget {
  const DailyReportEntryScreen({super.key});

  @override
  State<DailyReportEntryScreen> createState() => _DailyReportEntryScreenState();
}

class _DailyReportEntryScreenState extends State<DailyReportEntryScreen> {
  final _teacher = TeacherService();
  bool _loading = true;
  bool _saving = false;
  String? _error;

  List<Map<String, dynamic>> _circles = [];
  int? _circleId;
  List<_StudentEntry> _entries = [];
  final _generalNotes = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  int? _toInt(dynamic v) => v is int ? v : int.tryParse('${v ?? ''}');
  String _name(Map<String, dynamic> s) =>
      (s['name'] ?? s['full_name'] ?? s['user']?['name'] ?? 'طالب').toString();

  Future<void> _bootstrap() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      _circles = await _teacher.getCircles();
      if (_circles.isNotEmpty) {
        _circleId = _toInt(_circles.first['id']);
        await _loadStudents();
      }
      setState(() => _loading = false);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _loadStudents() async {
    if (_circleId == null) return;
    List<Map<String, dynamic>> students;
    try {
      students = await _teacher.getCircleStudents(_circleId!);
    } catch (_) {
      students = await _teacher.getStudents();
    }
    _entries = students.map((s) {
      final id = _toInt(s['id']) ?? 0;
      return _StudentEntry(studentId: id, name: _name(s));
    }).toList();
    setState(() {});
  }

  Future<void> _submit() async {
    if (_circleId == null) return;
    setState(() => _saving = true);
    try {
      final teacherId = Provider.of<AuthProvider>(context, listen: false).user?.teacherId ?? 0;
      final session = await _teacher.createDailySession({
        'circle_id': _circleId,
        'teacher_id': teacherId,
        'session_date': DateTime.now().toIso8601String().split('T').first,
        'general_notes': _generalNotes.text,
      });
      final sessionId = _toInt(session['id'] ?? session['data']?['id']);
      if (sessionId != null) {
        await _teacher.submitSessionEntries(
          sessionId: sessionId,
          entries: _entries.map((e) => e.toJson()).toList(),
        );
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ التقرير اليومي'), backgroundColor: AppColors.success),
      );
      Navigator.maybePop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: $e'), backgroundColor: AppColors.danger),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _generalNotes.dispose();
    _teacher.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final body = _loading
        ? const Center(child: CircularProgressIndicator())
        : _error != null
            ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
            : ListView(
                children: [
                  if (_circles.length > 1)
                    DropdownButtonFormField<int>(
                      value: _circleId,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'الحلقة'),
                      items: _circles.map((c) {
                        final id = _toInt(c['id']) ?? 0;
                        return DropdownMenuItem(value: id, child: Text(c['name']?.toString() ?? 'حلقة'));
                      }).toList(),
                      onChanged: (v) {
                        setState(() => _circleId = v);
                        _loadStudents();
                      },
                    ),
                  const SizedBox(height: 8),
                  ..._entries.asMap().entries.map((e) => _buildStudentCard(e.key, e.value)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _generalNotes,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'ملاحظات عامة على الجلسة'),
                  ),
                  const SizedBox(height: 80),
                ],
              );

    return AppShell(
      title: 'التقرير اليومي',
      body: body,
      bottomNavigationBar: PrimaryBottomButton(
        title: _saving ? 'جاري الحفظ...' : 'حفظ التقرير',
        onPressed: _saving || _loading ? null : _submit,
      ),
    );
  }

  Widget _buildStudentCard(int idx, _StudentEntry e) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                CircleAvatar(child: Text('${idx + 1}')),
                const SizedBox(width: 10),
                Expanded(child: Text(e.name, style: const TextStyle(fontWeight: FontWeight.bold))),
              ]),
              const SizedBox(height: 10),
              QuranRangePicker(
                label: 'الحفظ',
                initialRange: e.memorization,
                onChanged: (r) => e.memorization = r,
              ),
              const SizedBox(height: 8),
              QuranRangePicker(
                label: 'المراجعة',
                initialRange: e.review,
                onChanged: (r) => e.review = r,
              ),
              const SizedBox(height: 8),
              const Text('الأداء', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                children: _kPerformanceLevels.map((p) {
                  final selected = e.performance == p;
                  return ChoiceChip(
                    label: Text(p),
                    selected: selected,
                    onSelected: (_) => setState(() => e.performance = p),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(labelText: 'ملاحظة على الطالب', isDense: true),
                onChanged: (v) => e.note = v,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
