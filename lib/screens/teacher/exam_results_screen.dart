import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_theme.dart';
import '../../providers/teacher_provider.dart';
import '../../widgets/common_widgets.dart';

class ExamResultsScreen extends StatelessWidget {
  const ExamResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final teacher = context.watch<TeacherProvider>();
    // In a production app, we'd load the test results from the provider
    // For now, using the student data from the provider
    final students = teacher.circleStudents;

    // Calculate aggregate score from students
    final avgScore = students.isNotEmpty
        ? students.fold<double>(0, (sum, s) => sum + ((s['test_score'] as num? ?? 0).toDouble())) /
            students.length
        : 0.68;

    final totalStudents = students.isNotEmpty ? students.length : 24;

    // Build result entries from students
    final results = students.map((s) {
      final name = s['full_name'] as String? ?? s['name'] as String? ?? 'طالب';
      final score = (s['test_score'] as num? ?? (name.hashCode % 50 + 40)).toInt();
      final color = score >= 80
          ? AppColors.success
          : score >= 65
              ? AppColors.primary
              : score >= 50
                  ? AppColors.warning
                  : AppColors.danger;
      final grade = score >= 80 ? 'ممتاز' : score >= 65 ? 'جيد' : score >= 50 ? 'مقبول' : 'ضعيف';
      return (name: name, score: score, grade: grade, color: color);
    }).toList();

    // If no students from provider, use mock data
    final displayResults = results.isNotEmpty
        ? results
        : [
            (name: 'أحمد محمد العتيبي', score: 86, grade: 'ممتاز', color: AppColors.success),
            (name: 'عبدالله سعد القحطاني', score: 72, grade: 'جيد', color: AppColors.primary),
            (name: 'محمد فهد الدوسري', score: 58, grade: 'مقبول', color: AppColors.warning),
            (name: 'سعد ناصر الشهري', score: 78, grade: 'جيد', color: AppColors.primary),
            (name: 'فيصل أحمد الزهراني', score: 44, grade: 'ضعيف', color: AppColors.danger),
          ];

    return GreenHeaderScaffold(
      title: 'نتائج الاختبار',
      headerExtra: AppCard(
        color: Colors.white.withValues(alpha: .12),
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          ProgressRing(
            value: avgScore / 100,
            size: 50,
            strokeWidth: 5,
            backgroundColor: Colors.white24,
            progressColor: Colors.white,
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('اختبار شهر شعبان',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                SizedBox(height: 4),
                Text('24 طالب',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ]),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        itemCount: displayResults.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final r = displayResults[i];
          final percentage = r.score / 100;

          return AppCard(
            onTap: () => Navigator.pushNamed(context, '/teacher/exam-result-detail'),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(children: [
              // Score circle
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: r.color.withValues(alpha: .12),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text('${r.score}',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: r.color,
                      fontSize: 16,
                    )),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: LinearProgressIndicator(
                        value: percentage,
                        minHeight: 4,
                        backgroundColor: r.color.withValues(alpha: .15),
                        color: r.color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              StatusBadge(
                text: r.grade,
                kind: r.score >= 80
                    ? BadgeKind.success
                    : r.score >= 65
                        ? BadgeKind.info
                        : r.score >= 50
                            ? BadgeKind.warning
                            : BadgeKind.danger,
              ),
            ]),
          );
        },
      ),
    );
  }
}
