import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../services/teacher_service.dart';
import '../../widgets/common_widgets.dart';

enum AttendanceStatus { present, late, excused, absent }

extension on AttendanceStatus {
  String get label => switch (this) {
        AttendanceStatus.present => 'حاضر',
        AttendanceStatus.late => 'متأخر',
        AttendanceStatus.excused => 'بعذر',
        AttendanceStatus.absent => 'غائب',
      };
  String get apiKey => switch (this) {
        AttendanceStatus.present => 'present',
        AttendanceStatus.late => 'late',
        AttendanceStatus.excused => 'absent_excused',
        AttendanceStatus.absent => 'absent_unexcused',
      };
  Color get color => switch (this) {
        AttendanceStatus.present => AppColors.success,
        AttendanceStatus.late => AppColors.warning,
        AttendanceStatus.excused => AppColors.info,
        AttendanceStatus.absent => AppColors.danger,
      };
}

class AttendanceEntryScreen extends StatefulWidget {
  const AttendanceEntryScreen({super.key});

  @override
  State<AttendanceEntryScreen> createState() => _AttendanceEntryScreenState();
}

class _AttendanceEntryScreenState extends State<AttendanceEntryScreen> {
  final _teacher = TeacherService();
  bool _loading = true;
  bool _saving = false;
  String? _error;
  String _query = '';

  List<Map<String, dynamic>> _circles = [];
  int? _circleId;
  List<Map<String, dynamic>> _students = [];
  final Map<int, AttendanceStatus> _status = {};
  final Map<int, String> _notes = {};

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

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
    try {
      _students = await _teacher.getCircleStudents(_circleId!);
    } catch (_) {
      _students = await _teacher.getStudents();
    }
    _status.clear();
    for (final s in _students) {
      final id = _toInt(s['id']);
      if (id != null) _status[id] = AttendanceStatus.present;
    }
    setState(() {});
  }

  int? _toInt(dynamic v) => v is int ? v : int.tryParse('${v ?? ''}');

  String _name(Map<String, dynamic> s) =>
      (s['name'] ?? s['full_name'] ?? s['user']?['name'] ?? 'طالب').toString();

  List<Map<String, dynamic>> get _filtered {
    if (_query.isEmpty) return _students;
    return _students.where((s) => _name(s).contains(_query)).toList();
  }

  Future<void> _markAllPresent() async {
    setState(() {
      for (final s in _students) {
        final id = _toInt(s['id']);
        if (id != null) _status[id] = AttendanceStatus.present;
      }
    });
  }

  Future<void> _submit() async {
    if (_circleId == null) return;
    setState(() => _saving = true);
    try {
      final entries = _students.map((s) {
        final id = _toInt(s['id']);
        return {
          'student_id': id,
          'status': (_status[id] ?? AttendanceStatus.present).apiKey,
          if ((_notes[id] ?? '').isNotEmpty) 'note': _notes[id],
        };
      }).toList();
      await _teacher.submitAttendance(
        circleId: _circleId!,
        date: DateTime.now().toIso8601String().split('T').first,
        entries: entries,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ الحضور'), backgroundColor: AppColors.success),
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
    _teacher.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final body = _loading
        ? const Center(child: CircularProgressIndicator())
        : _error != null
            ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
            : Column(
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
                  TextField(
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'بحث عن طالب'),
                    onChanged: (v) => setState(() => _query = v),
                  ),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.done_all),
                        label: const Text('الكل حاضر'),
                        onPressed: _markAllPresent,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('${_filtered.length} طالب', style: const TextStyle(color: Colors.grey)),
                  ]),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _filtered.isEmpty
                        ? const Center(child: Text('لا يوجد طلاب'))
                        : ListView.separated(
                            itemCount: _filtered.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 6),
                            itemBuilder: (context, i) {
                              final s = _filtered[i];
                              final id = _toInt(s['id']) ?? 0;
                              final st = _status[id] ?? AttendanceStatus.present;
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        CircleAvatar(child: Text(_name(s).characters.first)),
                                        const SizedBox(width: 10),
                                        Expanded(child: Text(_name(s), style: const TextStyle(fontWeight: FontWeight.w700))),
                                      ]),
                                      const SizedBox(height: 8),
                                      Wrap(
                                        spacing: 6,
                                        children: AttendanceStatus.values.map((opt) {
                                          final selected = st == opt;
                                          return ChoiceChip(
                                            label: Text(opt.label),
                                            selected: selected,
                                            selectedColor: opt.color.withValues(alpha: 0.2),
                                            onSelected: (_) => setState(() => _status[id] = opt),
                                          );
                                        }).toList(),
                                      ),
                                      if (st == AttendanceStatus.excused || st == AttendanceStatus.late) ...[
                                        const SizedBox(height: 6),
                                        TextField(
                                          decoration: const InputDecoration(hintText: 'العذر / الملاحظة', isDense: true),
                                          onChanged: (v) => _notes[id] = v,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );

    return AppShell(
      title: 'الحضور',
      body: body,
      bottomNavigationBar: PrimaryBottomButton(
        title: _saving ? 'جاري الحفظ...' : 'حفظ الحضور',
        onPressed: _saving || _loading ? null : _submit,
      ),
    );
  }
}
