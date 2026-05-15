import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/supervisor_provider.dart';
import '../../widgets/common_widgets.dart';

class SupervisorTeachersScreen extends StatefulWidget {
  const SupervisorTeachersScreen({super.key});
  @override
  State<SupervisorTeachersScreen> createState() => _SupervisorTeachersScreenState();
}

class _SupervisorTeachersScreenState extends State<SupervisorTeachersScreen> {
  int _filter = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<SupervisorProvider>().loadTeachers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sup = context.watch<SupervisorProvider>();
    final teachers = sup.teachers;

    return GreenHeaderScaffold(
      title: 'متابعة المعلمين',
      headerExtra: SearchFilterBar(hint: 'بحث عن معلم', onChanged: (_) {}),
      child: sup.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              children: [
                FilterChipsBar(
                  items: const ['الكل', 'متفوقون', 'يحتاج متابعة', 'مخالفات'],
                  selected: _filter,
                  onChanged: (i) => setState(() => _filter = i),
                ),
                const SizedBox(height: 12),
                ...teachers.map((t) => Padding(
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
                                child: const Icon(Icons.school_rounded, color: AppColors.primary),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${t['full_name'] ?? t['name'] ?? ''}',
                                        style: const TextStyle(fontWeight: FontWeight.w800)),
                                    const SizedBox(height: 3),
                                    Text(
                                      '${t['circles'] is List && (t['circles'] as List).isNotEmpty ? (t['circles'] as List).map((c) => c is Map ? '${c['name'] ?? ''}' : '').join(', ') : ''}',
                                      style: const TextStyle(color: AppColors.muted, fontSize: 12.5),
                                    ),
                                  ],
                                ),
                              ),
                              StatusBadge(text: 'ملتزم', kind: BadgeKind.success),
                            ]),
                            const SizedBox(height: 10),
                            if (t['circles'] is List)
                              Row(children: [
                                const Icon(Icons.groups_rounded, size: 14, color: AppColors.muted),
                                const SizedBox(width: 4),
                                Text('${t['circles'] is List ? (t['circles'] as List).fold<int>(0, (sum, c) => sum + ((c as Map)['active_students_count'] as int? ?? 0)) : 0} طالب',
                                    style: const TextStyle(color: AppColors.muted, fontSize: 12)),
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
