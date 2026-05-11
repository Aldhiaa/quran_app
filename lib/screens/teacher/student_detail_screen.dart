import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class StudentDetailScreen extends StatelessWidget {
  const StudentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            child: const Icon(Icons.person_rounded, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('أحمد محمد العتيبي',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                SizedBox(height: 4),
                Text('حلقة البقرة • الجزء 5',
                    style: TextStyle(color: Colors.white70, fontSize: 12.5)),
              ],
            ),
          ),
          const StatusBadge(text: 'متفوق', kind: BadgeKind.success),
        ]),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          const KpiGrid(items: [
            KpiCard(label: 'متوسط الحفظ', value: '92٪', icon: Icons.menu_book_rounded, color: AppColors.primary),
            KpiCard(label: 'الحضور', value: '96٪', icon: Icons.check_circle_rounded, color: AppColors.success),
            KpiCard(label: 'الاختبارات', value: '5', icon: Icons.assignment_rounded, color: AppColors.info),
            KpiCard(label: 'التقييم', value: '4.5', icon: Icons.star_rounded, color: AppColors.accentGold),
          ]),
          const SizedBox(height: 14),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('التقدم في الحفظ', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                Row(children: const [
                  ProgressRing(value: .92, size: 70),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('الجزء 5 من القرآن', style: TextStyle(fontWeight: FontWeight.w700)),
                        SizedBox(height: 4),
                        Text('آخر تسميع: سورة النساء • الآية 23',
                            style: TextStyle(color: AppColors.muted, fontSize: 12)),
                      ],
                    ),
                  ),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 14),
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
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
