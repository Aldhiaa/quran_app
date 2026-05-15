import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_theme.dart';
import '../../providers/teacher_provider.dart';
import '../../widgets/common_widgets.dart';

class StudentDetailScreen extends StatelessWidget {
  const StudentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final teacher = context.watch<TeacherProvider>();
    final student = teacher.selectedStudent ?? {};

    final name = student['full_name'] as String? ?? student['name'] as String? ?? 'طالب';
    final circleName = student['circle_name'] as String? ??
        student['circle']?['name'] as String? ??
        'حلقة';
    final memorizedParts = student['memorized_parts'] as int? ?? 0;
    final reviewedParts = student['reviewed_parts'] as int? ?? 0;
    final attendanceRate = (student['attendance_rate'] as num?)?.toDouble() ?? 0.0;
    final behavior = student['behavior'] as String? ?? '';
    final isActive = student['is_active'] as bool? ?? true;

    // Determine status
    final String statusText;
    final BadgeKind statusKind;
    if (attendanceRate >= 0.9) {
      statusText = 'متفوق';
      statusKind = BadgeKind.success;
    } else if (attendanceRate >= 0.7) {
      statusText = 'جيد';
      statusKind = BadgeKind.info;
    } else if (attendanceRate >= 0.5) {
      statusText = 'متابعة';
      statusKind = BadgeKind.warning;
    } else {
      statusText = 'ضعيف';
      statusKind = BadgeKind.danger;
    }

    // Mock test average for display (would come from API in production)
    final testAvg = student['test_average'] as num? ?? 85;

    return GreenHeaderScaffold(
      title: 'ملف الطالب',
      headerExtra: AppCard(
        color: Colors.white.withValues(alpha: .12),
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .12),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.accentGold, width: 1.5),
            ),
            alignment: Alignment.center,
            child: Text(
              name[0],
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 22),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 4),
                Text('$circleName • الجزء $memorizedParts',
                    style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
              ],
            ),
          ),
          StatusBadge(text: statusText, kind: statusKind),
        ]),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          // KPIs
          KpiGrid(items: [
            KpiCard(
              label: 'المحفوظ',
              value: '$memorizedParts أجزاء',
              icon: Icons.menu_book_rounded,
              color: AppColors.primary,
            ),
            KpiCard(
              label: 'المراجعة',
              value: '$reviewedParts أجزاء',
              icon: Icons.replay_rounded,
              color: AppColors.info,
            ),
            KpiCard(
              label: 'الحضور',
              value: '${(attendanceRate * 100).round()}٪',
              icon: Icons.check_circle_rounded,
              color: AppColors.success,
            ),
            KpiCard(
              label: 'الاختبارات',
              value: '$testAvg',
              icon: Icons.star_rounded,
              color: AppColors.accentGold,
            ),
          ]),
          const SizedBox(height: 14),

          // Memorization Progress
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('التقدم في الحفظ', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                Row(children: [
                  ProgressRing(
                    value: memorizedParts > 0 ? memorizedParts / 30 : 0,
                    size: 70,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('الجزء $memorizedParts من 30',
                            style: const TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text(behavior.isNotEmpty ? 'السلوك: $behavior' : 'لا توجد ملاحظات سلوكية',
                            style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                      ],
                    ),
                  ),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Quick Actions
          const AppSectionTitle(title: 'الإجراءات'),
          const SizedBox(height: 10),

          InfoTile(
            title: 'تسجيل تسميع',
            subtitle: 'تسميع جديد لليوم',
            icon: Icons.record_voice_over_rounded,
            color: AppColors.primary,
            onTap: () => Navigator.pushNamed(context, '/teacher/daily-followup'),
          ),
          const SizedBox(height: 10),
          InfoTile(
            title: 'تقييم أسبوعي',
            subtitle: 'إدخال تقييم لهذا الأسبوع',
            icon: Icons.fact_check_rounded,
            color: AppColors.info,
            onTap: () => Navigator.pushNamed(context, '/teacher/weekly-evaluation'),
          ),
          const SizedBox(height: 10),
          InfoTile(
            title: 'نتيجة الاختبار الشهري',
            subtitle: 'عرض / إدخال الدرجات',
            icon: Icons.grade_rounded,
            color: AppColors.accentGold,
            onTap: () => Navigator.pushNamed(context, '/teacher/grades-entry'),
          ),
          const SizedBox(height: 10),
          InfoTile(
            title: 'متابعة طالب ضعيف',
            subtitle: 'خطة معالجة وتوصيات',
            icon: Icons.priority_high_rounded,
            color: AppColors.danger,
            onTap: () {
              _showRemedialPlanDialog(context, name);
            },
          ),
        ],
      ),
    );
  }

  void _showRemedialPlanDialog(BuildContext context, String studentName) {
    final planCtrl = TextEditingController();
    final recommendationsCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('خطة معالجة — $studentName'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: planCtrl,
                decoration: const InputDecoration(
                  labelText: 'الخطة العلاجية',
                  hintText: 'أدخل تفاصيل الخطة...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: recommendationsCtrl,
                decoration: const InputDecoration(
                  labelText: 'التوصيات',
                  hintText: 'أدخل التوصيات...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              // Create remedial plan via provider
              context.read<TeacherProvider>().createRemedialPlan({
                'student_name': studentName,
                'plan': planCtrl.text,
                'recommendations': recommendationsCtrl.text,
              });
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حفظ الخطة العلاجية')),
              );
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}
