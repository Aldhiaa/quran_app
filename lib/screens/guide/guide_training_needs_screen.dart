import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class GuideTrainingNeedsScreen extends StatelessWidget {
  const GuideTrainingNeedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final needs = [
      _N('تطوير أساليب التحفيز', 'يشمل: 11 معلمة', BadgeKind.warning, 'احتياج مرتفع'),
      _N('إدارة الحلقة وتنظيم الوقت', 'يشمل: 7 معلمات', BadgeKind.info, 'احتياج متوسط'),
      _N('أحكام التلاوة المتقدمة', 'يشمل: 5 معلمات', BadgeKind.danger, 'احتياج عاجل'),
      _N('التعامل مع الحالات الخاصة', 'يشمل: 9 معلمات', BadgeKind.info, 'احتياج متوسط'),
    ];
    return GreenHeaderScaffold(
      title: 'الاحتياجات التدريبية',
      headerExtra: AppCard(
        color: Colors.white.withValues(alpha: .12),
        padding: const EdgeInsets.all(12),
        child: Row(children: const [
          Expanded(child: _Stat(label: 'احتياجات', value: '5', color: AppColors.accentGold, icon: Icons.psychology_alt_rounded)),
          SizedBox(width: 8),
          Expanded(child: _Stat(label: 'عاجلة', value: '2', color: AppColors.danger, icon: Icons.priority_high_rounded)),
          SizedBox(width: 8),
          Expanded(child: _Stat(label: 'مدرجة بالخطة', value: '3', color: AppColors.success, icon: Icons.task_alt_rounded)),
        ]),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        itemCount: needs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => EntityListCard(
          leading: Icons.psychology_alt_rounded,
          leadingColor: badgeColor(needs[i].kind),
          title: needs[i].title,
          subtitle: needs[i].sub,
          badgeText: needs[i].status,
          badgeKind: needs[i].kind,
        ),
      ),
    );
  }
}

class _N {
  final String title;
  final String sub;
  final BadgeKind kind;
  final String status;
  const _N(this.title, this.sub, this.kind, this.status);
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  const _Stat({required this.label, required this.value, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: .2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 11.5, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
