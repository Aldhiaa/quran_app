import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../services/teacher_service.dart';
import '../../widgets/common_widgets.dart';

class GradesEntryScreen extends StatefulWidget {
  const GradesEntryScreen({super.key});

  @override
  State<GradesEntryScreen> createState() => _GradesEntryScreenState();
}

class _GradesEntryScreenState extends State<GradesEntryScreen> {
  final _teacherService = TeacherService();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _submitted = false;

  String? _selectedTestId;
  String? _selectedStudentId;
  final _memorizationCtrl = TextEditingController(text: '0');
  final _recitationCtrl = TextEditingController(text: '0');
  final _ahkamCtrl = TextEditingController(text: '0');
  final _matnCtrl = TextEditingController(text: '0');
  final _behaviorCtrl = TextEditingController(text: '0');
  final _notesCtrl = TextEditingController();

  static const _maxMemorization = 50;
  static const _maxRecitation = 50;
  static const _maxAhkam = 30;
  static const _maxMatn = 20;
  static const _maxBehavior = 50;
  static const _totalMax = 200;

  int _val(TextEditingController c) => int.tryParse(c.text) ?? 0;
  int _clamp(int v, int max) => v < 0 ? 0 : (v > max ? max : v);

  int get _total =>
      _clamp(_val(_memorizationCtrl), _maxMemorization) +
      _clamp(_val(_recitationCtrl), _maxRecitation) +
      _clamp(_val(_ahkamCtrl), _maxAhkam) +
      _clamp(_val(_matnCtrl), _maxMatn) +
      _clamp(_val(_behaviorCtrl), _maxBehavior);

  double get _percent => _total / _totalMax * 100;

  String get _rating {
    final p = _percent;
    if (p >= 90) return 'ممتاز';
    if (p >= 80) return 'جيد جداً';
    if (p >= 70) return 'جيد';
    if (p >= 60) return 'مقبول';
    return 'ضعيف';
  }

  Color get _ratingColor {
    final p = _percent;
    if (p >= 80) return AppColors.success;
    if (p >= 60) return AppColors.warning;
    return AppColors.danger;
  }

  List<Map<String, dynamic>> _tests = [];
  List<Map<String, dynamic>> _students = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    for (final c in [_memorizationCtrl, _recitationCtrl, _ahkamCtrl, _matnCtrl, _behaviorCtrl]) {
      c.addListener(() => setState(() {}));
    }
  }

  Future<void> _loadData() async {
    try {
      final results = await Future.wait([
        _teacherService.getMonthlyTests(),
        _teacherService.getStudents(),
      ]);
      setState(() {
        _tests = results[0] as List<Map<String, dynamic>>;
        _students = results[1] as List<Map<String, dynamic>>;
        if (_tests.isNotEmpty) _selectedTestId = '${_tests.first['id']}';
        if (_students.isNotEmpty) _selectedStudentId = '${_students.first['id']}';
      });
    } catch (_) {}
  }

  Future<void> _submit() async {
    if (_selectedTestId == null || _selectedStudentId == null) return;
    setState(() => _loading = true);

    try {
      await _teacherService.saveTestResults(int.parse(_selectedTestId!), [
        {
          'student_id': int.parse(_selectedStudentId!),
          'memorization_score': _clamp(_val(_memorizationCtrl), _maxMemorization),
          'recitation_score': _clamp(_val(_recitationCtrl), _maxRecitation),
          'ahkam_score': _clamp(_val(_ahkamCtrl), _maxAhkam),
          'matn_score': _clamp(_val(_matnCtrl), _maxMatn),
          'behavior_score': _clamp(_val(_behaviorCtrl), _maxBehavior),
          'total_score': _total,
          'percentage': double.parse(_percent.toStringAsFixed(2)),
          'rating': _rating,
          'notes': _notesCtrl.text,
        },
      ]);
      setState(() => _submitted = true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ الدرجات بنجاح'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _memorizationCtrl.dispose();
    _recitationCtrl.dispose();
    _ahkamCtrl.dispose();
    _matnCtrl.dispose();
    _behaviorCtrl.dispose();
    _notesCtrl.dispose();
    _teacherService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return AppShell(
        title: 'إضافة درجات الطالب',
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 64),
              SizedBox(height: 16),
              Text('تم حفظ الدرجات بنجاح', style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      );
    }

    return Form(
      key: _formKey,
      child: AppShell(
        title: 'إضافة درجات الطالب',
        body: ListView(
          children: [
            if (_tests.isNotEmpty)
              DropdownButtonFormField<String>(
                value: _selectedTestId,
                items: _tests.map((t) => DropdownMenuItem(
                  value: '${t['id']}',
                  child: Text('اختبار ${t['month'] ?? ''}/${t['year'] ?? ''}'),
                )).toList(),
                onChanged: (v) => setState(() => _selectedTestId = v),
                decoration: const InputDecoration(labelText: 'الاختبار'),
              ),
            const SizedBox(height: 10),
            if (_students.isNotEmpty)
              DropdownButtonFormField<String>(
                value: _selectedStudentId,
                items: _students.map((s) => DropdownMenuItem(
                  value: '${s['id']}',
                  child: Text(s['name'] ?? s['full_name'] ?? ''),
                )).toList(),
                onChanged: (v) => setState(() => _selectedStudentId = v),
                decoration: const InputDecoration(labelText: 'الطالب'),
              ),
            const SizedBox(height: 10),
            TextField(
              controller: _memorizationCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'الحفظ (من 50)', prefixIcon: Icon(Icons.menu_book_outlined)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _recitationCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'التلاوة (من 50)', prefixIcon: Icon(Icons.record_voice_over_outlined)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _ahkamCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'الأحكام (من 30)', prefixIcon: Icon(Icons.gavel_outlined)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _matnCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'المتن (من 20)', prefixIcon: Icon(Icons.auto_stories_outlined)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _behaviorCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'السلوك (من 50)', prefixIcon: Icon(Icons.favorite_outline)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _notesCtrl,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'ملاحظات (اختياري)'),
            ),
            const SizedBox(height: 12),
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
                        Text('$_total / 200',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        Text('${_percent.toStringAsFixed(1)}%',
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('التقدير', style: TextStyle(color: Colors.grey)),
                        Text(_rating,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20, color: _ratingColor)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
        bottomNavigationBar: PrimaryBottomButton(
          title: _loading ? 'جاري الحفظ...' : 'حفظ الدرجات',
          onPressed: _loading ? null : _submit,
        ),
      ),
    );
  }
}
