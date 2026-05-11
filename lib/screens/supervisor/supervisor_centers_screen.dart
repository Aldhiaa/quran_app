import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class SupervisorCentersScreen extends StatefulWidget {
  const SupervisorCentersScreen({super.key});
  @override
  State<SupervisorCentersScreen> createState() => _SupervisorCentersScreenState();
}

class _SupervisorCentersScreenState extends State<SupervisorCentersScreen> {
  int _filter = 0;

  @override
  Widget build(BuildContext context) {
    final centers = [
      _C('مركز النور', 'الرياض — حي السلام', 6, 142, .89, BadgeKind.success),
      _C('مركز الفرقان', 'الرياض — حي النخيل', 4, 96, .78, BadgeKind.success),
      _C('مركز الهداية', 'الرياض — حي الياسمين', 3, 64, .55, BadgeKind.warning),
      _C('مركز البيان', 'الرياض — حي العقيق', 5, 118, .82, BadgeKind.success),
    ];

    return GreenHeaderScaffold(
      title: 'مراكزي',
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
                  onTap: () => Navigator.pushNamed(context, '/supervisor/centers'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
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
                                  style: const TextStyle(color: AppColors.muted, fontSize: 12.5)),
                            ],
                          ),
                        ),
                        StatusBadge(text: '${(c.attendance * 100).round()}٪', kind: c.kind),
                      ]),
                      const SizedBox(height: 12),
                      Row(children: [
                        Expanded(
                          child: _Metric(
                              label: 'حلقات', value: '${c.circles}', icon: Icons.menu_book_rounded),
                        ),
                        Expanded(
                          child: _Metric(
                              label: 'طلاب', value: '${c.students}', icon: Icons.groups_rounded),
                        ),
                        Expanded(
                          child: _Metric(
                              label: 'الحضور',
                              value: '${(c.attendance * 100).round()}٪',
                              icon: Icons.check_circle_rounded),
                        ),
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

class _C {
  final String name;
  final String address;
  final int circles;
  final int students;
  final double attendance;
  final BadgeKind kind;
  const _C(this.name, this.address, this.circles, this.students, this.attendance, this.kind);
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _Metric({required this.label, required this.value, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 18),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
        Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 11.5)),
      ],
    );
  }
}
