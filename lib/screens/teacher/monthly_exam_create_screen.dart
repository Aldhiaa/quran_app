import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_theme.dart';
import '../../providers/teacher_provider.dart';
import '../../widgets/common_widgets.dart';

class MonthlyExamCreateScreen extends StatefulWidget {
  const MonthlyExamCreateScreen({super.key});

  @override
  State<MonthlyExamCreateScreen> createState() => _MonthlyExamCreateScreenState();
}

class _MonthlyExamCreateScreenState extends State<MonthlyExamCreateScreen> {
  final _nameCtrl = TextEditingController();
  final _monthCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _circleCtrl = TextEditingController();
  final _memorizationScopeCtrl = TextEditingController();
  final _recitationScopeCtrl = TextEditingController();
  final _rulesScopeCtrl = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _monthCtrl.dispose();
    _dateCtrl.dispose();
    _circleCtrl.dispose();
    _memorizationScopeCtrl.dispose();
    _recitationScopeCtrl.dispose();
    _rulesScopeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GreenHeaderScaffold(
      title: 'إنشاء اختبار شهري',
      bottomNavigationBar: _buildBottomBar(),
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
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'اسم الاختبار',
                    hintText: 'مثال: اختبار شهر شعبان',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _monthCtrl,
                      decoration: const InputDecoration(
                        labelText: 'الشهر',
                        hintText: 'شعبان',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _dateCtrl,
                      decoration: const InputDecoration(
                        labelText: 'تاريخ الاختبار',
                        hintText: '1446-08-15',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 12),
                TextField(
                  controller: _circleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'الحلقة',
                    hintText: 'حلقة البقرة',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('المحتوى المطلوب', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                const Text('حدد نطاق الحفظ والتلاوة للاختبار',
                    style: TextStyle(color: AppColors.muted, fontSize: 12)),
                const SizedBox(height: 12),
                InfoTile(
                  title: 'نطاق الحفظ',
                  subtitle: 'الآيات المطلوب حفظها',
                  icon: Icons.menu_book_rounded,
                  color: AppColors.primary,
                  onTap: () {},
                ),
                const SizedBox(height: 8),
                InfoTile(
                  title: 'نطاق التلاوة',
                  subtitle: 'الآيات المطلوب تلاوتها',
                  icon: Icons.record_voice_over_rounded,
                  color: AppColors.info,
                  onTap: () {},
                ),
                const SizedBox(height: 8),
                InfoTile(
                  title: 'الأحكام والمتن',
                  subtitle: 'أحكام التجويد والمتون المطلوبة',
                  icon: Icons.auto_awesome_rounded,
                  color: AppColors.accentGold,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
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
            onPressed: _submitting
                ? null
                : () async {
                    setState(() => _submitting = true);
                    final teacher = context.read<TeacherProvider>();
                    final success = await teacher.createMonthlyTest({
                      'title': _nameCtrl.text,
                      'month': _monthCtrl.text,
                      'test_date': _dateCtrl.text,
                      'circle_name': _circleCtrl.text,
                    });
                    setState(() => _submitting = false);

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(success ? 'تم إنشاء الاختبار بنجاح' : 'فشل إنشاء الاختبار'),
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
            icon: _submitting
                ? const SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.add_rounded),
            label: Text(
              _submitting ? 'جاري الإنشاء...' : 'إنشاء الاختبار',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}
