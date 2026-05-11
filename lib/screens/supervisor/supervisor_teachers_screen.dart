import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class SupervisorTeachersScreen extends StatefulWidget {
  const SupervisorTeachersScreen({super.key});
  @override
  State<SupervisorTeachersScreen> createState() => _SupervisorTeachersScreenState();
}

class _SupervisorTeachersScreenState extends State<SupervisorTeachersScreen> {
  int _filter = 0;

  @override
  Widget build(BuildContext context) {
    final teachers = [
      _T('أ. سعد القحطاني', 'مركز النور — حلقة البقرة', BadgeKind.success, 'ملتزم', .92, 24),
      _T('أ. خالد الزهراني', 'مركز النور — حلقة آل عمران', BadgeKind.success, 'ملتزم', .78, 18),
      _T('أ. فهد الدوسري', 'مركز الفرقان — حلقة النساء', BadgeKind.warning, 'يحتاج متابعة', .55, 14),
      _T('أ. أحمد المالكي', 'مركز الهداية — حلقة المائدة', BadgeKind.danger, 'مخالفات', .35, 12),
    ];

    return GreenHeaderScaffold(
      title: 'متابعة المعلمين',
      headerExtra: SearchFilterBar(hint: 'بحث عن معلم', onChanged: (_) {}),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          FilterChipsBar(
            items: const ['الكل', 'متفوقون', 'يحتاج متابعة', 'مخالفات'],
            selected: _filter,
            onChanged: (i) => setState(() => _filter = i),
          ),
          const SizedBox(height: 12),
          ...teachers.map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: AppColors.accentGold.withValues(alpha: .18),
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.accentGold, width: 1.2),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.school_rounded, color: AppColors.primary),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                              const SizedBox(height: 3),
                              Text(t.sub,
                                  style:
                                      const TextStyle(color: AppColors.muted, fontSize: 12.5)),
                            ],
                          ),
                        ),
                        StatusBadge(text: t.status, kind: t.kind),
                      ]),
                      const SizedBox(height: 10),
                      Row(children: [
                        const Icon(Icons.groups_rounded, size: 14, color: AppColors.muted),
                        const SizedBox(width: 4),
                        Text('${t.students} طالب',
                            style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                        const SizedBox(width: 12),
                        const Icon(Icons.trending_up_rounded, size: 14, color: AppColors.muted),
                        const SizedBox(width: 4),
                        Text('${(t.score * 100).round()}٪ التزام',
                            style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                        const Spacer(),
                        Icon(Icons.star_rounded, size: 14, color: AppColors.accentGold),
                      ]),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: LinearProgressIndicator(value: t.score, minHeight: 5),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class _T {
  final String name;
  final String sub;
  final BadgeKind kind;
  final String status;
  final double score;
  final int students;
  const _T(this.name, this.sub, this.kind, this.status, this.score, this.students);
}
