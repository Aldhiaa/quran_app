import 'package:flutter/material.dart';
import '../../services/teacher_service.dart';
import '../../widgets/common_widgets.dart';

class MonthlyExamsScreen extends StatefulWidget {
  const MonthlyExamsScreen({super.key});

  @override
  State<MonthlyExamsScreen> createState() => _MonthlyExamsScreenState();
}

class _MonthlyExamsScreenState extends State<MonthlyExamsScreen> {
  final TeacherService _teacherService = TeacherService();
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _tests = [];
  Map<String, dynamic>? _summary;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait([
        _teacherService.getMonthlyTests(),
        _teacherService.getTeacherSummary(),
      ]);
      setState(() {
        _tests = results[0] as List<Map<String, dynamic>>;
        _summary = results[1] as Map<String, dynamic>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _teacherService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: AppShell(
        title: 'الاختبارات الشهرية',
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_errorMessage!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        ElevatedButton(onPressed: _loadData, child: const Text('إعادة المحاولة')),
                      ],
                    ),
                  )
                : ListView(
                    children: [
                      if (_tests.isNotEmpty)
                        Card(
                          child: ListTile(
                            title: Text('${_tests.first['month'] ?? ''}/${_tests.first['year'] ?? ''}'),
                            subtitle: Text('الحالة: ${_tests.first['status'] ?? ''}'),
                            trailing: const Icon(Icons.calendar_month_rounded),
                          ),
                        ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(children: [
                          StatCard(label: 'الاختبارات', value: '${_tests.length}'),
                          const SizedBox(width: 10),
                          StatCard(label: 'المتوسط', value: '${_summary?['monthly_test_average'] ?? '--'}'),
                          const SizedBox(width: 10),
                          StatCard(label: 'الجلسات', value: '${_summary?['daily_sessions']?['total'] ?? '--'}'),
                        ]),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, '/teacher/monthly-exam-create'),
                          child: const Text('إضافة اختبار جديد'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: AppSectionTitle(title: 'الاختبارات'),
                      ),
                      ...(_tests.isNotEmpty
                          ? _tests.take(5).map((test) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: InfoTile(
                                  title: 'شهر ${test['month'] ?? ''} ${test['year'] ?? ''}',
                                  subtitle: 'الحالة: ${test['status'] ?? ''}',
                                  icon: Icons.history_rounded,
                                  onTap: () => Navigator.pushNamed(context, '/teacher/exam-results'),
                                ),
                              ))
                          : [const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text('لا توجد اختبارات بعد', style: TextStyle(color: Colors.grey)),
                            )]),
                    ],
                  ),
      ),
    );
  }
}
