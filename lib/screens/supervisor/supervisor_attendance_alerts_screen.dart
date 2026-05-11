import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class SupervisorAttendanceAlertsScreen extends StatefulWidget {
  const SupervisorAttendanceAlertsScreen({super.key});
  @override
  State<SupervisorAttendanceAlertsScreen> createState() => _SupervisorAttendanceAlertsScreenState();
}

class _SupervisorAttendanceAlertsScreenState extends State<SupervisorAttendanceAlertsScreen> {
  int _filter = 0;

  @override
  Widget build(BuildContext context) {
    final alerts = [
      _A('فيصل الزهراني', '7 أيام متتالية', 'مركز النور — حلقة البقرة', BadgeKind.danger, 'حرج'),
      _A('سعد الشهري', '3 أيام متتالية', 'مركز النور — حلقة آل عمران', BadgeKind.warning, 'تنبيه'),
      _A('محمد الدوسري', 'حضور ٪40 خلال الشهر', 'مركز الفرقان — حلقة النساء', BadgeKind.warning, 'متابعة'),
      _A('عبدالله القحطاني', '2 أيام متتالية', 'مركز النور — حلقة آل عمران', BadgeKind.neutral, 'مراقبة'),
    ];

    return GreenHeaderScaffold(
      title: 'تنبيهات الحضور',
      headerExtra: AppCard(
        color: Colors.white.withValues(alpha: .12),
        padding: const EdgeInsets.all(12),
        child: Row(children: const [
          Expanded(child: _Stat(label: 'حرج', value: '1', color: AppColors.danger, icon: Icons.report_problem_rounded)),
          SizedBox(width: 8),
          Expanded(child: _Stat(label: 'تنبيهات', value: '3', color: AppColors.warning, icon: Icons.warning_amber_rounded)),
          SizedBox(width: 8),
          Expanded(child: _Stat(label: 'مهام مفتوحة', value: '7', color: AppColors.info, icon: Icons.task_alt_rounded)),
        ]),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          FilterChipsBar(
            items: const ['الكل', 'حرج', 'تنبيه', 'متابعة'],
            selected: _filter,
            onChanged: (i) => setState(() => _filter = i),
          ),
          const SizedBox(height: 12),
          ...alerts.map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  child: Row(children: [
                    Container(
                      width: 8,
                      height: 64,
                      decoration: BoxDecoration(
                        color: badgeColor(a.kind),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Expanded(
                              child: Text(a.name,
                                  style: const TextStyle(fontWeight: FontWeight.w800)),
                            ),
                            StatusBadge(text: a.status, kind: a.kind),
                          ]),
                          const SizedBox(height: 4),
                          Text(a.reason,
                              style: TextStyle(
                                  color: StatusBadge._color(a.kind), fontWeight: FontWeight.w700, fontSize: 12.5)),
                          const SizedBox(height: 2),
                          Text(a.where, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                          const SizedBox(height: 8),
                          Row(children: [
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.phone_rounded, size: 16),
                              label: const Text('اتصال'),
                              style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(0, 36),
                                  padding: const EdgeInsets.symmetric(horizontal: 10)),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.task_alt_rounded, size: 16, color: Colors.white),
                              label: const Text('إنشاء مهمة'),
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(0, 36),
                                  padding: const EdgeInsets.symmetric(horizontal: 12)),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ]),
                ),
              )),
        ],
      ),
    );
  }
}

class _A {
  final String name;
  final String reason;
  final String where;
  final BadgeKind kind;
  final String status;
  const _A(this.name, this.reason, this.where, this.kind, this.status);
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  const _Stat({required this.label, required this.value, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: .2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 11.5, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
