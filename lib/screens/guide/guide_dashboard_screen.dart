import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common_widgets.dart';

class GuideDashboardScreen extends StatelessWidget {
  const GuideDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return GreenHeaderScaffold(
      title: 'لوحة الموجهة',
      showBack: false,
      actions: [
        IconButton(
          onPressed: () => Navigator.pushNamed(context, '/common/notifications'),
          icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
        ),
      ],
      headerExtra: RoleDashboardHeader(
        name: auth.user?.name ?? 'الموجهة',
        role: 'موجهة الحلقات',
        fallback: Icons.person_2_rounded,
        onTap: () => Navigator.pushNamed(context, '/settings/profile'),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          const KpiGrid(items: [
            KpiCard(label: 'المراكز', value: '6', icon: Icons.business_rounded, color: AppColors.primary),
            KpiCard(label: 'المشرفات', value: '8', icon: Icons.school_rounded, color: AppColors.info),
            KpiCard(label: 'الحلقات النشطة', value: '24', icon: Icons.menu_book_rounded, color: AppColors.accentGold),
            KpiCard(label: 'زيارات اليوم', value: '4', icon: Icons.event_available_rounded, color: AppColors.warning),
            KpiCard(label: 'تقارير للمراجعة', value: '11', icon: Icons.hourglass_top_rounded, color: AppColors.info),
            KpiCard(label: 'الاحتياج التدريبي', value: '5', icon: Icons.psychology_alt_rounded, color: AppColors.danger),
          ]),
          const SizedBox(height: 14),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(children: [
                  Icon(Icons.trending_up_rounded, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text('مؤشرات الأداء', style: TextStyle(fontWeight: FontWeight.w800)),
                  Spacer(),
                ]),
                const SizedBox(height: 12),
                Row(children: const [
                  ProgressRing(value: .88, size: 72, strokeWidth: 8),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('متوسط أداء المراكز', style: TextStyle(fontWeight: FontWeight.w700)),
                        SizedBox(height: 4),
                        Text('ارتفاع بنسبة 4٪ عن الشهر الماضي',
                            style: TextStyle(color: AppColors.muted, fontSize: 12)),
                      ],
                    ),
                  ),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const AppSectionTitle(title: 'إجراءات سريعة'),
          const SizedBox(height: 10),
          QuickActionGrid(actions: [
            QuickAction(label: 'مراكزي', icon: Icons.business_rounded, color: AppColors.primary, route: '/guide/centers'),
            QuickAction(label: 'المشرفات', icon: Icons.groups_2_rounded, color: AppColors.info, route: '/guide/supervisors'),
            QuickAction(label: 'مراقبة الحلقات', icon: Icons.visibility_rounded, color: AppColors.accentGold, route: '/guide/circles'),
            QuickAction(label: 'الزيارات', icon: Icons.event_available_rounded, color: AppColors.success, route: '/guide/visits'),
            QuickAction(label: 'مراجعة الخطط', icon: Icons.fact_check_rounded, color: AppColors.primaryDark, route: '/guide/plans-review'),
            QuickAction(label: 'الإشراف التربوي', icon: Icons.school_rounded, color: AppColors.warning, route: '/guide/educational-supervision'),
            QuickAction(label: 'تقييم الحلقة النموذجية', icon: Icons.workspace_premium_rounded, color: AppColors.accentGold, route: '/guide/model-circle-evaluation'),
            QuickAction(label: 'الاحتياجات التدريبية', icon: Icons.psychology_alt_rounded, color: AppColors.danger, route: '/guide/training-needs'),
            QuickAction(label: 'الخطة التدريبية', icon: Icons.menu_book_rounded, color: AppColors.primary, route: '/guide/training-plan'),
            QuickAction(label: 'التوصيات', icon: Icons.task_alt_rounded, color: AppColors.success, route: '/guide/recommendations'),
            QuickAction(label: 'اعتماد الاختبار', icon: Icons.verified_rounded, color: AppColors.info, route: '/guide/monthly-tests'),
            QuickAction(label: 'التقارير', icon: Icons.assessment_rounded, color: AppColors.primaryDark, route: '/guide/reports'),
          ]),
        ],
      ),
    );
  }
}
