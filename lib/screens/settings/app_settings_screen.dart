import 'package:flutter/material.dart';
import '../../widgets/common_widgets.dart';
import '../../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});
  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  bool notifications = true;
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'الإعدادات',
      body: ListView(
        children: [
          InfoTile(
            title: 'الملف الشخصي',
            subtitle: 'تعديل بيانات المستخدم',
            icon: Icons.person_outline,
            onTap: () => Navigator.pushNamed(context, '/settings/profile'),
          ),
          const SizedBox(height: 8),
          const InfoTile(title: 'تغيير كلمة المرور', subtitle: 'الأمان والحساب', icon: Icons.lock_outline_rounded),
          const SizedBox(height: 8),
          SwitchListTile.adaptive(
            value: notifications,
            onChanged: (v) => setState(() => notifications = v),
            title: const Text('الإشعارات'),
            secondary: const Icon(Icons.notifications_outlined),
          ),
          SwitchListTile.adaptive(
            value: darkMode,
            onChanged: (v) => setState(() => darkMode = v),
            title: const Text('الوضع الليلي'),
            secondary: const Icon(Icons.dark_mode_outlined),
          ),
          const SizedBox(height: 8),
          const InfoTile(title: 'اللغة', subtitle: 'العربية', icon: Icons.language_outlined),
          const SizedBox(height: 8),
          InfoTile(
            title: 'الدعم والمساعدة',
            subtitle: 'الأسئلة الشائعة',
            icon: Icons.support_agent_outlined,
            onTap: () => Navigator.pushNamed(context, '/settings/support'),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: OutlinedButton(
          onPressed: () {
            Provider.of<AuthProvider>(context, listen: false).logout();
            Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
          },
          style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('تسجيل الخروج'),
        ),
      ),
    );
  }
}
