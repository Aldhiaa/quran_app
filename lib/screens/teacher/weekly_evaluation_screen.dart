import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../services/teacher_service.dart';
import '../../widgets/common_widgets.dart';

const _criteria = [
  'الالتزام بالعبادات',
  'الأخلاق العامة وحسن الأدب',
  'الانضباط بالوقت',
  'الانضباط والاجتهاد في الحلقة',
  'الانضباط والاجتهاد في الدراسة النظامية',
  'النظافة الشخصية والعامة',
  'العناية بممتلكات المركز',
  'المبادرة والتعاون',
  'التميز في مجال محدد',
  'التأثير الإيجابي على الآخرين',
];

class WeeklyEvaluationScreen extends StatefulWidget {
  const WeeklyEvaluationScreen({super.key});

  @override
  State<WeeklyEvaluationScreen> createState() => _WeeklyEvaluationScreenState();
}

class _WeeklyEvaluationScreenState extends State<WeeklyEvaluationScreen> {
  final _teacher = TeacherService();
  bool _loading = true;
  bool _saving = false;
  String? _error;

  List<Map<String, dynamic>> _circles = [];
  int? _circleId;
  List<Map<String, dynamic>> _students = [];
  int? _studentId;

  final List<int> _scores = List<int>.filled(_criteria.length, 0);
  final _notes = TextEditingController();

  int get _total => _scores.fold(0, (a, b) => a + b);

  String get _rating {
    final t = _total;
    if (t >= 90) return 'ممتاز';
    if (t >= 80) return 'جيد جداً';
    if (t >= 70) return 'جيد';
    if (t >= 60) return 'مقبول';
    return 'يحتاج متابعة';
  }

  Color get _ratingColor {
    final t = _total;
    if (t >= 80) return AppColors.success;
    if (t >= 60) return AppColors.warning;
    return AppColors.danger;
  }

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
      } else {
        _students = await _teacher.getStudents();
        if (_students.isNotEmpty) _studentId = _toInt(_students.first['id']);
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
    if (_students.isNotEmpty) _studentId = _toInt(_students.first['id']);
    setState(() {});
  }

  Future<void> _submit() async {
    if (_studentId == null) return;
    setState(() => _saving = true);
    try {
      final teacherId = Provider.of<AuthProvider>(context, listen: false).user?.teacherId ?? 0;
      final body = {
        'teacher_id': teacherId,
        'student_id': _studentId,
        if (_circleId != null) 'circle_id': _circleId,
        'week_start': DateTime.now().subtract(const Duration(days: 7)).toIso8601String().split('T').first,
        'criteria': List.generate(_criteria.length, (i) => {
              'key': i,
              'label': _criteria[i],
              'score': _scores[i],
            }),
        'total': _total,
        'rating': _rating,
        'note': _notes.text,
      };
      await _teacher.submitWeeklyEvaluation(body);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ التقييم الأسبوعي'), backgroundColor: AppColors.success),
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
    _notes.dispose();
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
                  if (_students.isNotEmpty)
                    DropdownButtonFormField<int>(
                      value: _studentId,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'الطالب'),
                      items: _students.map((s) {
                        final id = _toInt(s['id']) ?? 0;
                        return DropdownMenuItem(value: id, child: Text(_name(s)));
                      }).toList(),
                      onChanged: (v) => setState(() => _studentId = v),
                    ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('معايير التقييم (10 نقاط لكل معيار)',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          ...List.generate(_criteria.length, (i) => _criterionRow(i)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    color: _ratingColor.withValues(alpha: 0.08),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('المجموع', style: TextStyle(color: Colors.grey)),
                              Text('$_total / 100',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('التقدير', style: TextStyle(color: Colors.grey)),
                              Text(_rating,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 22, color: _ratingColor)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _notes,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'ملاحظات'),
                  ),
                  const SizedBox(height: 80),
                ],
              );

    return AppShell(
      title: 'التقييم الأسبوعي',
      body: body,
      bottomNavigationBar: PrimaryBottomButton(
        title: _saving ? 'جاري الحفظ...' : 'حفظ التقييم',
        onPressed: _saving || _loading ? null : _submit,
      ),
    );
  }

  Widget _criterionRow(int i) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(_criteria[i])),
              Text('${_scores[i]}/10', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Slider(
            value: _scores[i].toDouble(),
            min: 0,
            max: 10,
            divisions: 10,
            label: '${_scores[i]}',
            onChanged: (v) => setState(() => _scores[i] = v.round()),
          ),
        ],
      ),
    );
  }
}
