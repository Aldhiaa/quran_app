import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class ExamResultDetailScreen extends StatelessWidget {
  const ExamResultDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const subjects = [
      ('الحفظ', 45, 50, AppColors.primary),
      ('التلاوة', 42, 50, AppColors.info),
      ('الأحكام', 25, 30, AppColors.accentGold),
      ('المتن', 18, 20, AppColors.success),
      ('السلوك', 40, 50, AppColors.warning),
    ];

    final total = subjects.fold<int>(0, (sum, s) => sum + s.$2);
    final maxTotal = subjects.fold<int>(0, (sum, s) => sum + s.$3);
    final percentage = maxTotal > 0 ? total / maxTotal : 0.0;

    return GreenHeaderScaffold(
      title: 'تفاصيل النتيجة',
      headerExtra: AppCard(
        color: Colors.white.withValues(alpha: .12),
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .12),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.accentGold, width: 1.5),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.person_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('أحمد محمد العتيبي',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                SizedBox(height: 2),
                Text('اختبار شهر شعبان',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Column(children: [
            ProgressRing(value: percentage, size: 40, strokeWidth: 4,
                backgroundColor: Colors.white24, progressColor: Colors.white),
            const SizedBox(height: 2),
            Text('$total',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
          ]),
        ]),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          // Subject scores
          ...subjects.map((s) {
            final (name, score, max, color) = s;
            final pct = max > 0 ? score / max : 0.0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AppCard(
                padding: const EdgeInsets.all(14),
                child: Row(children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text('$score',
                        style: TextStyle(fontWeight: FontWeight.w800, color: color)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text(name,
                              style: const TextStyle(fontWeight: FontWeight.w700)),
                          const Spacer(),
                          Text('$score / $max',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: color,
                                  fontSize: 13)),
                        ]),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: LinearProgressIndicator(
                            value: pct,
                            minHeight: 6,
                            backgroundColor: color.withValues(alpha: .12),
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            );
          }),

          const SizedBox(height: 6),

          // Overall score card
          AppCard(
            color: AppColors.primary.withValues(alpha: .04),
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              const Icon(Icons.star_rounded, color: AppColors.accentGold, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('المجموع الكلي',
                        style: TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text('$total من $maxTotal — ${(percentage * 100).round()}%',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: percentage >= 0.7 ? AppColors.success : AppColors.warning,
                          fontSize: 16,
                        )),
                  ],
                ),
              ),
              const StarRating(rating: 4, size: 18),
            ]),
          ),

          const SizedBox(height: 12),

          // Teacher notes
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(children: [
                  Icon(Icons.rate_review_rounded, size: 18, color: AppColors.info),
                  SizedBox(width: 6),
                  Text('ملاحظات المعلم', style: TextStyle(fontWeight: FontWeight.w800)),
                ]),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: .04),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'الطالب مجتهد ويحتاج إلى تحسين في أحكام التجويد. '
                    'مستوى الحفظ جيد والمراجعة منتظمة. ينصح بمزيد من التركيز على مخارج الحروف.',
                    style: TextStyle(color: AppColors.muted, height: 1.6),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Bottom actions
          Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.share_rounded, size: 18),
                label: const Text('مشاركة'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.print_rounded, size: 18),
                label: const Text('طباعة'),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
