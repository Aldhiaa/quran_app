import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class GradesEntryScreen extends StatefulWidget {
  const GradesEntryScreen({super.key});
  @override
  State<GradesEntryScreen> createState() => _GradesEntryScreenState();
}

class _GradesEntryScreenState extends State<GradesEntryScreen> {
  static const _fields = [
    ('الحفظ', 50),
    ('التلاوة', 50),
    ('الأحكام', 30),
    ('المتن', 20),
    ('السلوك', 50),
  ];
  late List<int> _scores;

  @override
  void initState() {
    super.initState();
    _scores = List<int>.filled(_fields.length, 0);
  }

  int get _total => _scores.fold(0, (a, b) => a + b);
  double get _pct => _total / 200;

  @override
  Widget build(BuildContext context) {
    return GreenHeaderScaffold(
      title: 'إدخال الدرجات',
      headerExtra: AppCard(
        color: Colors.white.withValues(alpha: .12),
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          ProgressRing(
            value: _pct,
            size: 64,
            strokeWidth: 7,
            color: AppColors.accentGold,
            trackColor: Colors.white.withValues(alpha: .25),
            label: '$_total',
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('أحمد محمد العتيبي',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                SizedBox(height: 3),
                Text('اختبار شهر شعبان • حلقة البقرة',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Text('$_total / 200',
              style: const TextStyle(color: AppColors.accentGold, fontWeight: FontWeight.w800)),
        ]),
      ),
      bottomNavigationBar: const DraftSubmitBar(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          AppCard(
            child: Column(
              children: List.generate(_fields.length, (i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: ScoreInputRow(
                    label: _fields[i].$1,
                    max: _fields[i].$2,
                    value: _scores[i],
                    onChanged: (v) => setState(() => _scores[i] = v),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ملاحظات المعلم', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                TextField(
                  maxLines: 3,
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
}
