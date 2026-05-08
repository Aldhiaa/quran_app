import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/teacher_service.dart';
import '../../widgets/common_widgets.dart';
import '../../providers/auth_provider.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  final TeacherService _teacherService = TeacherService();
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _stats;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final stats = await _teacherService.getDashboardStats();
      setState(() {
        _stats = stats;
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
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return AppShell(
          title: 'الرئيسية',
          actions: [IconButton(
            onPressed: () => Navigator.pushNamed(context, '/common/notifications'),
            icon: const Icon(Icons.notifications_none_rounded),
          )],
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_errorMessage!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          ElevatedButton(onPressed: _loadStats, child: const Text('إعادة المحاولة')),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadStats,
                      child: ListView(
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('أهلاً وسهلاً', style: Theme.of(context).textTheme.bodyMedium),
                                  const SizedBox(height: 6),
                                  Text(
                                    authProvider.user?.name ?? 'المعلم',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 16),
                                  InfoTile(
                                    title: 'الحلقات',
                                    subtitle: 'عرض الحلقات المسندة',
                                    icon: Icons.menu_book_rounded,
                                    onTap: () => Navigator.pushNamed(context, '/teacher/halaqat'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(children: [
                              StatCard(label: 'إجمالي الطلاب', value: '${_stats?['total_students'] ?? _stats?['students_count'] ?? '--'}'),
                              const SizedBox(width: 10),
                              StatCard(label: 'الحلقات', value: '${_stats?['total_circles'] ?? _stats?['circles_count'] ?? '--'}'),
                              const SizedBox(width: 10),
                              StatCard(label: 'الحضور', value: '${_stats?['present_today'] ?? _stats?['attendance_rate'] ?? '--'}'),
                            ]),
                          ),
                          const SizedBox(height: 16),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: AppSectionTitle(title: 'المهام اليوم'),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: InfoTile(
                              title: 'تقرير المتابعة اليومي',
                              subtitle: 'لم يتم إدخال التقرير بعد',
                              icon: Icons.description_outlined,
                              onTap: () => Navigator.pushNamed(context, '/teacher/daily-report-entry'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: InfoTile(
                              title: 'التقييم الأسبوعي',
                              subtitle: 'تقييم السلوك والالتزام',
                              icon: Icons.fact_check_outlined,
                              onTap: () => Navigator.pushNamed(context, '/teacher/weekly-evaluation'),
                            ),
                          ),
                        ],
                      ),
                    ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, '/teacher/daily-report-entry'),
            child: const Icon(Icons.add_rounded),
          ),
        );
      },
    );
  }
}
