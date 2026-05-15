import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/guide_provider.dart';
import '../../widgets/common_widgets.dart';

class GuidePlansReviewScreen extends StatefulWidget {
  const GuidePlansReviewScreen({super.key});
  @override
  State<GuidePlansReviewScreen> createState() => _GuidePlansReviewScreenState();
}

class _GuidePlansReviewScreenState extends State<GuidePlansReviewScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<GuideProvider>().loadMonthlyPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    final guide = context.watch<GuideProvider>();

    return GreenHeaderScaffold(
      title: 'مراجعة الخطط',
      headerExtra: SearchFilterBar(hint: 'بحث', onChanged: (_) {}),
      child: guide.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              itemCount: guide.monthlyPlans.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final p = guide.monthlyPlans[i];
                final status = '${p['status'] ?? ''}';
                return EntityListCard(
                  leading: Icons.menu_book_rounded,
                  title: '${p['circle']['name'] ?? ''}',
                  subtitle: '${p['teacher']['full_name'] ?? p['teacher']['name'] ?? ''}',
                  badgeText: _planStatusLabel(status),
                  badgeKind: _planStatusKind(status),
                  onTap: () {
                    final pId = p['id'];
                    if (pId != null) {
                      Navigator.pushNamed(
                        context,
                        '/guide/monthly-tests',
                        arguments: pId,
                      );
                    }
                  },
                );
              },
            ),
    );
  }

  String _planStatusLabel(String s) {
    if (s.contains('approved')) return 'معتمدة';
    if (s.contains('returned')) return 'مرتجعة';
    if (s.contains('submitted')) return 'بمراجعة';
    return 'مسودة';
  }

  BadgeKind _planStatusKind(String s) {
    if (s.contains('approved')) return BadgeKind.success;
    if (s.contains('returned')) return BadgeKind.danger;
    if (s.contains('submitted')) return BadgeKind.warning;
    return BadgeKind.info;
  }
}
