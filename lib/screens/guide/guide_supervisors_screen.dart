import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/guide_provider.dart';
import '../../widgets/common_widgets.dart';

class GuideSupervisorsScreen extends StatefulWidget {
  const GuideSupervisorsScreen({super.key});
  @override
  State<GuideSupervisorsScreen> createState() => _GuideSupervisorsScreenState();
}

class _GuideSupervisorsScreenState extends State<GuideSupervisorsScreen> {
  int _filter = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<GuideProvider>().loadSupervisors();
    });
  }

  @override
  Widget build(BuildContext context) {
    final guide = context.watch<GuideProvider>();

    final filtered = guide.supervisors.where((s) {
      if (_filter == 0) return true;
      if (_filter == 1) return s['latest_visit_date'] != null;
      if (_filter == 2) return s['latest_visit_date'] == null;
      return true;
    }).toList();

    return GreenHeaderScaffold(
      title: 'متابعة المشرفات',
      headerExtra: SearchFilterBar(hint: 'بحث عن مشرفة', onChanged: (_) {}),
      child: guide.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              children: [
                FilterChipsBar(
                  items: const ['الكل', 'تمت الزيارة', 'لم تزر بعد'],
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
                  const AppEmptyState(message: 'لا توجد مشرفات')
                else
                  ...filtered.map((s) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color: AppColors.accentGold.withValues(alpha: .18),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.accentGold, width: 1.2),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.person_2_rounded, color: AppColors.primary),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${s['name'] ?? ''}',
                                          style: const TextStyle(fontWeight: FontWeight.w800)),
                                      const SizedBox(height: 3),
                                      if (s['centers'] is List)
                                        Text(
                                          (s['centers'] as List)
                                              .map((c) => c['name'] ?? '')
                                              .join('، '),
                                          style: const TextStyle(color: AppColors.muted, fontSize: 12.5),
                                        ),
                                    ],
                                  ),
                                ),
                                StatusBadge(
                                  text: s['latest_visit_date'] != null ? 'تمت الزيارة' : 'بانتظار',
                                  kind: s['latest_visit_date'] != null ? BadgeKind.success : BadgeKind.warning,
                                ),
                              ]),
                              if (s['latest_visit_date'] != null) ...[
                                const SizedBox(height: 8),
                                Row(children: [
                                  const Icon(Icons.event_rounded, size: 14, color: AppColors.muted),
                                  const SizedBox(width: 4),
                                  Text('آخر زيارة: ${s['latest_visit_date']}',
                                      style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                                ]),
                              ],
                            ],
                          ),
                        ),
                      )),
              ],
            ),
    );
  }
}
