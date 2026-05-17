import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/supervisor_provider.dart';
import '../../widgets/common_widgets.dart';

class SupervisorAttendanceAlertsScreen extends StatefulWidget {
  const SupervisorAttendanceAlertsScreen({super.key});
  @override
  State<SupervisorAttendanceAlertsScreen> createState() => _SupervisorAttendanceAlertsScreenState();
}

class _SupervisorAttendanceAlertsScreenState extends State<SupervisorAttendanceAlertsScreen> {
  int _filter = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<SupervisorProvider>().loadAttendanceAlerts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sup = context.watch<SupervisorProvider>();
    final alerts = sup.attendanceAlerts;

    final criticalCount = alerts.where((a) => a['alert_level'] == 'critical').length;
    final warningCount = alerts.where((a) => a['alert_level'] == 'warning').length;

    return GreenHeaderScaffold(
      title: 'تنبيهات الحضور',
      headerExtra: AppCard(
        color: Colors.white.withValues(alpha: .12),
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          Expanded(child: _Stat(label: 'حرج', value: '$criticalCount', color: AppColors.danger, icon: Icons.report_problem_rounded)),
          const SizedBox(width: 8),
          Expanded(child: _Stat(label: 'تنبيهات', value: '$warningCount', color: AppColors.warning, icon: Icons.warning_amber_rounded)),
          const SizedBox(width: 8),
          Expanded(child: _Stat(label: 'حلقات', value: '${alerts.length}', color: AppColors.info, icon: Icons.menu_book_rounded)),
        ]),
      ),
      child: sup.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
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
                              color: a['alert_level'] == 'critical' ? AppColors.danger : AppColors.warning,
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
                                    child: Text('${a['circle_name'] ?? ''}',
                                        style: const TextStyle(fontWeight: FontWeight.w800)),
                                  ),
                                  StatusBadge(
                                    text: a['alert_level'] == 'critical' ? 'حرج' : 'تنبيه',
                                    kind: a['alert_level'] == 'critical' ? BadgeKind.danger : BadgeKind.warning,
                                  ),
                                ]),
                                const SizedBox(height: 4),
                                Text('المعلم: ${a['teacher'] ?? ''}',
                                    style: TextStyle(
                                        color: a['alert_level'] == 'critical' ? AppColors.danger : AppColors.warning,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12.5)),
                                const SizedBox(height: 2),
                                Text('نسبة الحضور: ${a['attendance_rate']}%',
                                    style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                                const SizedBox(height: 8),
                                Row(children: [
                                  OutlinedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.visibility_rounded, size: 16),
                                    label: const Text('عرض'),
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
