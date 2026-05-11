import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class GuideRecommendationsScreen extends StatelessWidget {
  const GuideRecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recs = [
      _R('تنظيم ورشة تطويرية للمعلمات', 'مركز الرشاد — أ. سارة المالكي', BadgeKind.warning, 'قيد التنفيذ'),
      _R('متابعة خطة شهر شعبان', 'مركز التقوى', BadgeKind.success, 'منفذة'),
      _R('إعادة هيكلة الحلقات', 'مركز الصدق', BadgeKind.danger, 'متأخرة'),
      _R('تعزيز التواصل مع أولياء الأمور', 'مركز الإيمان', BadgeKind.info, 'مرسلة'),
    ];

    return GreenHeaderScaffold(
      title: 'التوصيات والمتابعة',
      headerExtra: SearchFilterBar(hint: 'بحث', onChanged: (_) {}),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        itemCount: recs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => AppCard(
          child: Row(children: [
            Container(
              width: 8,
              height: 60,
              decoration: BoxDecoration(color: badgeColor(recs[i].kind), borderRadius: BorderRadius.circular(4)),
            ),
            const SizedBox(width: 10),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: badgeColor(recs[i].kind).withValues(alpha: .14),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Icon(Icons.lightbulb_rounded, color: badgeColor(recs[i].kind)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(recs[i].title, style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Text(recs[i].sub, style: const TextStyle(color: AppColors.muted, fontSize: 12.5)),
                ],
              ),
            ),
            StatusBadge(text: recs[i].status, kind: recs[i].kind),
          ]),
        ),
      ),
    );
  }
}

class _R {
  final String title;
  final String sub;
  final BadgeKind kind;
  final String status;
  const _R(this.title, this.sub, this.kind, this.status);
}
