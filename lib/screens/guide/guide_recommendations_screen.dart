import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/guide_provider.dart';
import '../../widgets/common_widgets.dart';

class GuideRecommendationsScreen extends StatefulWidget {
  const GuideRecommendationsScreen({super.key});
  @override
  State<GuideRecommendationsScreen> createState() =>
      _GuideRecommendationsScreenState();
}

class _GuideRecommendationsScreenState extends State<GuideRecommendationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<GuideProvider>().loadRecommendations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final guide = context.watch<GuideProvider>();

    return GreenHeaderScaffold(
      title: 'التوصيات',
      headerExtra: SearchFilterBar(hint: 'بحث', onChanged: (_) {}),
      child: guide.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              itemCount: guide.recommendations.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final r = guide.recommendations[i];
                final status = '${r['status'] ?? ''}';
                return EntityListCard(
                  leading: Icons.task_alt_rounded,
                  leadingColor: _statusColor(status),
                  title: '${r['recommendations'] ?? 'توصية'}',
                  subtitle:
                      '${r['circle_name'] ?? ''} — ${r['visit_date'] ?? ''}',
                  badgeText: _statusLabel(status),
                  badgeKind: _statusKind(status),
                );
              },
            ),
    );
  }

  Color _statusColor(String s) {
    if (s.contains('approved')) return AppColors.success;
    if (s.contains('submitted')) return AppColors.warning;
    return AppColors.info;
  }

  String _statusLabel(String s) {
    if (s.contains('approved')) return 'منفذة';
    if (s.contains('submitted')) return 'قيد المتابعة';
    return 'مسودة';
  }

  BadgeKind _statusKind(String s) {
    if (s.contains('approved')) return BadgeKind.success;
    if (s.contains('submitted')) return BadgeKind.warning;
    return BadgeKind.info;
  }
}
