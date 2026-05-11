import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});
  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  int _filter = 0;

  @override
  Widget build(BuildContext context) {
    final students = [
      _S('أحمد محمد العتيبي', 'حلقة البقرة • الجزء 5', .92, BadgeKind.success, 'متفوق'),
      _S('عبدالله سعد القحطاني', 'حلقة البقرة • الجزء 3', .78, BadgeKind.success, 'جيد'),
      _S('محمد فهد الدوسري', 'حلقة آل عمران • الجزء 2', .45, BadgeKind.warning, 'متابعة'),
      _S('سعد ناصر الشهري', 'حلقة آل عمران • الجزء 4', .85, BadgeKind.success, 'جيد'),
      _S('فيصل أحمد الزهراني', 'حلقة النساء • الجزء 1', .30, BadgeKind.danger, 'ضعيف'),
    ];

    return GreenHeaderScaffold(
      title: 'طلابي',
      showBack: false,
      headerExtra: SearchFilterBar(hint: 'بحث عن طالب', onChanged: (_) {}),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          FilterChipsBar(
            items: const ['الكل', 'متفوقون', 'متابعة', 'ضعاف'],
            selected: _filter,
            onChanged: (i) => setState(() => _filter = i),
          ),
          const SizedBox(height: 12),
          ...students.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  onTap: () => Navigator.pushNamed(context, '/teacher/student-detail'),
                  child: Row(children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.accentGold.withValues(alpha: .2),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.accentGold, width: 1.2),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.person_rounded, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 3),
                          Text(s.sub, style: const TextStyle(color: AppColors.muted, fontSize: 12.5)),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: LinearProgressIndicator(value: s.progress, minHeight: 5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        StatusBadge(text: s.status, kind: s.kind),
                        const SizedBox(height: 8),
                        Text('${(s.progress * 100).round()}٪',
                            style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary)),
                      ],
                    ),
                  ]),
                ),
              )),
        ],
      ),
    );
  }
}

class _S {
  final String name;
  final String sub;
  final double progress;
  final BadgeKind kind;
  final String status;
  const _S(this.name, this.sub, this.progress, this.kind, this.status);
}
