import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../teacher/teacher_dashboard_screen.dart';
import '../teacher/halaqat_screen.dart';
import '../teacher/students_screen.dart';
import '../teacher/reports_center_screen.dart';

class TeacherShell extends StatefulWidget {
  const TeacherShell({super.key});

  @override
  State<TeacherShell> createState() => _TeacherShellState();
}

class _TeacherShellState extends State<TeacherShell> {
  int _index = 0;

  static const _pages = <Widget>[
    TeacherDashboardScreen(),
    HalaqatScreen(),
    StudentsScreen(),
    ReportsCenterScreen(),
    _MoreScreen(role: 'teacher'),
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
          NavigationDestination(icon: Icon(Icons.menu_book_rounded), label: 'الحلقات'),
          NavigationDestination(icon: Icon(Icons.groups_rounded), label: 'الطلاب'),
          NavigationDestination(icon: Icon(Icons.assessment_rounded), label: 'التقارير'),
          NavigationDestination(icon: Icon(Icons.more_horiz_rounded), label: 'المزيد'),
        ],
      ),
    );
  }
}

class _MoreScreen extends StatelessWidget {
  final String role;
  const _MoreScreen({required this.role});

  @override
  Widget build(BuildContext context) {
    final items = <_MoreItem>[
      const _MoreItem('التواصل', Icons.hub_rounded, '/common/communication'),
      const _MoreItem('الإشعارات', Icons.notifications_rounded, '/common/notifications'),
      const _MoreItem('الإعلانات', Icons.campaign_rounded, '/common/announcements'),
      const _MoreItem('الملف الشخصي', Icons.person_rounded, '/settings/profile'),
      const _MoreItem('الإعدادات', Icons.settings_rounded, '/settings/app'),
      const _MoreItem('الدعم', Icons.support_agent_rounded, '/settings/support'),
      const _MoreItem('عن التطبيق', Icons.info_rounded, '/settings/about'),
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

class _MoreItem {
  final String title;
  final IconData icon;
  final String route;
  const _MoreItem(this.title, this.icon, this.route);
}
