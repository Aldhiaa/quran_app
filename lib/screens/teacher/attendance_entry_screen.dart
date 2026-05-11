import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class AttendanceEntryScreen extends StatefulWidget {
  const AttendanceEntryScreen({super.key});
  @override
  State<AttendanceEntryScreen> createState() => _AttendanceEntryScreenState();
}

class _AttendanceEntryScreenState extends State<AttendanceEntryScreen> {
  static const _names = [
    'أحمد محمد العتيبي',
    'عبدالله سعد القحطاني',
    'محمد فهد الدوسري',
    'سعد ناصر الشهري',
    'فيصل أحمد الزهراني',
    'يوسف خالد المالكي',
    'إبراهيم علي البقمي',
  ];
  late List<int> _status; // 0 present, 1 late, 2 excused, 3 absent

  @override
  void initState() {
    super.initState();
    _status = List<int>.filled(_names.length, 0);
  }

  int get _count =>
      _status.where((s) => s == 0).length + _status.where((s) => s == 1).length;

  @override
  Widget build(BuildContext context) {
    return GreenHeaderScaffold(
      title: 'تسجيل الحضور',
      headerExtra: AppCard(
        color: Colors.white.withValues(alpha: .1),
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          const _Counter(label: 'حاضر', color: AppColors.success, icon: Icons.check_circle_rounded),
          const SizedBox(width: 8),
          const _Counter(label: 'متأخر', color: AppColors.warning, icon: Icons.schedule_rounded),
          const SizedBox(width: 8),
          const _Counter(label: 'مأذون', color: AppColors.info, icon: Icons.event_available_rounded),
          const SizedBox(width: 8),
          const _Counter(label: 'غائب', color: AppColors.danger, icon: Icons.cancel_rounded),
        ]),
      ),
      bottomNavigationBar: const DraftSubmitBar(submitLabel: 'حفظ الحضور'),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        itemCount: _names.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) => _StudentAttendanceCard(
          name: _names[i],
          status: _status[i],
          onChange: (v) => setState(() => _status[i] = v),
        ),
      ),
    );
  }
}

class _Counter extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  const _Counter({required this.label, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: .2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11.5)),
          ],
        ),
      ),
    );
  }
}

class _StudentAttendanceCard extends StatelessWidget {
  final String name;
  final int status;
  final ValueChanged<int> onChange;
  const _StudentAttendanceCard({required this.name, required this.status, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.accentGold.withValues(alpha: .18),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.person_rounded, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w800))),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            _opt(0, 'حاضر', AppColors.success),
            const SizedBox(width: 6),
            _opt(1, 'متأخر', AppColors.warning),
            const SizedBox(width: 6),
            _opt(2, 'مأذون', AppColors.info),
            const SizedBox(width: 6),
            _opt(3, 'غائب', AppColors.danger),
          ]),
        ],
      ),
    );
  }

  Widget _opt(int v, String label, Color c) {
    final active = status == v;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => onChange(v),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: active ? c : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: active ? c : AppColors.border),
          ),
          alignment: Alignment.center,
          child: Text(label,
              style: TextStyle(
                  color: active ? Colors.white : c,
                  fontWeight: FontWeight.w800,
                  fontSize: 12)),
        ),
      ),
    );
  }
}
