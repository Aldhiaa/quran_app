import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/supervisor_provider.dart';
import '../../widgets/common_widgets.dart';

class SupervisorWeeklyReviewScreen extends StatefulWidget {
  final int? evaluationId;
  const SupervisorWeeklyReviewScreen({super.key, this.evaluationId});
  @override
  State<SupervisorWeeklyReviewScreen> createState() => _SupervisorWeeklyReviewScreenState();
}

class _SupervisorWeeklyReviewScreenState extends State<SupervisorWeeklyReviewScreen> {
  final _notesCtrl = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _approve() async {
    setState(() => _submitting = true);
    final provider = context.read<SupervisorProvider>();
    final ok = await provider.approveWeeklyEvaluation(widget.evaluationId ?? 0);
    if (mounted) {
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ok ? 'تم اعتماد التقييم' : 'فشل الاعتماد'),
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
    final provider = context.read<SupervisorProvider>();
    final ok = await provider.returnWeeklyEvaluation(widget.evaluationId ?? 0, _notesCtrl.text);
    if (mounted) {
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ok ? 'تم إرجاع التقييم' : 'فشل الإرجاع'),
        backgroundColor: ok ? AppColors.success : AppColors.danger,
      ));
      if (ok) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('الالتزام بالشعائر التعبدية', 9),
      ('الالتزام بالأدب العام', 10),
      ('الانضباط في المواعيد', 8),
      ('الانضباط في الحلقة القرآنية', 9),
      ('الانضباط في الدراسة النظامية', 7),
      ('النظافة والترتيب', 8),
      ('المحافظة على الممتلكات', 9),
      ('روح المبادرة والتعاون', 8),
      ('التميز في جانب معين', 7),
      ('التأثير الإيجابي في الآخرين', 9),
    ];
    final total = rows.fold<int>(0, (a, r) => a + r.$2);
    return GreenHeaderScaffold(
      title: 'مراجعة التقييم الأسبوعي',
      headerExtra: AppCard(
        color: Colors.white.withValues(alpha: .12),
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          ProgressRing(
            value: total / 100,
            size: 64,
            strokeWidth: 8,
            color: AppColors.accentGold,
            trackColor: Colors.white.withValues(alpha: .25),
            label: '$total',
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('التقييم الأسبوعي',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                SizedBox(height: 3),
                Text('بانتظار المراجعة',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Text('$total / 100',
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
            child: Column(children: [
              for (final r in rows) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(children: [
                    Expanded(child: Text(r.$1, style: const TextStyle(fontWeight: FontWeight.w700))),
                    Text('${r.$2} / 10',
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800)),
                  ]),
                ),
                if (r != rows.last) const Divider(height: 0),
              ],
            ]),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ملاحظات الإرجاع', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                TextField(
                  controller: _notesCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'أضف ملاحظات (مطلوبة في حال الإرجاع)',
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
