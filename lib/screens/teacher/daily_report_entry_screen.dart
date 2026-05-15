import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_theme.dart';
import '../../providers/teacher_provider.dart';
import '../../widgets/common_widgets.dart';

/// Daily Report Entry screen — the hub for entering a complete daily session report.
/// Links to: attendance, follow-up (دفتر المتابعة), tajweed notes, homework.
class DailyReportEntryScreen extends StatefulWidget {
  const DailyReportEntryScreen({super.key});

  @override
  State<DailyReportEntryScreen> createState() => _DailyReportEntryScreenState();
}

class _DailyReportEntryScreenState extends State<DailyReportEntryScreen> {
  int _circle = 0;

  @override
  Widget build(BuildContext context) {
    final teacher = context.watch<TeacherProvider>();
    final circles = teacher.circles;

    return GreenHeaderScaffold(
      title: 'تقرير المتابعة اليومي',
      headerExtra: AppCard(
        color: Colors.white.withValues(alpha: .12),
        padding: const EdgeInsets.all(12),
        child: Row(children: const [
          Icon(Icons.calendar_today_rounded, color: AppColors.accentGold),
          SizedBox(width: 8),
          Text('اليوم',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        ]),
      ),
      bottomNavigationBar: const DraftSubmitBar(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          // Circle selector (if multiple circles)
          if (circles.length > 1)
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('اختر الحلقة', style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  FilterChipsBar(
                    items: circles.map((c) => c['name'] as String? ?? 'حلقة').toList(),
                    selected: _circle,
                    onChanged: (i) => setState(() => _circle = i),
                  ),
                ],
              ),
            ),

          if (circles.length > 1) const SizedBox(height: 12),

          // Entry sections
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(children: [
                  Icon(Icons.menu_book_rounded, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text('أقسام التقرير', style: TextStyle(fontWeight: FontWeight.w800)),
                ]),
                const SizedBox(height: 12),

                InfoTile(
                  title: 'تسجيل الحضور',
                  subtitle: 'تحديد حالة حضور الطلاب',
                  icon: Icons.how_to_reg_rounded,
                  color: AppColors.success,
                  onTap: () => Navigator.pushNamed(context, '/teacher/attendance-entry'),
                ),
                const SizedBox(height: 8),

                InfoTile(
                  title: 'إدخال الحفظ والمراجعة',
                  subtitle: 'دفتر المتابعة — تسميع ومراجعة الطلاب',
                  icon: Icons.menu_book_rounded,
                  color: AppColors.primary,
                  onTap: () => Navigator.pushNamed(context, '/teacher/daily-followup'),
                ),
                const SizedBox(height: 8),

                InfoTile(
                  title: 'ملاحظات التجويد والسلوك',
                  subtitle: 'إضافة ملاحظات للطلاب أثناء التسميع',
                  icon: Icons.edit_note_rounded,
                  color: AppColors.info,
                  onTap: () => Navigator.pushNamed(context, '/teacher/daily-followup'),
                ),
                const SizedBox(height: 8),

                InfoTile(
                  title: 'إسناد الواجب',
                  subtitle: 'تحديد المهمة لليوم القادم',
                  icon: Icons.assignment_rounded,
                  color: AppColors.accentGold,
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Quick summary
          AppCard(
            color: AppColors.primary.withValues(alpha: .03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(children: [
                  Icon(Icons.summarize_rounded, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text('ملخص سريع', style: TextStyle(fontWeight: FontWeight.w800)),
                ]),
                const SizedBox(height: 10),
                _SummaryRow(
                  label: 'الحضور',
                  value: '21 / 24',
                  icon: Icons.check_circle_rounded,
                  color: AppColors.success,
                ),
                const SizedBox(height: 6),
                _SummaryRow(
                  label: 'الحفظ الجديد',
                  value: 'تم إدخاله',
                  icon: Icons.menu_book_rounded,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 6),
                _SummaryRow(
                  label: 'المراجعة',
                  value: 'تم إدخالها',
                  icon: Icons.replay_rounded,
                  color: AppColors.info,
                ),
                const SizedBox(height: 6),
                _SummaryRow(
                  label: 'الملاحظات',
                  value: '2 طلاب بحاجة متابعة',
                  icon: Icons.priority_high_rounded,
                  color: AppColors.warning,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 16, color: color),
      const SizedBox(width: 6),
      Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      const Spacer(),
      Text(value,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: color,
            fontSize: 13,
          )),
    ]);
  }
}
