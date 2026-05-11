import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class GuideCentersScreen extends StatefulWidget {
  const GuideCentersScreen({super.key});
  @override
  State<GuideCentersScreen> createState() => _GuideCentersScreenState();
}

class _GuideCentersScreenState extends State<GuideCentersScreen> {
  int _filter = 0;

  @override
  Widget build(BuildContext context) {
    final centers = [
      _C('مركز الإيمان', 'الرياض — حي العليا', 8, 186, .91, BadgeKind.success),
      _C('مركز التقوى', 'الرياض — حي قرطبة', 6, 134, .82, BadgeKind.success),
      _C('مركز الرشاد', 'الرياض — حي الورود', 5, 102, .68, BadgeKind.warning),
      _C('مركز السلام', 'الرياض — حي الياسمين', 7, 158, .87, BadgeKind.success),
      _C('مركز الصدق', 'الرياض — حي النخيل', 4, 78, .54, BadgeKind.warning),
      _C('مركز البيان', 'الرياض — حي الورد', 6, 142, .89, BadgeKind.success),
    ];

    return GreenHeaderScaffold(
      title: 'المراكز المشرف عليها',
      showBack: false,
      headerExtra: SearchFilterBar(hint: 'بحث عن مركز', onChanged: (_) {}),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          FilterChipsBar(
            items: const ['الكل', 'متفوقة', 'متابعة', 'بحاجة دعم'],
            selected: _filter,
            onChanged: (i) => setState(() => _filter = i),
          ),
          const SizedBox(height: 12),
          ...centers.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  child: Row(children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.business_rounded, color: AppColors.primary),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 3),
                          Text(c.address,
                              style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                          const SizedBox(height: 6),
                          Row(children: [
                            const Icon(Icons.menu_book_rounded, size: 13, color: AppColors.muted),
                            const SizedBox(width: 3),
                            Text('${c.circles} حلقة',
                                style: const TextStyle(color: AppColors.muted, fontSize: 11.5)),
                            const SizedBox(width: 10),
                            const Icon(Icons.groups_rounded, size: 13, color: AppColors.muted),
                            const SizedBox(width: 3),
                            Text('${c.students} طالبة',
                                style: const TextStyle(color: AppColors.muted, fontSize: 11.5)),
                          ]),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        ProgressRing(value: c.score, size: 44, strokeWidth: 5),
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

class _C {
  final String name;
  final String address;
  final int circles;
  final int students;
  final double score;
  final BadgeKind kind;
  const _C(this.name, this.address, this.circles, this.students, this.score, this.kind);
}
