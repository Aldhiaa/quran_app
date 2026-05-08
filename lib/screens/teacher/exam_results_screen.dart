import 'package:flutter/material.dart';
import '../../services/teacher_service.dart';
import '../../widgets/common_widgets.dart';

class ExamResultsScreen extends StatefulWidget {
  const ExamResultsScreen({super.key});

  @override
  State<ExamResultsScreen> createState() => _ExamResultsScreenState();
}

class _ExamResultsScreenState extends State<ExamResultsScreen> {
  final TeacherService _teacherService = TeacherService();
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _tests = [];

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
      final tests = await _teacherService.getMonthlyTests();
      setState(() {
        _tests = tests;
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
        title: 'نتائج الطلاب',
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
                : _tests.isEmpty
                    ? const Center(child: Text('لا توجد اختبارات', style: TextStyle(fontSize: 16, color: Colors.grey)))
                    : ListView.builder(
                        itemCount: _tests.length,
                        itemBuilder: (context, index) {
                          final test = _tests[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Card(
                              child: ListTile(
                                onTap: () => Navigator.pushNamed(context, '/teacher/exam-result-detail'),
                                leading: CircleAvatar(child: Text('${index + 1}')),
                                title: Text('${test['circle']?['name'] ?? 'اختبار'} ${test['month'] ?? ''}'),
                                subtitle: Text('الحالة: ${test['status'] ?? ''}'),
                                trailing: const Icon(Icons.chevron_left_rounded),
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
