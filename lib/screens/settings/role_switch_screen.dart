import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common_widgets.dart';

class RoleSwitchScreen extends StatefulWidget {
  const RoleSwitchScreen({super.key});
  @override
  State<RoleSwitchScreen> createState() => _RoleSwitchScreenState();
}

class _RoleSwitchScreenState extends State<RoleSwitchScreen> {
  String? _selectedRole;
  bool _switching = false;

  @override
  void initState() {
    super.initState();
    _selectedRole = Provider.of<AuthProvider>(context, listen: false).user?.role;
  }

  String _routeFor(String role) {
    switch (role) {
      case 'teacher':
        return '/teacher/home';
      case 'center_supervisor':
        return '/supervisor/home';
      case 'guide':
        return '/guide/home';
      default:
        return '/student/home';
    }
  }

  Future<void> _doSwitch() async {
    if (_selectedRole == null) return;
    setState(() => _switching = true);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.loginDemo(role: _selectedRole!);
    if (!mounted) return;
    setState(() => _switching = false);
    Navigator.pushNamedAndRemoveUntil(context, _routeFor(_selectedRole!), (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    return GreenHeaderScaffold(
      title: 'تبديل الدور',
      bottomNavigationBar: PrimaryBottomButton(
        title: _switching ? 'جاري التبديل...' : 'تبديل',
        icon: Icons.swap_horiz_rounded,
        onPressed: _selectedRole != null && !_switching ? _doSwitch : null,
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          AppCard(
            child: Row(children: [
              const Icon(Icons.info_outline_rounded, color: AppColors.info),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'الدور الحالي: ${_roleLabel(user?.role ?? '')}\nاختر الدور الذي تريد التبديل إليه.',
                  style: const TextStyle(color: AppColors.muted, fontSize: 12.5, height: 1.5),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 12),
          _option('student', 'طالب', 'متابعة المهام والتقدم', Icons.person_rounded, AppColors.info),
          _option('teacher', 'معلم حلقة', 'إدارة الحلقات والطلاب', Icons.school_rounded, AppColors.primary),
          _option('center_supervisor', 'مشرف مركز', 'إشراف على مركز تحفيظ', Icons.business_rounded, AppColors.accentGold),
          _option('guide', 'موجهة', 'زيارات إشرافية وتقارير', Icons.person_2_rounded, AppColors.primaryDark),
        ],
      ),
    );
  }

  Widget _option(String value, String title, String subtitle, IconData icon, Color color) {
    final selected = _selectedRole == value;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        onTap: () => setState(() => _selectedRole = value),
        color: selected ? color.withValues(alpha: .07) : Colors.white,
        child: Row(children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: AppColors.muted, fontSize: 12.5)),
              ],
            ),
          ),
          Icon(
            selected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
            color: selected ? color : AppColors.muted,
          ),
        ]),
      ),
    );
  }

  String _roleLabel(String r) {
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
        return 'غير محدد';
    }
  }
}
