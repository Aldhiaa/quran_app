import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class SupervisorRiskCasesScreen extends StatelessWidget {
  const SupervisorRiskCasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cases = [
      _R('فيصل الزهراني', 'انخفاض حاد في الحفظ', 'مركز النور — حلقة البقرة', BadgeKind.danger, 'حرج'),
      _R('محمد الدوسري', 'تراجع في الالتزام', 'مركز الفرقان — حلقة النساء', BadgeKind.warning, 'متابعة'),
      _R('سعد الشهري', 'تكرار الغياب', 'مركز النور — حلقة آل عمران', BadgeKind.warning, 'متابعة'),
      _R('عبدالعزيز المالكي', 'مشكلة سلوكية', 'مركز الهداية — حلقة المائدة', BadgeKind.danger, 'حرج'),
    ];

    return GreenHeaderScaffold(
      title: 'حالات الطلاب الحرجة',
      headerExtra: SearchFilterBar(hint: 'بحث', onChanged: (_) {}),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        itemCount: cases.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => AppCard(
          child: Row(children: [
            Container(
              width: 8,
              height: 64,
              decoration: BoxDecoration(color: badgeColor(cases[i].kind), borderRadius: BorderRadius.circular(4)),
            ),
            const SizedBox(width: 10),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.accentGold.withValues(alpha: .18),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.person_rounded, color: AppColors.primary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cases[i].name, style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Text(cases[i].reason,
                      style: TextStyle(
                          color: badgeColor(cases[i].kind), fontWeight: FontWeight.w700, fontSize: 12.5)),
                  const SizedBox(height: 2),
                  Text(cases[i].place, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                ],
              ),
            ),
            StatusBadge(text: cases[i].status, kind: cases[i].kind),
          ]),
        ),
      ),
    );
  }
}

class _R {
  final String name;
  final String reason;
  final String place;
  final BadgeKind kind;
  final String status;
  const _R(this.name, this.reason, this.place, this.kind, this.status);
}
