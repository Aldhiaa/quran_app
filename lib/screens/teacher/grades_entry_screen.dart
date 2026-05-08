import 'package:flutter/material.dart';
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
  final _memorizationCtrl = TextEditingController(text: '40');
  final _recitationCtrl = TextEditingController(text: '45');
  final _ahkamCtrl = TextEditingController(text: '25');
  final _matnCtrl = TextEditingController(text: '18');
  final _behaviorCtrl = TextEditingController(text: '48');
  final _notesCtrl = TextEditingController();

  List<Map<String, dynamic>> _tests = [];
  List<Map<String, dynamic>> _students = [];

  @override
  void initState() {
    super.initState();
    _loadData();
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

    final score = (int.tryParse(_memorizationCtrl.text) ?? 0)
        + (int.tryParse(_recitationCtrl.text) ?? 0)
        + (int.tryParse(_ahkamCtrl.text) ?? 0)
        + (int.tryParse(_matnCtrl.text) ?? 0)
        + (int.tryParse(_behaviorCtrl.text) ?? 0);

    try {
      await _teacherService.saveTestResults(int.parse(_selectedTestId!), [
        {
          'student_id': int.parse(_selectedStudentId!),
          'memorization_score': int.tryParse(_memorizationCtrl.text) ?? 0,
          'recitation_score': int.tryParse(_recitationCtrl.text) ?? 0,
          'ahkam_score': int.tryParse(_ahkamCtrl.text) ?? 0,
          'matn_score': int.tryParse(_matnCtrl.text) ?? 0,
          'behavior_score': int.tryParse(_behaviorCtrl.text) ?? 0,
          'total_score': score,
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
