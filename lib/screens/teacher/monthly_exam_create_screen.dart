import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class MonthlyExamCreateScreen extends StatelessWidget {
  const MonthlyExamCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GreenHeaderScaffold(
      title: 'إنشاء اختبار شهري',
      bottomNavigationBar: const DraftSubmitBar(submitLabel: 'إنشاء الاختبار'),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('بيانات الاختبار', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'اسم الاختبار',
                    prefixIcon: const Icon(Icons.title_rounded),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                  ),
                ),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'الشهر',
                        prefixIcon: const Icon(Icons.calendar_month_rounded),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'تاريخ الاختبار',
                        prefixIcon: const Icon(Icons.event_rounded),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'الحلقة',
                    prefixIcon: const Icon(Icons.menu_book_rounded),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('المحتوى المطلوب', style: TextStyle(fontWeight: FontWeight.w800)),
                SizedBox(height: 8),
                Text('حدد نطاق الحفظ والتلاوة والأحكام',
                    style: TextStyle(color: AppColors.muted, fontSize: 12.5)),
                SizedBox(height: 12),
                InfoTile(
                  title: 'نطاق الحفظ',
                  subtitle: 'من — إلى',
                  icon: Icons.menu_book_rounded,
                  color: AppColors.primary,
                ),
                SizedBox(height: 8),
                InfoTile(
                  title: 'نطاق التلاوة',
                  subtitle: 'من — إلى',
                  icon: Icons.record_voice_over_rounded,
                  color: AppColors.info,
                ),
                SizedBox(height: 8),
                InfoTile(
                  title: 'الأحكام والمتن',
                  subtitle: 'محتوى الاختبار',
                  icon: Icons.rule_rounded,
                  color: AppColors.accentGold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
