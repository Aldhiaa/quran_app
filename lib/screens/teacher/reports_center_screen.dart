import 'package:flutter/material.dart';
import '../../services/teacher_service.dart';
import '../../widgets/common_widgets.dart';

class ReportsCenterScreen extends StatefulWidget {
  const ReportsCenterScreen({super.key});

  @override
  State<ReportsCenterScreen> createState() => _ReportsCenterScreenState();
}

class _ReportsCenterScreenState extends State<ReportsCenterScreen> {
  final _teacherService = TeacherService();
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _summary;

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  Future<void> _loadSummary() async {
    setState(() { _isLoading = true; _errorMessage = null; });
    try {
      _summary = await _teacherService.getTeacherSummary();
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() { _errorMessage = e.toString(); _isLoading = false; });
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
      onRefresh: _loadSummary,
      child: AppShell(
        title: 'تقارير الحلقة',
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_errorMessage!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        ElevatedButton(onPressed: _loadSummary, child: const Text('إعادة المحاولة')),
                      ],
                    ),
                  )
                : ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Row(children: [
                                  StatCard(label: 'الجلسات', value: '${_summary?['daily_sessions']?['total'] ?? 0}'),
                                  const SizedBox(width: 10),
                                  StatCard(label: 'متوسط الاختبار', value: '${_summary?['monthly_test_average'] ?? '--'}'),
                                ]),
                                const SizedBox(height: 12),
                                Row(children: [
                                  StatCard(label: 'حضور', value: '${_summary?['attendance']?['rate'] ?? 0}%'),
                                  const SizedBox(width: 10),
                                  StatCard(label: 'خطط علاجية', value: '${_summary?['remedial_plans']?['open'] ?? 0}'),
                                ]),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: InfoTile(
                          title: 'التقرير اليومي',
                          subtitle: '${_summary?['daily_sessions']?['submitted'] ?? 0} مقدم من ${_summary?['daily_sessions']?['total'] ?? 0}',
                          icon: Icons.insert_drive_file_outlined,
                          onTap: () => Navigator.pushNamed(context, '/teacher/daily-followup'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: InfoTile(
                          title: 'التقييمات الأسبوعية',
                          subtitle: 'متابعة التقييمات',
                          icon: Icons.view_week_outlined,
                          onTap: () => Navigator.pushNamed(context, '/teacher/weekly-evaluation'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: InfoTile(
                          title: 'الاختبارات الشهرية',
                          subtitle: 'متوسط: ${_summary?['monthly_test_average'] ?? '--'}%',
                          icon: Icons.calendar_view_month_outlined,
                          onTap: () => Navigator.pushNamed(context, '/teacher/monthly-exams'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: InfoTile(
                          title: 'إحصائيات الحلقة',
                          subtitle: 'تحليل الأداء',
                          icon: Icons.bar_chart_outlined,
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
