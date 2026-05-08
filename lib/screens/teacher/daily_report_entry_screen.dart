import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/teacher_service.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common_widgets.dart';

class DailyReportEntryScreen extends StatefulWidget {
  const DailyReportEntryScreen({super.key});

  @override
  State<DailyReportEntryScreen> createState() => _DailyReportEntryScreenState();
}

class _DailyReportEntryScreenState extends State<DailyReportEntryScreen> {
  final _teacherService = TeacherService();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _submitted = false;

  String? _selectedCircleId;
  String _memorization = '3 صفحات';
  String _review = '1 صفحة';
  String _recitation = 'جيد جداً';
  String _behavior = 'ممتاز';
  final _notesController = TextEditingController();

  List<Map<String, dynamic>> _circles = [];

  @override
  void initState() {
    super.initState();
    _loadCircles();
  }

  Future<void> _loadCircles() async {
    try {
      _circles = await _teacherService.getCircles();
      if (_circles.isNotEmpty) _selectedCircleId = '${_circles.first['id']}';
      setState(() {});
    } catch (_) {}
  }

  Future<void> _submit() async {
    if (_selectedCircleId == null) return;
    setState(() => _loading = true);

    try {
      final teacherId = Provider.of<AuthProvider>(context, listen: false).user?.teacherId ?? 0;
      await _teacherService.createDailySession({
        'circle_id': int.parse(_selectedCircleId!),
        'teacher_id': teacherId,
        'session_date': DateTime.now().toIso8601String().split('T')[0],
      });
      setState(() => _submitted = true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ التقرير بنجاح'), backgroundColor: Colors.green),
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
    _notesController.dispose();
    _teacherService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return AppShell(
        title: 'إضافة تقرير يومي',
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 64),
              SizedBox(height: 16),
              Text('تم حفظ التقرير بنجاح', style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      );
    }

    return Form(
      key: _formKey,
      child: AppShell(
        title: 'إضافة تقرير يومي',
        body: ListView(
          children: [
            if (_circles.isNotEmpty)
              DropdownButtonFormField<String>(
                value: _selectedCircleId,
                items: _circles.map((c) => DropdownMenuItem(
                  value: '${c['id']}',
                  child: Text(c['name'] ?? ''),
                )).toList(),
                onChanged: (v) => setState(() => _selectedCircleId = v),
                decoration: const InputDecoration(labelText: 'الحلقة'),
              ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _memorization,
              items: const ['صفحة', '2 صفحة', '3 صفحات', '4 صفحات', '5 صفحات']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _memorization = v!),
              decoration: const InputDecoration(labelText: 'الحفظ'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _review,
              items: const ['لا يوجد', '1 صفحة', '2 صفحة', '3 صفحات']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _review = v!),
              decoration: const InputDecoration(labelText: 'المراجعة'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _recitation,
              items: const ['ممتاز', 'جيد جداً', 'جيد', 'بحاجة متابعة']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _recitation = v!),
              decoration: const InputDecoration(labelText: 'التلاوة'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _behavior,
              items: const ['ممتاز', 'جيد جداً', 'جيد', 'ضعيف']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _behavior = v!),
              decoration: const InputDecoration(labelText: 'السلوك'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'ملاحظات'),
            ),
          ],
        ),
        bottomNavigationBar: PrimaryBottomButton(
          title: _loading ? 'جاري الحفظ...' : 'حفظ التقرير',
          onPressed: _loading ? null : _submit,
        ),
      ),
    );
  }
}
