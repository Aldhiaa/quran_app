import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class GuideMonthlyApprovalScreen extends StatelessWidget {
  const GuideMonthlyApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('الحفظ', 47, 50, AppColors.primary),
      ('التلاوة', 44, 50, AppColors.primary),
      ('الأحكام', 27, 30, AppColors.info),
      ('المتن', 19, 20, AppColors.info),
      ('السلوك', 49, 50, AppColors.success),
    ];
    final total = rows.fold<int>(0, (a, r) => a + r.$2);
    return GreenHeaderScaffold(
      title: 'اعتماد الاختبار الشهري',
      headerExtra: AppCard(
        color: Colors.white.withValues(alpha: .12),
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          ProgressRing(
            value: total / 200,
            size: 64,
            strokeWidth: 8,
            color: AppColors.accentGold,
            trackColor: Colors.white.withValues(alpha: .25),
            label: '${(total / 200 * 100).round()}٪',
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('اختبار شهر شعبان',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                SizedBox(height: 3),
                Text('حلقة النور • مركز الإيمان',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Text('$total / 200',
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
                Row(children: [
                  Container(width: 8, height: 32,
                      decoration: BoxDecoration(color: r.$4, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(width: 10),
                  Expanded(child: Text(r.$1, style: const TextStyle(fontWeight: FontWeight.w700))),
                  Text('${r.$2} / ${r.$3}',
                      style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary)),
                ]),
                if (r != rows.last) const Divider(),
              ],
            ]),
          ),
        ],
      ),
    );
  }
}
