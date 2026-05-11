import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class HalaqatScreen extends StatefulWidget {
  const HalaqatScreen({super.key});
  @override
  State<HalaqatScreen> createState() => _HalaqatScreenState();
}

class _HalaqatScreenState extends State<HalaqatScreen> {
  int _filter = 0;

  @override
  Widget build(BuildContext context) {
    final circles = [
      _Circle('حلقة البقرة', 'صباحاً • السبت — الخميس', 24, .87, BadgeKind.success, 'نشطة'),
      _Circle('حلقة آل عمران', 'مساءً • السبت — الأربعاء', 18, .72, BadgeKind.success, 'نشطة'),
      _Circle('حلقة النساء', 'مساءً • الجمعة', 12, .35, BadgeKind.warning, 'متابعة'),
    ];

    return GreenHeaderScaffold(
      title: 'حلقاتي',
      showBack: false,
      headerExtra: SearchFilterBar(hint: 'بحث عن حلقة', onChanged: (_) {}),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          FilterChipsBar(
            items: const ['الكل', 'نشطة', 'متابعة', 'منتهية'],
            selected: _filter,
            onChanged: (i) => setState(() => _filter = i),
          ),
          const SizedBox(height: 12),
          ...circles.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _CircleListCard(circle: c),
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {},
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }
}

class _Circle {
  final String title;
  final String schedule;
  final int students;
  final double progress;
  final BadgeKind kind;
  final String status;
  const _Circle(this.title, this.schedule, this.students, this.progress, this.kind, this.status);
}

class _CircleListCard extends StatelessWidget {
  final _Circle circle;
  const _CircleListCard({required this.circle});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => Navigator.pushNamed(context, '/teacher/halaqat'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.menu_book_rounded, color: AppColors.primary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(circle.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Text(circle.schedule, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                ],
              ),
            ),
            StatusBadge(text: circle.status, kind: circle.kind),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            ProgressRing(value: circle.progress, size: 56, strokeWidth: 7),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.groups_rounded, size: 16, color: AppColors.muted),
                    const SizedBox(width: 4),
                    Text('${circle.students} طالب',
                        style: const TextStyle(color: AppColors.muted, fontSize: 12.5)),
                    const Spacer(),
                    Text('${(circle.progress * 100).round()}٪ متوسط الحفظ',
                        style: const TextStyle(
                            color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12)),
                  ]),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: LinearProgressIndicator(value: circle.progress, minHeight: 6),
                  ),
                ],
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
