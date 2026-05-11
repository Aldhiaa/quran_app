import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common_widgets.dart';
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
    MoreScreen(role: 'teacher'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.menu_book_rounded), label: 'الحلقات'),
          NavigationDestination(icon: Icon(Icons.groups_rounded), label: 'الطلاب'),
          NavigationDestination(icon: Icon(Icons.assessment_rounded), label: 'التقارير'),
          NavigationDestination(icon: Icon(Icons.more_horiz_rounded), label: 'المزيد'),
        ],
      ),
    );
  }
}

class MoreScreen extends StatelessWidget {
  final String role;
  const MoreScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final items = <_MoreItem>[
      _MoreItem('الملف الشخصي', Icons.person_rounded, '/settings/profile', AppColors.primary),
      _MoreItem('التواصل', Icons.hub_rounded, '/common/communication', AppColors.info),
      _MoreItem('الإشعارات', Icons.notifications_rounded, '/common/notifications', AppColors.warning),
      _MoreItem('الإعلانات', Icons.campaign_rounded, '/common/announcements', AppColors.accentGold),
      _MoreItem('الإعدادات', Icons.settings_rounded, '/settings/app', AppColors.muted),
      _MoreItem('الدعم', Icons.support_agent_rounded, '/settings/support', AppColors.success),
      _MoreItem('عن التطبيق', Icons.info_rounded, '/settings/about', AppColors.info),
      _MoreItem('تبديل الدور', Icons.swap_horiz_rounded, '/settings/role-switch', AppColors.primaryDark),
    ];

    return GreenHeaderScaffold(
      title: 'المزيد',
      showBack: false,
      headerExtra: RoleDashboardHeader(
        name: auth.user?.name ?? 'المستخدم',
        role: _roleLabel(role),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          ...items.map((it) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InfoTile(
                  title: it.title,
                  subtitle: '',
                  icon: it.icon,
                  color: it.color,
                  onTap: () => Navigator.pushNamed(context, it.route),
                ),
              )),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.logout_rounded, color: AppColors.danger),
            label: const Text('تسجيل الخروج', style: TextStyle(color: AppColors.danger)),
            style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.danger)),
            onPressed: () async {
              await auth.logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
              }
            },
          ),
        ],
      ),
    );
  }

  static String _roleLabel(String r) {
    switch (r) {
      case 'teacher':
        return 'معلم';
      case 'student':
        return 'طالب';
      case 'center_supervisor':
        return 'مشرف مركز';
      case 'guide':
        return 'موجهة';
      default:
        return 'مستخدم';
    }
  }
}

class _MoreItem {
  final String title;
  final IconData icon;
  final String route;
  final Color color;
  const _MoreItem(this.title, this.icon, this.route, this.color);
}
