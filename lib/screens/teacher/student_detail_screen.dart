import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/teacher_service.dart';
import '../../widgets/common_widgets.dart';
import '../../providers/auth_provider.dart';

class StudentDetailScreen extends StatefulWidget {
  const StudentDetailScreen({super.key});

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  final TeacherService _teacherService = TeacherService();
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _students = [];

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final students = await _teacherService.getStudents();
      setState(() {
        _students = students;
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
    final firstStudent = _students.isNotEmpty ? _students.first : null;
    final name = firstStudent?['name'] ?? firstStudent?['full_name'] ?? 'طالب';
    final level = firstStudent?['current_level'] ?? firstStudent?['parts'] ?? '--';
    final progress = (firstStudent?['progress'] ?? 0).toDouble();

    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return RefreshIndicator(
          onRefresh: _loadStudents,
          child: AppShell(
            title: 'تفاصيل الطالب',
            body: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null || _students.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_errorMessage ?? 'لا توجد بيانات', style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                            const SizedBox(height: 16),
                            ElevatedButton(onPressed: _loadStudents, child: const Text('إعادة المحاولة')),
                          ],
                        ),
                      )
                    : ListView(
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(18),
                              child: Row(
                                children: [
                                  const CircleAvatar(radius: 28, child: Icon(Icons.person_rounded)),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                      const SizedBox(height: 4),
                                      Text('المستوى: $level', style: Theme.of(context).textTheme.bodySmall),
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ProgressCard(title: 'التقدم', value: progress > 0 ? progress : 0.5, footer: 'مستمر في التعلم'),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(children: const [
                              StatCard(label: 'الحفظ', value: '--'),
                              const SizedBox(width: 10),
                              StatCard(label: 'المراجعة', value: '--'),
                              const SizedBox(width: 10),
                              StatCard(label: 'السلوك', value: '--'),
                            ]),
                          ),
                        ],
                      ),
          ),
        );
      },
    );
  }
}
