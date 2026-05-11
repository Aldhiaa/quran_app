import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class GuideTrainingPlanScreen extends StatelessWidget {
  const GuideTrainingPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _T('دورة: تطوير أساليب التحفيز', '1446/11/15 — مركز الإيمان', BadgeKind.success, 'مجدولة', '24 مشاركة'),
      _T('ورشة: إدارة الحلقة', '1446/11/22 — مركز التقوى', BadgeKind.info, 'تسجيل مفتوح', '18 مشاركة'),
      _T('دورة: أحكام التلاوة المتقدمة', '1446/12/02 — مركز السلام', BadgeKind.warning, 'تخطيط', '0 مشاركة'),
      _T('لقاء: التعامل مع الحالات الخاصة', '1446/12/10 — مركز البيان', BadgeKind.info, 'تسجيل مفتوح', '12 مشاركة'),
    ];

    return GreenHeaderScaffold(
      title: 'الخطة التدريبية',
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () {},
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('إضافة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.accentGold.withValues(alpha: .18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.school_rounded, color: AppColors.primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(items[i].title, style: const TextStyle(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 3),
                      Text(items[i].when, style: const TextStyle(color: AppColors.muted, fontSize: 12.5)),
                    ],
                  ),
                ),
                StatusBadge(text: items[i].status, kind: items[i].kind),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                const Icon(Icons.groups_rounded, size: 14, color: AppColors.muted),
                const SizedBox(width: 4),
                Text(items[i].count, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class _T {
  final String title;
  final String when;
  final BadgeKind kind;
  final String status;
  final String count;
  const _T(this.title, this.when, this.kind, this.status, this.count);
}
