import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class SupervisorWeeklyReviewScreen extends StatelessWidget {
  const SupervisorWeeklyReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('الالتزام بالشعائر التعبدية', 9),
      ('الالتزام بالأدب العام', 10),
      ('الانضباط في المواعيد', 8),
      ('الانضباط في الحلقة القرآنية', 9),
      ('الانضباط في الدراسة النظامية', 7),
      ('النظافة والترتيب', 8),
      ('المحافظة على الممتلكات', 9),
      ('روح المبادرة والتعاون', 8),
      ('التميز في جانب معين', 7),
      ('التأثير الإيجابي في الآخرين', 9),
    ];
    final total = rows.fold<int>(0, (a, r) => a + r.$2);
    return GreenHeaderScaffold(
      title: 'مراجعة التقييم الأسبوعي',
      headerExtra: AppCard(
        color: Colors.white.withValues(alpha: .12),
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          ProgressRing(
            value: total / 100,
            size: 64,
            strokeWidth: 8,
            color: AppColors.accentGold,
            trackColor: Colors.white.withValues(alpha: .25),
            label: '$total',
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('أحمد العتيبي',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                SizedBox(height: 3),
                Text('من المعلم: أ. سعد القحطاني',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Text('$total / 100',
              style: const TextStyle(color: AppColors.accentGold, fontWeight: FontWeight.w800)),
        ]),
      ),
      bottomNavigationBar: const ApprovalActionBar(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          AppCard(
            child: Column(children: [
              for (final r in rows) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(children: [
                    Expanded(child: Text(r.$1, style: const TextStyle(fontWeight: FontWeight.w700))),
                    Text('${r.$2} / 10',
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800)),
                  ]),
                ),
                if (r != rows.last) const Divider(height: 0),
              ],
            ]),
          ),
        ],
      ),
    );
  }
}
