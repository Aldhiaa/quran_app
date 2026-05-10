import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../student/student_dashboard_screen.dart';
import '../student/my_plan_screen.dart';
import '../student/student_progress_screen.dart';
import '../student/student_results_screen.dart';

class StudentShell extends StatefulWidget {
  const StudentShell({super.key});

  @override
  State<StudentShell> createState() => _StudentShellState();
}

class _StudentShellState extends State<StudentShell> {
  int _index = 0;

  static const _pages = <Widget>[
    StudentDashboardScreen(),
    MyPlanScreen(),
    StudentProgressScreen(),
    StudentResultsScreen(),
    _StudentMoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_rounded), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.flag_rounded), label: 'خطتي'),
          NavigationDestination(icon: Icon(Icons.show_chart_rounded), label: 'تقدمي'),
          NavigationDestination(icon: Icon(Icons.query_stats_rounded), label: 'نتائجي'),
          NavigationDestination(icon: Icon(Icons.more_horiz_rounded), label: 'المزيد'),
        ],
      ),
    );
  }
}

class _StudentMoreScreen extends StatelessWidget {
  const _StudentMoreScreen();

  @override
  Widget build(BuildContext context) {
    final items = <_MItem>[
      const _MItem('المهام اليومية', Icons.task_alt_rounded, '/student/daily-tasks'),
      const _MItem('المراجعة', Icons.auto_stories_rounded, '/student/review'),
      const _MItem('حضوري', Icons.how_to_reg_rounded, '/student/attendance'),
      const _MItem('ملف الحفظ', Icons.folder_copy_rounded, '/student/memorization-file'),
      const _MItem('الواجبات', Icons.assignment_rounded, '/student/homework'),
      const _MItem('ملاحظات المعلم', Icons.chat_bubble_rounded, '/student/teacher-notes'),
      const _MItem('إنجازاتي', Icons.workspace_premium_rounded, '/student/achievements'),
      const _MItem('التواصل', Icons.hub_rounded, '/common/communication'),
      const _MItem('الإشعارات', Icons.notifications_rounded, '/common/notifications'),
      const _MItem('الملف الشخصي', Icons.person_rounded, '/settings/profile'),
      const _MItem('الإعدادات', Icons.settings_rounded, '/settings/app'),
      const _MItem('الدعم', Icons.support_agent_rounded, '/settings/support'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('المزيد')),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: items.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, i) {
            if (i == items.length) {
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text('تسجيل الخروج', style: TextStyle(color: Colors.red)),
                  onPressed: () async {
                    await Provider.of<AuthProvider>(context, listen: false).logout();
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
                    }
                  },
                ),
              );
            }
            final it = items[i];
            return Card(
              child: ListTile(
                leading: Icon(it.icon),
                title: Text(it.title),
                trailing: const Icon(Icons.chevron_left_rounded),
                onTap: () => Navigator.pushNamed(context, it.route),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MItem {
  final String title;
  final IconData icon;
  final String route;
  const _MItem(this.title, this.icon, this.route);
}
