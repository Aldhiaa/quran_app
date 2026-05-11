import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class GuideVisitFormScreen extends StatefulWidget {
  const GuideVisitFormScreen({super.key});
  @override
  State<GuideVisitFormScreen> createState() => _GuideVisitFormScreenState();
}

class _GuideVisitFormScreenState extends State<GuideVisitFormScreen> {
  final List<bool> _checks = List<bool>.filled(7, false);
  static const _items = [
    'حضور المشرفة في الوقت المحدد',
    'تنظيم الحلقات وتوزيع الطالبات',
    'تطبيق الخطة المعتمدة',
    'متابعة المعلمات بشكل دوري',
    'جودة البيئة التعليمية',
    'الالتزام بالإجراءات الإدارية',
    'التواصل مع أولياء الأمور',
  ];

  @override
  Widget build(BuildContext context) {
    return GreenHeaderScaffold(
      title: 'استمارة الزيارة',
      bottomNavigationBar: const DraftSubmitBar(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('بيانات الزيارة', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                _row(Icons.business_rounded, 'المركز', 'مركز الإيمان'),
                const Divider(),
                _row(Icons.person_2_rounded, 'المشرفة', 'أ. منى السبيعي'),
                const Divider(),
                _row(Icons.calendar_month_rounded, 'التاريخ', '1446/11/05'),
                const Divider(),
                _row(Icons.access_time_rounded, 'الوقت', '9:00 ص'),
                const Divider(),
                _row(Icons.assignment_rounded, 'نوع الزيارة', 'مجدولة'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('بنود التقييم', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                ...List.generate(_items.length, (i) => CheckboxListTile(
                      value: _checks[i],
                      onChanged: (v) => setState(() => _checks[i] = v ?? false),
                      title: Text(_items[i], style: const TextStyle(fontWeight: FontWeight.w600)),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: AppColors.primary,
                      dense: true,
                    )),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('الملاحظات والتوصيات', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'اكتب الملاحظات هنا...',
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 12.5)),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
      ]),
    );
  }
}
