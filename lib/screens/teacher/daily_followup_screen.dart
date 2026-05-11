import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class DailyFollowupScreen extends StatelessWidget {
  const DailyFollowupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = [
      _F('أحمد العتيبي', 'البقرة 1-20', 'حاضر', BadgeKind.success, .95),
      _F('عبدالله القحطاني', 'البقرة 21-40', 'حاضر', BadgeKind.success, .80),
      _F('محمد الدوسري', 'آل عمران 1-15', 'متأخر', BadgeKind.warning, .50),
      _F('سعد الشهري', 'النساء 1-25', 'حاضر', BadgeKind.success, .85),
      _F('فيصل الزهراني', 'لم يحفظ', 'غائب', BadgeKind.danger, .00),
    ];

    return GreenHeaderScaffold(
      title: 'دفتر المتابعة',
      headerExtra: const _HeaderRow(),
      bottomNavigationBar: const DraftSubmitBar(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(children: [
              const Icon(Icons.calendar_month_rounded, color: AppColors.primary),
              const SizedBox(width: 8),
              const Text('السبت — 1446/11/05',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              const Spacer(),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit_rounded, size: 16),
                label: const Text('تغيير'),
              ),
            ]),
          ),
          const SizedBox(height: 10),
          ...entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _StudentRowCard(entry: e),
              )),
        ],
      ),
    );
  }
}

class _F {
  final String name;
  final String range;
  final String status;
  final BadgeKind kind;
  final double quality;
  const _F(this.name, this.range, this.status, this.kind, this.quality);
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: _Pill(icon: Icons.menu_book_rounded, text: 'حلقة البقرة'),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: _Pill(icon: Icons.groups_rounded, text: '24 طالب'),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: _Pill(icon: Icons.access_time_rounded, text: '4:30 — 6:00'),
      ),
    ]);
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Pill({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: .25)),
      ),
      child: Row(children: [
        Icon(icon, color: AppColors.accentGold, size: 16),
        const SizedBox(width: 6),
        Expanded(
          child: Text(text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
        ),
      ]),
    );
  }
}

class _StudentRowCard extends StatelessWidget {
  final _F entry;
  const _StudentRowCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => Navigator.pushNamed(context, '/teacher/student-detail'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.accentGold.withValues(alpha: .18),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.person_rounded, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text(entry.range, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                ],
              ),
            ),
            StatusBadge(text: entry.status, kind: entry.kind),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            const Text('جودة الحفظ',
                style: TextStyle(color: AppColors.muted, fontSize: 11.5, fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: LinearProgressIndicator(value: entry.quality, minHeight: 6),
              ),
            ),
            const SizedBox(width: 8),
            Text('${(entry.quality * 100).round()}٪',
                style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary)),
          ]),
        ],
      ),
    );
  }
}
