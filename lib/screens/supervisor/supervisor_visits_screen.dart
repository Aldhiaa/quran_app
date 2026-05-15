import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/supervisor_provider.dart';
import '../../widgets/common_widgets.dart';

class SupervisorVisitsScreen extends StatefulWidget {
  const SupervisorVisitsScreen({super.key});
  @override
  State<SupervisorVisitsScreen> createState() => _SupervisorVisitsScreenState();
}

class _SupervisorVisitsScreenState extends State<SupervisorVisitsScreen> {
  int _filter = 0;
  int _day = 2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<SupervisorProvider>().loadVisits();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sup = context.watch<SupervisorProvider>();
    final visits = sup.visits;

    return GreenHeaderScaffold(
      title: 'جدول الزيارات',
      showBack: false,
      headerExtra: _WeekStrip(selected: _day, onSelect: (i) => setState(() => _day = i)),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () => Navigator.pushNamed(context, '/supervisor/visits/create'),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('زيارة جديدة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
      ),
      child: sup.isLoading
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
                ...visits.map((v) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: AppCard(
                        onTap: () => Navigator.pushNamed(context, '/supervisor/visits/create', arguments: v['id']),
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
                                const Icon(Icons.access_time_rounded, color: AppColors.primary, size: 18),
                                const SizedBox(height: 4),
                                Text('${v['visit_date'] ?? ''}',
                                    style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary, fontSize: 10)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${v['center'] is Map ? v['center']['name'] : ''}',
                                    style: const TextStyle(fontWeight: FontWeight.w800)),
                                const SizedBox(height: 4),
                                Text('${v['circle'] is Map ? v['circle']['name'] : ''}',
                                    style: const TextStyle(color: AppColors.muted, fontSize: 12.5)),
                              ],
                            ),
                          ),
                          StatusBadge(text: '${v['visit_type'] ?? ''}', kind: v['status'] == 'completed' ? BadgeKind.success : BadgeKind.warning),
                        ]),
                      ),
                    )),
              ],
            ),
    );
  }
}

class _WeekStrip extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelect;
  const _WeekStrip({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    const days = ['س', 'ح', 'ن', 'ث', 'ر', 'خ', 'ج'];
    const nums = ['09', '10', '11', '12', '13', '14', '15'];
    return Row(
      children: List.generate(7, (i) {
        final active = i == selected;
        return Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => onSelect(i),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: active ? AppColors.accentGold : Colors.white.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: .25)),
              ),
              child: Column(
                children: [
                  Text(days[i],
                      style: TextStyle(
                          color: active ? AppColors.primaryDeep : Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 11)),
                  const SizedBox(height: 2),
                  Text(nums[i],
                      style: TextStyle(
                          color: active ? AppColors.primaryDeep : Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 14)),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
