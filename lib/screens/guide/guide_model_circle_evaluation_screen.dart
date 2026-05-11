import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class GuideModelCircleEvaluationScreen extends StatefulWidget {
  const GuideModelCircleEvaluationScreen({super.key});
  @override
  State<GuideModelCircleEvaluationScreen> createState() =>
      _GuideModelCircleEvaluationScreenState();
}

class _GuideModelCircleEvaluationScreenState extends State<GuideModelCircleEvaluationScreen> {
  static const _criteria = [
    'البنية التحتية والمكان',
    'مستوى الطالبات والتقدم',
    'الأنشطة الإثرائية',
    'الالتزام الإداري والإشرافي',
    'الإبداع والتجديد في التعليم',
  ];
  late List<int> _scores;

  @override
  void initState() {
    super.initState();
    _scores = List<int>.filled(_criteria.length, 0);
  }

  int get _total => _scores.fold(0, (a, b) => a + b);

  @override
  Widget build(BuildContext context) {
    final maxTotal = _criteria.length * 5;
    final pct = _total / maxTotal;
    return GreenHeaderScaffold(
      title: 'تقييم حلقة نموذجية',
      headerExtra: AppCard(
        color: Colors.white.withValues(alpha: .12),
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          ProgressRing(
            value: pct,
            size: 64,
            strokeWidth: 8,
            color: AppColors.accentGold,
            trackColor: Colors.white.withValues(alpha: .25),
            label: '$_total/$maxTotal',
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('حلقة النور',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                SizedBox(height: 3),
                Text('مركز الإيمان • أ. منى السبيعي',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                SizedBox(height: 6),
                StarRating(value: 4),
              ],
            ),
          ),
        ]),
      ),
      bottomNavigationBar: const DraftSubmitBar(),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        itemCount: _criteria.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => AppCard(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: AppColors.accentGold.withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text('${i + 1}',
                      style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w800)),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(_criteria[i], style: const TextStyle(fontWeight: FontWeight.w700))),
                Text('${_scores[i]} / 5',
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800)),
              ]),
              const SizedBox(height: 10),
              RatingSelector(max: 5, value: _scores[i], onChanged: (v) => setState(() => _scores[i] = v)),
            ],
          ),
        ),
      ),
    );
  }
}
