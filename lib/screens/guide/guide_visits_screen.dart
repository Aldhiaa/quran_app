import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/guide_provider.dart';
import '../../widgets/common_widgets.dart';

class GuideVisitsScreen extends StatefulWidget {
  const GuideVisitsScreen({super.key});
  @override
  State<GuideVisitsScreen> createState() => _GuideVisitsScreenState();
}

class _GuideVisitsScreenState extends State<GuideVisitsScreen> {
  int _filter = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<GuideProvider>().loadVisits();
    });
  }

  @override
  Widget build(BuildContext context) {
    final guide = context.watch<GuideProvider>();

    final filtered = guide.visits.where((v) {
      final status = (v['status'] as dynamic)?.toString() ?? '';
      if (_filter == 0) return true;
      if (_filter == 1) return status.contains('scheduled') || status.contains('draft');
      if (_filter == 2) return status.contains('surprise') || status.contains('submitted');
      if (_filter == 3) return status.contains('approved');
      return true;
    }).toList();

    return GreenHeaderScaffold(
      title: 'جدول الزيارات',
      showBack: false,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () => Navigator.pushNamed(context, '/guide/visits/create'),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('زيارة جديدة',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
      ),
      child: guide.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              children: [
                FilterChipsBar(
                  items: const ['الكل', 'مجدولة', 'مفاجئة', 'مكتملة'],
                  selected: _filter,
                  onChanged: (i) => setState(() => _filter = i),
                ),
                const SizedBox(height: 12),
                if (guide.error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AppErrorState(message: guide.error!),
                  ),
                if (filtered.isEmpty && !guide.isLoading)
                  const AppEmptyState(title: 'لا توجد زيارات')
                else
                  ...filtered.map((v) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: AppCard(
                          onTap: () {
                            final vId = v['id'];
                            if (vId != null) {
                              Navigator.pushNamed(
                                context,
                                '/guide/visits/create',
                                arguments: vId,
                              );
                            }
                          },
                          child: Row(children: [
                            Container(
                              width: 64,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: .08),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  const Icon(Icons.access_time_rounded,
                                      color: AppColors.primary, size: 18),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${v['start_time'] ?? v['visit_date'] ?? ''}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primary,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${v['center']['name'] ?? v['center_name'] ?? ''}',
                                      style: const TextStyle(fontWeight: FontWeight.w800)),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${v['visit_type'] ?? ''} • ${v['circle']['name'] ?? v['circle_name'] ?? ''}',
                                    style: const TextStyle(color: AppColors.muted, fontSize: 12.5),
                                  ),
                                ],
                              ),
                            ),
                            StatusBadge(
                              text: _visitStatusLabel(v),
                              kind: _visitStatusKind(v),
                            ),
                          ]),
                        ),
                      )),
              ],
            ),
    );
  }

  String _visitStatusLabel(Map<String, dynamic> v) {
    final status = (v['status'] as dynamic)?.toString() ?? '';
    if (status.contains('approved')) return 'مكتملة';
    if (status.contains('submitted')) return 'بمراجعة';
    if (status.contains('draft')) return 'مسودة';
    return 'مجدولة';
  }

  BadgeKind _visitStatusKind(Map<String, dynamic> v) {
    final status = (v['status'] as dynamic)?.toString() ?? '';
    if (status.contains('approved')) return BadgeKind.success;
    if (status.contains('submitted')) return BadgeKind.warning;
    return BadgeKind.info;
  }
}
