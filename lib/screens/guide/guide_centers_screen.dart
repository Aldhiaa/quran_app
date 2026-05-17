import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/guide_provider.dart';
import '../../widgets/common_widgets.dart';

class GuideCentersScreen extends StatefulWidget {
  const GuideCentersScreen({super.key});
  @override
  State<GuideCentersScreen> createState() => _GuideCentersScreenState();
}

class _GuideCentersScreenState extends State<GuideCentersScreen> {
  int _filter = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<GuideProvider>().loadCenters();
    });
  }

  @override
  Widget build(BuildContext context) {
    final guide = context.watch<GuideProvider>();

    final filtered = guide.centers.where((c) {
      if (_filter == 0) return true;
      final score = (c['circles_count'] ?? 0) / 10.0;
      if (_filter == 1) return score >= 0.8;
      if (_filter == 2) return score >= 0.5 && score < 0.8;
      return score < 0.5;
    }).toList();

    return GreenHeaderScaffold(
      title: 'المراكز المشرف عليها',
      showBack: false,
      headerExtra: SearchFilterBar(hint: 'بحث عن مركز', onChanged: (_) {}),
      child: guide.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              children: [
                FilterChipsBar(
                  items: const ['الكل', 'متفوقة', 'متابعة', 'بحاجة دعم'],
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
                  const AppEmptyState(title: 'لا توجد مراكز')
                else
                  ...filtered.map((c) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: AppCard(
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/guide/center-detail',
                            arguments: c['id'],
                          ),
                          child: Row(children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: .12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(Icons.business_rounded, color: AppColors.primary),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${c['name'] ?? ''}',
                                      style: const TextStyle(fontWeight: FontWeight.w800)),
                                  const SizedBox(height: 3),
                                  Text('${(c['branch'] as Map<String, dynamic>?)?['name'] ?? c['address'] ?? ''}',
                                      style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                                  const SizedBox(height: 6),
                                  Row(children: [
                                    const Icon(Icons.menu_book_rounded, size: 13, color: AppColors.muted),
                                    const SizedBox(width: 3),
                                    Text('${c['circles_count'] ?? 0} حلقة',
                                        style: const TextStyle(color: AppColors.muted, fontSize: 11.5)),
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
