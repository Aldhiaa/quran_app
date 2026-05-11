import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class SupervisorTasksScreen extends StatefulWidget {
  const SupervisorTasksScreen({super.key});
  @override
  State<SupervisorTasksScreen> createState() => _SupervisorTasksScreenState();
}

class _SupervisorTasksScreenState extends State<SupervisorTasksScreen> {
  int _filter = 0;

  @override
  Widget build(BuildContext context) {
    final tasks = [
      _T('متابعة حالة فيصل الزهراني', 'موعد التنفيذ: اليوم', Icons.priority_high_rounded, BadgeKind.danger, 'عاجل', false),
      _T('اجتماع مع معلمي مركز النور', 'موعد التنفيذ: غداً 11 ص', Icons.event_rounded, BadgeKind.warning, 'مجدول', false),
      _T('اعتماد تقارير الأسبوع', 'بانتظار 5 تقارير', Icons.verified_rounded, BadgeKind.info, 'بانتظار', false),
      _T('متابعة طلب مركز الهداية', 'إجابة على طلب الإمداد', Icons.mail_outline_rounded, BadgeKind.success, 'مكتمل', true),
    ];

    return GreenHeaderScaffold(
      title: 'متابعة المهام',
      headerExtra: SearchFilterBar(hint: 'بحث في المهام', onChanged: (_) {}),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          FilterChipsBar(
            items: const ['الكل', 'عاجلة', 'مجدولة', 'مكتملة'],
            selected: _filter,
            onChanged: (i) => setState(() => _filter = i),
          ),
          const SizedBox(height: 12),
          ...tasks.map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  child: Row(children: [
                    Container(
                      width: 8,
                      height: 60,
                      decoration: BoxDecoration(
                          color: badgeColor(t.kind), borderRadius: BorderRadius.circular(4)),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: badgeColor(t.kind).withValues(alpha: .14),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Icon(t.icon, color: badgeColor(t.kind)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              decoration: t.done ? TextDecoration.lineThrough : null,
                              color: t.done ? AppColors.muted : AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(t.detail,
                              style:
                                  const TextStyle(color: AppColors.muted, fontSize: 12.5)),
                        ],
                      ),
                    ),
                    StatusBadge(text: t.status, kind: t.kind),
                  ]),
                ),
              )),
        ],
      ),
    );
  }
}

class _T {
  final String title;
  final String detail;
  final IconData icon;
  final BadgeKind kind;
  final String status;
  final bool done;
  const _T(this.title, this.detail, this.icon, this.kind, this.status, this.done);
}
