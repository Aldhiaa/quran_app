import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/guide_provider.dart';
import '../../widgets/common_widgets.dart';

class GuideTrainingNeedsScreen extends StatefulWidget {
  const GuideTrainingNeedsScreen({super.key});
  @override
  State<GuideTrainingNeedsScreen> createState() =>
      _GuideTrainingNeedsScreenState();
}

class _GuideTrainingNeedsScreenState extends State<GuideTrainingNeedsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<GuideProvider>().loadTrainingNeeds();
    });
  }

  @override
  Widget build(BuildContext context) {
    final guide = context.watch<GuideProvider>();

    final openCount =
        guide.trainingNeeds.where((n) => '${n['status'] ?? ''}' == 'open').length;
    final highCount = guide.trainingNeeds
        .where((n) => '${n['priority'] ?? ''}' == 'high')
        .length;

    return GreenHeaderScaffold(
      title: 'الاحتياجات التدريبية',
      headerExtra: AppCard(
        color: Colors.white.withValues(alpha: .12),
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          Expanded(
            child: _Stat(
              label: 'احتياجات',
              value: '${guide.trainingNeeds.length}',
              color: AppColors.accentGold,
              icon: Icons.psychology_alt_rounded,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _Stat(
              label: 'عاجلة',
              value: '$highCount',
              color: AppColors.danger,
              icon: Icons.priority_high_rounded,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _Stat(
              label: 'مفتوحة',
              value: '$openCount',
              color: AppColors.success,
              icon: Icons.task_alt_rounded,
            ),
          ),
        ]),
      ),
      child: guide.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              itemCount: guide.trainingNeeds.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final n = guide.trainingNeeds[i];
                final priority = '${n['priority'] ?? 'medium'}';
                return EntityListCard(
                  leading: Icons.psychology_alt_rounded,
                  leadingColor: _priorityColor(priority),
                  title: '${n['title'] ?? ''}',
                  subtitle: '${n['circle']['name'] ?? ''}',
                  badgeText: _priorityLabel(priority),
                  badgeKind: _priorityKind(priority),
                );
              },
            ),
    );
  }

  Color _priorityColor(String p) {
    switch (p) {
      case 'high':
        return AppColors.danger;
      case 'medium':
        return AppColors.warning;
      default:
        return AppColors.info;
    }
  }

  String _priorityLabel(String p) {
    switch (p) {
      case 'high':
        return 'عاجل';
      case 'medium':
        return 'متوسط';
      default:
        return 'عادي';
    }
  }

  BadgeKind _priorityKind(String p) {
    switch (p) {
      case 'high':
        return BadgeKind.danger;
      case 'medium':
        return BadgeKind.warning;
      default:
        return BadgeKind.info;
    }
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  const _Stat(
      {required this.label,
      required this.value,
      required this.color,
      required this.icon});

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
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16)),
          Text(label,
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
