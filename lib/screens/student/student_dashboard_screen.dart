import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/student_service.dart';
import '../../services/teacher_service.dart';
import '../../models/daily_task_model.dart';
import '../../widgets/common_widgets.dart';
import '../../providers/auth_provider.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _stats;
  List<DailyTaskModel> _dailyTasks = [];

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
      final teacherService = TeacherService();
      final studentService = Provider.of<StudentService>(context, listen: false);

      final results = await Future.wait([
        teacherService.getDashboardStats(),
        studentService.getDailyTasks(),
      ]);

      setState(() {
        _stats = results[0] as Map<String, dynamic>;
        _dailyTasks = results[1] as List<DailyTaskModel>;
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
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return RefreshIndicator(
          onRefresh: _loadData,
          child: AppShell(
            title: 'الرئيسية',
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
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('مرحباً'),
                                  const SizedBox(height: 6),
                                  Text(
                                    authProvider.user?.name ?? 'طالب',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(children: [
                              StatCard(label: 'الحفظ', value: '${_stats?['memorization'] ?? _stats?['total_memorized'] ?? '--'}'),
                              const SizedBox(width: 10),
                              StatCard(label: 'المراجعة', value: '${_stats?['review'] ?? _stats?['total_reviewed'] ?? '--'}'),
                              const SizedBox(width: 10),
                              StatCard(label: 'الحضور', value: '${_stats?['attendance_rate'] ?? '--'}'),
                            ]),
                          ),
                          if (_dailyTasks.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: AppSectionTitle(title: 'مهمة اليوم'),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: InfoTile(
                                title: _dailyTasks.first.title,
                                subtitle: _dailyTasks.first.done ? 'تم الإنجاز ✓' : 'لم يتم بعد',
                                icon: Icons.task_alt_rounded,
                                onTap: () => Navigator.pushNamed(context, '/student/daily-tasks'),
                              ),
                            ),
                          ],
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: InfoTile(
                              title: 'المهام اليومية',
                              subtitle: 'عرض وتنفيذ المهام',
                              icon: Icons.task_alt_rounded,
                              onTap: () => Navigator.pushNamed(context, '/student/daily-tasks'),
                            ),
                          ),
                        ],
                      ),
          ),
        );
      },
    );
  }
}
