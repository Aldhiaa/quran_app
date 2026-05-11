import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class GuideCirclesScreen extends StatelessWidget {
  const GuideCirclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final circles = [
      _C('حلقة النور', 'مركز الإيمان', .92, BadgeKind.success),
      _C('حلقة الفجر', 'مركز التقوى', .85, BadgeKind.success),
      _C('حلقة الإسراء', 'مركز السلام', .76, BadgeKind.success),
      _C('حلقة الفلق', 'مركز الرشاد', .55, BadgeKind.warning),
      _C('حلقة النحل', 'مركز الصدق', .38, BadgeKind.danger),
    ];

    return GreenHeaderScaffold(
      title: 'مراقبة الحلقات',
      headerExtra: SearchFilterBar(hint: 'بحث', onChanged: (_) {}),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        itemCount: circles.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => AppCard(
          child: Row(children: [
            ProgressRing(value: circles[i].progress, size: 54, strokeWidth: 7),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(circles[i].name, style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Text(circles[i].center,
                      style: const TextStyle(color: AppColors.muted, fontSize: 12.5)),
                ],
              ),
            ),
            StatusBadge(text: '${(circles[i].progress * 100).round()}٪', kind: circles[i].kind),
          ]),
        ),
      ),
    );
  }
}

class _C {
  final String name;
  final String center;
  final double progress;
  final BadgeKind kind;
  const _C(this.name, this.center, this.progress, this.kind);
}
