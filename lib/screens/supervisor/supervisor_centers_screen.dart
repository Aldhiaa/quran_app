import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/supervisor_provider.dart';
import '../../widgets/common_widgets.dart';

class SupervisorCentersScreen extends StatefulWidget {
  const SupervisorCentersScreen({super.key});
  @override
  State<SupervisorCentersScreen> createState() => _SupervisorCentersScreenState();
}

class _SupervisorCentersScreenState extends State<SupervisorCentersScreen> {
  int _filter = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<SupervisorProvider>().loadCenters();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sup = context.watch<SupervisorProvider>();
    final centers = sup.centers;

    return GreenHeaderScaffold(
      title: 'مراكزي',
      showBack: false,
      headerExtra: SearchFilterBar(hint: 'بحث عن مركز', onChanged: (_) {}),
      child: sup.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              children: [
                if (sup.error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(sup.error!, style: const TextStyle(color: AppColors.danger)),
                  ),
                FilterChipsBar(
                  items: const ['الكل', 'متفوقة', 'متابعة', 'بحاجة دعم'],
                  selected: _filter,
                  onChanged: (i) => setState(() => _filter = i),
                ),
                const SizedBox(height: 12),
                ...centers.map((c) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: AppCard(
                        onTap: () => Navigator.pushNamed(context, '/supervisor/center-detail', arguments: c['id']),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
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
                                    Text('${c['address'] ?? ''}',
                                        style: const TextStyle(color: AppColors.muted, fontSize: 12.5)),
                                  ],
                                ),
                              ),
                              StatusBadge(text: '${c['circles_count'] ?? 0}', kind: BadgeKind.success),
                            ]),
                            const SizedBox(height: 12),
                            Row(children: [
                              Expanded(
                                child: _Metric(label: 'حلقات', value: '${c['circles_count'] ?? 0}', icon: Icons.menu_book_rounded),
                              ),
                            ]),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _Metric({required this.label, required this.value, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 18),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
        Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 11.5)),
      ],
    );
  }
}
