import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_theme.dart';
import '../../providers/teacher_provider.dart';
import '../../widgets/common_widgets.dart';

/// Weekly family evaluation screen — evaluates students on behavior and commitment.
/// Connected to the TeacherProvider for data persistence.
class WeeklyEvaluationScreen extends StatefulWidget {
  const WeeklyEvaluationScreen({super.key});

  @override
  State<WeeklyEvaluationScreen> createState() => _WeeklyEvaluationScreenState();
}

class _WeeklyEvaluationScreenState extends State<WeeklyEvaluationScreen> {
  late List<int> _scores;
  int _selectedCircleIndex = 0;
  bool _submitting = false;

  static const _criteria = [
    ('الالتزام بالحضور', 'مدى انتظام الطالب في الحضور', 10),
    ('المواظبة على الحفظ', 'مدى التزام الطالب بواجبات الحفظ', 15),
    ('السلوك والأخلاق', 'تعامل الطالب مع زملائه ومعلمه', 15),
    ('الانضباط في الحلقة', 'الالتزام بتعليمات الحلقة والنظام', 10),
    ('المشاركة والتفاعل', 'مشاركة الطالب في الأنشطة الحلقية', 10),
    ('الاهتمام بالتجويد', 'حرص الطالب على تطبيق أحكام التجويد', 10),
    ('المراجعة الذاتية', 'مدى مراجعة الطالب للدروس السابقة', 10),
    ('العناية بالمصحف', 'مدى اهتمام الطالب بنظافة المصحف والعناية به', 5),
    ('التعاون مع الزملاء', 'مساعدة الطالب لزملائه وتعاونه معهم', 5),
    ('المبادرة والاجتهاد', 'مدى مبادرة الطالب واجتهاده في التعلم', 10),
  ];

  static int get maxScore => _criteria.fold(0, (sum, c) => sum + c.$3);

  @override
  void initState() {
    super.initState();
    _scores = List.filled(_criteria.length, 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeacherProvider>().loadCircles();
    });
  }

  int get totalScore => _scores.fold(0, (sum, s) => sum + s);
  double get percentage => maxScore > 0 ? totalScore / maxScore : 0;

  @override
  Widget build(BuildContext context) {
    final teacher = context.watch<TeacherProvider>();
    final circles = teacher.circles;

    return GreenHeaderScaffold(
      title: 'التقييم الأسبوعي',
      headerExtra: AppCard(
        color: Colors.white.withValues(alpha: .12),
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          const Icon(Icons.calendar_view_week_rounded, color: AppColors.accentGold),
          const SizedBox(width: 8),
          const Text('هذا الأسبوع',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          const Spacer(),
          ProgressRing(
            value: percentage,
            size: 36,
            strokeWidth: 4,
            trackColor: Colors.white24,
            color: percentage >= 0.7 ? AppColors.success : AppColors.warning,
          ),
          const SizedBox(width: 8),
          Text('$totalScore / $maxScore',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
        ]),
      ),
      bottomNavigationBar: _buildBottomBar(teacher),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          // Circle selector
          if (circles.isNotEmpty)
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('اختر الحلقة', style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  FilterChipsBar(
                    items: circles.map((c) => c['name'] as String? ?? 'حلقة').toList(),
                    selected: _selectedCircleIndex,
                    onChanged: (i) => setState(() => _selectedCircleIndex = i),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),

          // Evaluation criteria
          ...List.generate(_criteria.length, (i) {
            final (title, desc, max) = _criteria[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AppCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title,
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                            const SizedBox(height: 2),
                            Text(desc,
                                style: const TextStyle(color: AppColors.muted, fontSize: 11.5)),
                          ],
                        ),
                      ),
                      Text('$max',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: _scores[i] >= max
                                  ? AppColors.success
                                  : AppColors.primary,
                              fontSize: 16)),
                    ]),
                    const SizedBox(height: 8),
                    RatingSelector(
                      value: _scores[i],
                      max: max,
                      onChanged: (v) => setState(() => _scores[i] = v),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBottomBar(TeacherProvider teacher) {
    if (_submitting) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () async {
              setState(() => _submitting = true);

              // Build evaluation items
              final items = List.generate(_criteria.length, (i) => {
                'criterion': _criteria[i].$1,
                'score': _scores[i],
                'max_score': _criteria[i].$3,
              });

              final success = await teacher.saveWeeklyEvaluation({
                'circle_index': _selectedCircleIndex,
                'total_score': totalScore,
                'percentage': percentage,
                'items': items,
              });

              setState(() => _submitting = false);

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'تم حفظ التقييم الأسبوعي' : 'فشل حفظ التقييم'),
                    backgroundColor: success ? AppColors.success : AppColors.danger,
                  ),
                );
                if (success) Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.save_rounded),
            label: const Text('حفظ التقييم', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          ),
        ),
      ),
    );
  }
}
