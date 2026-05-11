import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class GuideSupervisorsScreen extends StatefulWidget {
  const GuideSupervisorsScreen({super.key});
  @override
  State<GuideSupervisorsScreen> createState() => _GuideSupervisorsScreenState();
}

class _GuideSupervisorsScreenState extends State<GuideSupervisorsScreen> {
  int _filter = 0;

  @override
  Widget build(BuildContext context) {
    final sups = [
      _S('أ. منى السبيعي', 'مركز الإيمان', .93, BadgeKind.success, 'متفوقة'),
      _S('أ. هند العتيبي', 'مركز التقوى', .82, BadgeKind.success, 'متفوقة'),
      _S('أ. سارة المالكي', 'مركز الرشاد', .65, BadgeKind.warning, 'يحتاج متابعة'),
      _S('أ. أمل القحطاني', 'مركز السلام', .87, BadgeKind.success, 'متفوقة'),
      _S('أ. ريم الزهراني', 'مركز الصدق', .52, BadgeKind.danger, 'تدخل عاجل'),
    ];

    return GreenHeaderScaffold(
      title: 'متابعة المشرفات',
      headerExtra: SearchFilterBar(hint: 'بحث عن مشرفة', onChanged: (_) {}),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          FilterChipsBar(
            items: const ['الكل', 'متفوقات', 'متابعة', 'تدخل عاجل'],
            selected: _filter,
            onChanged: (i) => setState(() => _filter = i),
          ),
          const SizedBox(height: 12),
          ...sups.map((s) => Padding(
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
                          child: const Icon(Icons.person_2_rounded, color: AppColors.primary),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                              const SizedBox(height: 3),
                              Text(s.center,
                                  style: const TextStyle(color: AppColors.muted, fontSize: 12.5)),
                            ],
                          ),
                        ),
                        StatusBadge(text: s.status, kind: s.kind),
                      ]),
                      const SizedBox(height: 10),
                      Row(children: [
                        const Text('الأداء',
                            style:
                                TextStyle(color: AppColors.muted, fontSize: 11.5, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: LinearProgressIndicator(value: s.score, minHeight: 6),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('${(s.score * 100).round()}٪',
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800)),
                      ]),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class _S {
  final String name;
  final String center;
  final double score;
  final BadgeKind kind;
  final String status;
  const _S(this.name, this.center, this.score, this.kind, this.status);
}
