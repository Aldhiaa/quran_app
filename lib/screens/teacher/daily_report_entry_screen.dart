import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class DailyReportEntryScreen extends StatefulWidget {
  const DailyReportEntryScreen({super.key});
  @override
  State<DailyReportEntryScreen> createState() => _DailyReportEntryScreenState();
}

class _DailyReportEntryScreenState extends State<DailyReportEntryScreen> {
  int _circle = 0;

  @override
  Widget build(BuildContext context) {
    return GreenHeaderScaffold(
      title: 'تقرير المتابعة اليومي',
      headerExtra: AppCard(
        color: Colors.white.withValues(alpha: .12),
        padding: const EdgeInsets.all(12),
        child: Row(children: const [
          Icon(Icons.calendar_today_rounded, color: AppColors.accentGold),
          SizedBox(width: 8),
          Text('السبت — 1446/11/05',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        ]),
      ),
      bottomNavigationBar: const DraftSubmitBar(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('اختر الحلقة', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                FilterChipsBar(
                  items: const ['حلقة البقرة', 'حلقة آل عمران', 'حلقة النساء'],
                  selected: _circle,
                  onChanged: (i) => setState(() => _circle = i),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          InfoTile(
            title: 'تسجيل الحضور',
            subtitle: '21 / 24 طالب',
            icon: Icons.how_to_reg_rounded,
            color: AppColors.success,
            onTap: () => Navigator.pushNamed(context, '/teacher/attendance-entry'),
          ),
          const SizedBox(height: 10),
          InfoTile(
            title: 'إدخال الحفظ والمراجعة',
            subtitle: 'دفتر المتابعة',
            icon: Icons.menu_book_rounded,
            color: AppColors.primary,
            onTap: () => Navigator.pushNamed(context, '/teacher/daily-followup'),
          ),
          const SizedBox(height: 10),
          InfoTile(
            title: 'ملاحظات التجويد والسلوك',
            subtitle: 'إضافة ملاحظات للطلاب',
            icon: Icons.edit_note_rounded,
            color: AppColors.info,
            onTap: () {},
          ),
          const SizedBox(height: 10),
          InfoTile(
            title: 'إسناد الواجب',
            subtitle: 'تحديد المهمة لليوم القادم',
            icon: Icons.assignment_rounded,
            color: AppColors.accentGold,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
