import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/guide_provider.dart';
import '../../widgets/common_widgets.dart';

class GuideMonthlyApprovalScreen extends StatefulWidget {
  const GuideMonthlyApprovalScreen({super.key});
  @override
  State<GuideMonthlyApprovalScreen> createState() =>
      _GuideMonthlyApprovalScreenState();
}

class _GuideMonthlyApprovalScreenState extends State<GuideMonthlyApprovalScreen> {
  int? _planId;
  final _notesController = TextEditingController();
  bool _isApproving = false;
  bool _isReturning = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is int && _planId == null) {
      _planId = args;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _approve() async {
    if (_planId == null) return;
    setState(() => _isApproving = true);
    try {
      await context.read<GuideProvider>().approveMonthlyPlan(_planId!);
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isApproving = false);
    }
  }

  Future<void> _returnPlan() async {
    if (_planId == null) return;
    if (_notesController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى كتابة ملاحظات الإرجاع')),
      );
      return;
    }
    setState(() => _isReturning = true);
    try {
      await context.read<GuideProvider>().returnMonthlyPlan(
        _planId!,
        _notesController.text.trim(),
      );
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isReturning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('الحفظ', 47, 50, AppColors.primary),
      ('التلاوة', 44, 50, AppColors.primary),
      ('الأحكام', 27, 30, AppColors.info),
      ('المتن', 19, 20, AppColors.info),
      ('السلوك', 49, 50, AppColors.success),
    ];
    final total = rows.fold<int>(0, (a, r) => a + r.$2);

    return GreenHeaderScaffold(
      title: 'اعتماد الخطة الشهرية',
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
                Text('الخطة الشهرية',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 15)),
                SizedBox(height: 3),
                Text('الخطة قيد المراجعة',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ]),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isReturning ? null : _returnPlan,
                  icon: _isReturning
                      ? const SizedBox(
                          width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.undo_rounded),
                  label: const Text('إرجاع',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    side: const BorderSide(color: AppColors.danger),
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isApproving ? null : _approve,
                  icon: _isApproving
                      ? const SizedBox(
                          width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.check_circle_rounded),
                  label: const Text('اعتماد',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          AppCard(
            child: Column(children: [
              for (final r in rows) ...[
                Row(children: [
                  Container(
                      width: 8,
                      height: 32,
                      decoration: BoxDecoration(
                          color: r.$4,
                          borderRadius: BorderRadius.circular(2))),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Text(r.$1,
                          style: const TextStyle(fontWeight: FontWeight.w700))),
                  Text('${r.$2} / ${r.$3}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary)),
                ]),
                if (r != rows.last) const Divider(),
              ],
            ]),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ملاحظات الإرجاع',
                    style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                TextField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'ملاحظات حول أسباب الإرجاع...',
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md)),
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
