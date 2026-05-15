import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/supervisor_provider.dart';
import '../../widgets/common_widgets.dart';

class SupervisorMonthlyApprovalScreen extends StatefulWidget {
  final int? testId;
  const SupervisorMonthlyApprovalScreen({super.key, this.testId});
  @override
  State<SupervisorMonthlyApprovalScreen> createState() => _SupervisorMonthlyApprovalScreenState();
}

class _SupervisorMonthlyApprovalScreenState extends State<SupervisorMonthlyApprovalScreen> {
  final _notesCtrl = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _approve() async {
    setState(() => _submitting = true);
    final ok = await context.read<SupervisorProvider>().approveMonthlyTest(widget.testId ?? 0);
    if (mounted) {
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ok ? 'تم اعتماد الاختبار' : 'فشل الاعتماد'),
        backgroundColor: ok ? AppColors.success : AppColors.danger,
      ));
      if (ok) Navigator.pop(context);
    }
  }

  Future<void> _returnForRevision() async {
    if (_notesCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('يرجى إدخال ملاحظات الإرجاع'),
        backgroundColor: AppColors.warning,
      ));
      return;
    }
    setState(() => _submitting = true);
    final ok = await context.read<SupervisorProvider>().returnMonthlyTest(widget.testId ?? 0, _notesCtrl.text);
    if (mounted) {
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ok ? 'تم إرجاع الاختبار' : 'فشل الإرجاع'),
        backgroundColor: ok ? AppColors.success : AppColors.danger,
      ));
      if (ok) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('الحفظ', 45, 50, AppColors.primary),
      ('التلاوة', 42, 50, AppColors.primary),
      ('الأحكام', 25, 30, AppColors.info),
      ('المتن', 18, 20, AppColors.info),
      ('السلوك', 48, 50, AppColors.success),
    ];
    final total = rows.fold<int>(0, (a, r) => a + r.$2);
    return GreenHeaderScaffold(
      title: 'اعتماد الاختبار الشهري',
      headerExtra: AppCard(
        color: Colors.white.withValues(alpha: .12),
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          ProgressRing(
            value: total / 200,
            size: 64,
            strokeWidth: 8,
            color: AppColors.accentGold,
            trackColor: Colors.white.withValues(alpha: .25),
            label: '${(total / 200 * 100).round()}٪',
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('اختبار شهري',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                SizedBox(height: 3),
                Text('بانتظار الاعتماد',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Text('$total / 200',
              style: const TextStyle(color: AppColors.accentGold, fontWeight: FontWeight.w800)),
        ]),
      ),
      bottomNavigationBar: _submitting
          ? const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Row(children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _returnForRevision,
                      icon: const Icon(Icons.replay_rounded, color: AppColors.primary),
                      label: const Text('إرجاع', style: TextStyle(fontWeight: FontWeight.w700)),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _approve,
                      icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
                      label: const Text('اعتماد', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                        backgroundColor: AppColors.success,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          AppCard(
            child: Column(
              children: [
                for (final r in rows) ...[
                  Row(children: [
                    Container(width: 8, height: 32,
                        decoration: BoxDecoration(color: r.$4, borderRadius: BorderRadius.circular(2))),
                    const SizedBox(width: 10),
                    Expanded(child: Text(r.$1, style: const TextStyle(fontWeight: FontWeight.w700))),
                    Text('${r.$2} / ${r.$3}',
                        style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary)),
                  ]),
                  if (r != rows.last) const Divider(),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ملاحظات الاعتماد', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                TextField(
                  controller: _notesCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'أضف ملاحظات للمعلم (مطلوبة في حال الإرجاع)',
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
}
