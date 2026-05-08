import 'package:flutter/material.dart';
import '../../services/teacher_service.dart';
import '../../widgets/common_widgets.dart';

class DailyFollowupScreen extends StatefulWidget {
  const DailyFollowupScreen({super.key});

  @override
  State<DailyFollowupScreen> createState() => _DailyFollowupScreenState();
}

class _DailyFollowupScreenState extends State<DailyFollowupScreen> {
  final TeacherService _teacherService = TeacherService();
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _summary;

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  Future<void> _loadSummary() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final summary = await _teacherService.getTeacherSummary();
      setState(() {
        _summary = summary;
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
      onRefresh: _loadSummary,
      child: AppShell(
        title: 'المتابعة اليومية',
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
                        child: Row(children: [
                          StatCard(label: 'الحضور', value: '${_summary?['attendance']?['present_records'] ?? '--'}'),
                          const SizedBox(width: 10),
                          StatCard(label: 'الغياب', value: '${(_summary?['attendance']?['total_records'] ?? 0) - (_summary?['attendance']?['present_records'] ?? 0)}'),
                          const SizedBox(width: 10),
                          StatCard(label: 'الجلسات', value: '${_summary?['daily_sessions']?['total'] ?? '--'}'),
                        ]),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: InfoTile(
                          title: 'إضافة تقرير يومي لطالبة',
                          subtitle: 'حفظ، مراجعة، تلاوة، سلوك',
                          icon: Icons.note_add_outlined,
                          onTap: () => Navigator.pushNamed(context, '/teacher/daily-report-entry'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: InfoTile(
                          title: 'الخطط العلاجية',
                          subtitle: '${_summary?['remedial_plans']?['open'] ?? 0} مفتوحة، ${_summary?['remedial_plans']?['overdue'] ?? 0} متأخرة',
                          icon: Icons.healing_outlined,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: InfoTile(
                          title: 'التواصل مع أولياء الأمور',
                          subtitle: '${_summary?['parent_contacts']?['total'] ?? 0} اتصال، ${_summary?['parent_contacts']?['follow_ups_due'] ?? 0} متابعة',
                          icon: Icons.contact_phone_outlined,
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
