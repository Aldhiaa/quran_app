import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/teacher_service.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common_widgets.dart';

class MonthlyExamCreateScreen extends StatefulWidget {
  const MonthlyExamCreateScreen({super.key});

  @override
  State<MonthlyExamCreateScreen> createState() => _MonthlyExamCreateScreenState();
}

class _MonthlyExamCreateScreenState extends State<MonthlyExamCreateScreen> {
  final _teacherService = TeacherService();
  bool _loading = false;
  bool _submitted = false;

  String? _selectedCircleId;
  String _selectedMonth = '${DateTime.now().month}';
  String _selectedYear = '${DateTime.now().year}';
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
      await _teacherService.createMonthlyTest({
        'circle_id': int.parse(_selectedCircleId!),
        'teacher_id': teacherId,
        'month': int.parse(_selectedMonth),
        'year': int.parse(_selectedYear),
      });
      setState(() => _submitted = true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إنشاء الاختبار بنجاح'), backgroundColor: Colors.green),
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
    _teacherService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return AppShell(
        title: 'إضافة اختبار شهري',
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 64),
              SizedBox(height: 16),
              Text('تم إنشاء الاختبار بنجاح', style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      );
    }

    final months = List.generate(12, (i) => '${i + 1}');
    final years = List.generate(5, (i) => '${DateTime.now().year - 2 + i}');

    return AppShell(
      title: 'إضافة اختبار شهري',
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
            value: _selectedMonth,
            items: months.map((m) => DropdownMenuItem(value: m, child: Text('شهر $m'))).toList(),
            onChanged: (v) => setState(() => _selectedMonth = v!),
            decoration: const InputDecoration(labelText: 'الشهر'),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _selectedYear,
            items: years.map((y) => DropdownMenuItem(value: y, child: Text(y))).toList(),
            onChanged: (v) => setState(() => _selectedYear = v!),
            decoration: const InputDecoration(labelText: 'السنة'),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('معايير التقييم', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _criteriaRow('الحفظ', '50 نقطة'),
                  _criteriaRow('التلاوة', '50 نقطة'),
                  _criteriaRow('الأحكام', '30 نقطة'),
                  _criteriaRow('المتن', '20 نقطة'),
                  _criteriaRow('السلوك', '50 نقطة'),
                  const Divider(),
                  _criteriaRow('المجموع', '200 نقطة'),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: PrimaryBottomButton(
        title: _loading ? 'جاري الإنشاء...' : 'إنشاء الاختبار',
        onPressed: _loading ? null : _submit,
      ),
    );
  }

  Widget _criteriaRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(title), Text(value, style: const TextStyle(fontWeight: FontWeight.bold))],
      ),
    );
  }
}
