import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/supervisor_provider.dart';
import '../../widgets/common_widgets.dart';

class SupervisorVisitFormScreen extends StatefulWidget {
  final int? visitId;
  const SupervisorVisitFormScreen({super.key, this.visitId});
  @override
  State<SupervisorVisitFormScreen> createState() => _SupervisorVisitFormScreenState();
}

class _SupervisorVisitFormScreenState extends State<SupervisorVisitFormScreen> {
  final List<bool> _checks = List<bool>.filled(6, false);
  static const _items = [
    'حضور المعلم في الوقت المحدد',
    'انتظام الطلاب وحضورهم',
    'التزام المعلم بدفتر المتابعة',
    'مستوى التفاعل في الحلقة',
    'تطبيق أحكام التلاوة',
    'النظافة العامة للمكان',
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
                _row(Icons.business_rounded, 'المركز', 'مركز النور'),
                const Divider(),
                _row(Icons.menu_book_rounded, 'الحلقة', 'حلقة البقرة'),
                const Divider(),
                _row(Icons.calendar_month_rounded, 'التاريخ', '1446/11/05'),
                const Divider(),
                _row(Icons.access_time_rounded, 'الوقت', '9:30 ص'),
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
