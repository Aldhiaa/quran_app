import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/supervisor_provider.dart';
import '../../widgets/common_widgets.dart';

class SupervisorRiskCasesScreen extends StatefulWidget {
  const SupervisorRiskCasesScreen({super.key});

  @override
  State<SupervisorRiskCasesScreen> createState() => _SupervisorRiskCasesScreenState();
}

class _SupervisorRiskCasesScreenState extends State<SupervisorRiskCasesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<SupervisorProvider>().loadRiskCases();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sup = context.watch<SupervisorProvider>();
    final cases = sup.riskCases;

    return GreenHeaderScaffold(
      title: 'حالات الطلاب الحرجة',
      headerExtra: SearchFilterBar(hint: 'بحث', onChanged: (_) {}),
      child: sup.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              itemCount: cases.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final c = cases[i];
                final isCritical = c['risk_reason'] == 'attendance';
                return AppCard(
                  child: Row(children: [
                    Container(
                      width: 8,
                      height: 72,
                      decoration: BoxDecoration(
                        color: isCritical ? AppColors.danger : AppColors.warning,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.accentGold.withValues(alpha: .18),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.person_rounded, color: AppColors.primary),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${c['full_name'] ?? ''}',
                              style: const TextStyle(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 3),
                          Text(
                            isCritical ? 'تدني في الحضور' : 'ضعف في الحفظ',
                            style: TextStyle(
                              color: isCritical ? AppColors.danger : AppColors.warning,
                              fontWeight: FontWeight.w700,
                              fontSize: 12.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text('${c['circle_name'] ?? ''} — ${c['center_name'] ?? ''}',
                              style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                        ],
                      ),
                    ),
                    StatusBadge(
                      text: isCritical ? 'حرج' : 'متابعة',
                      kind: isCritical ? BadgeKind.danger : BadgeKind.warning,
                    ),
                  ]),
                );
              },
            ),
    );
  }
}
