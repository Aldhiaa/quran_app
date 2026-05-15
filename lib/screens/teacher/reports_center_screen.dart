import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_theme.dart';
import '../../providers/teacher_provider.dart';
import '../../widgets/common_widgets.dart';

class ReportsCenterScreen extends StatefulWidget {
  const ReportsCenterScreen({super.key});

  @override
  State<ReportsCenterScreen> createState() => _ReportsCenterScreenState();
}

class _ReportsCenterScreenState extends State<ReportsCenterScreen> {
  int _filter = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<TeacherProvider>().loadHome();
    });
  }

  @override
  Widget build(BuildContext context) {
    final teacher = context.watch<TeacherProvider>();
    final pending = teacher.pendingActions;

    final pendingReports = pending['missing_daily_reports'] ?? pending['pending_reports'] ?? 0;
    final pendingReview = pending['pending_review'] ?? 0;
    final approved = pending['approved_reports'] ?? 38;
    final returned = pending['returned_reports'] ?? 0;

    // Build report list based on filter
    final reports = _buildReports(pendingReports, pendingReview, approved, returned);

    return GreenHeaderScaffold(
      title: 'مركز التقارير',
      headerExtra: SearchFilterBar(hint: 'بحث عن تقرير', onChanged: (_) {}),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          FilterChipsBar(
            items: const ['الكل', 'يومية', 'أسبوعية', 'شهرية', 'مُعتمدة'],
            selected: _filter,
            onChanged: (i) => setState(() => _filter = i),
          ),
          const SizedBox(height: 12),

          // KPI summary
          KpiGrid(items: [
            KpiCard(
              label: 'تقارير اليوم',
              value: '$pendingReports',
              icon: Icons.description_rounded,
              color: AppColors.primary,
            ),
            KpiCard(
              label: 'قيد المراجعة',
              value: '$pendingReview',
              icon: Icons.pending_actions_rounded,
              color: AppColors.warning,
            ),
            KpiCard(
              label: 'معتمدة',
              value: '$approved',
              icon: Icons.check_circle_rounded,
              color: AppColors.success,
            ),
            KpiCard(
              label: 'مُرجعة',
              value: '$returned',
              icon: Icons.undo_rounded,
              color: AppColors.danger,
            ),
          ]),
          const SizedBox(height: 14),

          // Report list
          if (reports.isEmpty)
            const AppCard(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(children: [
                  Icon(Icons.description_rounded, size: 48, color: AppColors.muted),
                  SizedBox(height: 12),
                  Text('لا توجد تقارير',
                      style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.muted)),
                ]),
              ),
            )
          else
            ...reports.map((r) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ReportCard(
                    title: r['title'] as String,
                    subtitle: r['subtitle'] as String,
                    statusText: r['statusText'] as String,
                    badgeKind: r['badgeKind'] as BadgeKind,
                    icon: r['icon'] as IconData,
                    onTap: () {},
                  ),
                )),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _buildReports(
      dynamic pendingReports, dynamic pendingReview, dynamic approved, dynamic returned) {
    final allReports = <Map<String, dynamic>>[
      {
        'title': 'تقرير متابعة يومي',
        'subtitle': 'الأحد 1446/11/06',
        'statusText': 'مُعتمد',
        'badgeKind': BadgeKind.success,
        'icon': Icons.description_rounded,
      },
      {
        'title': 'التقييم الأسبوعي',
        'subtitle': 'الأسبوع الثالث — شعبان',
        'statusText': 'قيد المراجعة',
        'badgeKind': BadgeKind.warning,
        'icon': Icons.fact_check_rounded,
      },
      {
        'title': 'تقرير متابعة يومي',
        'subtitle': 'السبت 1446/11/05',
        'statusText': 'مُرجَع',
        'badgeKind': BadgeKind.danger,
        'icon': Icons.description_rounded,
      },
      {
        'title': 'اختبار شهر شعبان',
        'subtitle': 'الخميس 1446/11/02',
        'statusText': 'مسودة',
        'badgeKind': BadgeKind.info,
        'icon': Icons.assignment_rounded,
      },
    ];

    if (_filter == 1) {
      return allReports.where((r) => r['title'].toString().contains('يومي')).toList();
    } else if (_filter == 2) {
      return allReports.where((r) => r['title'].toString().contains('أسبوعي')).toList();
    } else if (_filter == 3) {
      return allReports.where((r) => r['title'].toString().contains('شهر')).toList();
    } else if (_filter == 4) {
      return allReports.where((r) => r['statusText'] == 'مُعتمد').toList();
    }

    return allReports;
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String statusText;
  final BadgeKind badgeKind;
  final IconData icon;
  final VoidCallback onTap;

  const _ReportCard({
    required this.title,
    required this.subtitle,
    required this.statusText,
    required this.badgeKind,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(children: [
        Icon(icon, color: AppColors.primary, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
            ],
          ),
        ),
        StatusBadge(text: statusText, kind: badgeKind),
      ]),
    );
  }
}
