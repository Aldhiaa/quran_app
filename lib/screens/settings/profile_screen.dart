import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final name = auth.user?.name ?? 'المستخدم';
    final role = _roleLabel(auth.role);

    return GreenHeaderScaffold(
      title: 'الملف الشخصي',
      headerExtra: Column(children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .12),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.accentGold, width: 1.6),
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.person_rounded, color: Colors.white, size: 44),
        ),
        const SizedBox(height: 10),
        Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.accentGold.withValues(alpha: .2),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: AppColors.accentGold),
          ),
          child: Text(role,
              style: const TextStyle(color: AppColors.accentGold, fontWeight: FontWeight.w800, fontSize: 12)),
        ),
      ]),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: const [
          KpiGrid(items: [
            KpiCard(label: 'الحلقات', value: '2', icon: Icons.menu_book_rounded, color: AppColors.primary),
            KpiCard(label: 'الطلاب', value: '24', icon: Icons.groups_rounded, color: AppColors.info),
            KpiCard(label: 'تقارير معتمدة', value: '38', icon: Icons.verified_rounded, color: AppColors.success),
            KpiCard(label: 'سنوات الخبرة', value: '6', icon: Icons.workspace_premium_rounded, color: AppColors.accentGold),
          ]),
          SizedBox(height: 14),
          InfoTile(title: 'البريد الإلكتروني', subtitle: 'teacher@quran.app', icon: Icons.email_rounded, color: AppColors.info),
          SizedBox(height: 10),
          InfoTile(title: 'الجوال', subtitle: '+966500000000', icon: Icons.phone_rounded, color: AppColors.success),
          SizedBox(height: 10),
          InfoTile(title: 'المركز', subtitle: 'مركز النور', icon: Icons.location_on_rounded, color: AppColors.primary),
          SizedBox(height: 10),
          InfoTile(title: 'تعديل البيانات', subtitle: 'تحديث الاسم وكلمة المرور', icon: Icons.edit_rounded, color: AppColors.muted),
        ],
      ),
    );
  }

  String _roleLabel(String r) {
    switch (r) {
      case 'teacher':
        return 'معلم حلقة';
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
