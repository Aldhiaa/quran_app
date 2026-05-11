import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class SupervisorCenterDetailScreen extends StatelessWidget {
  const SupervisorCenterDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GreenHeaderScaffold(
      title: 'تفاصيل المركز',
      headerExtra: AppCard(
        color: Colors.white.withValues(alpha: .12),
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.accentGold, width: 1.2),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.business_rounded, color: AppColors.accentGold),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('مركز النور',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                SizedBox(height: 4),
                Text('الرياض — حي السلام',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ]),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('الأداء العام', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                Row(children: const [
                  ProgressRing(value: .89, size: 78, strokeWidth: 9),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('متوسط الحضور', style: TextStyle(fontWeight: FontWeight.w700)),
                        SizedBox(height: 4),
                        Text('مرتفع — التزام جيد',
                            style: TextStyle(color: AppColors.muted, fontSize: 12)),
                      ],
                    ),
                  ),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const KpiGrid(items: [
            KpiCard(label: 'حلقات', value: '6', icon: Icons.menu_book_rounded, color: AppColors.primary),
            KpiCard(label: 'معلمون', value: '8', icon: Icons.school_rounded, color: AppColors.info),
            KpiCard(label: 'طلاب', value: '142', icon: Icons.groups_rounded, color: AppColors.success),
            KpiCard(label: 'الزيارات', value: '12', icon: Icons.event_available_rounded, color: AppColors.accentGold),
          ]),
          const SizedBox(height: 14),
          const AppSectionTitle(title: 'الحلقات'),
          const SizedBox(height: 8),
          EntityListCard(
            leading: Icons.menu_book_rounded,
            title: 'حلقة البقرة',
            subtitle: '24 طالب • أ. سعد القحطاني',
            badgeText: '٪87',
            badgeKind: BadgeKind.success,
          ),
          const SizedBox(height: 8),
          EntityListCard(
            leading: Icons.menu_book_rounded,
            title: 'حلقة آل عمران',
            subtitle: '18 طالب • أ. خالد الزهراني',
            badgeText: '٪78',
            badgeKind: BadgeKind.success,
          ),
        ],
      ),
    );
  }
}
