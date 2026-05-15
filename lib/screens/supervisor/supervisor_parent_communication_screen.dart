import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/supervisor_provider.dart';
import '../../widgets/common_widgets.dart';

class SupervisorParentCommunicationScreen extends StatefulWidget {
  const SupervisorParentCommunicationScreen({super.key});

  @override
  State<SupervisorParentCommunicationScreen> createState() =>
      _SupervisorParentCommunicationScreenState();
}

class _SupervisorParentCommunicationScreenState
    extends State<SupervisorParentCommunicationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<SupervisorProvider>().loadParentContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sup = context.watch<SupervisorProvider>();
    final items = sup.parentContacts;

    return GreenHeaderScaffold(
      title: 'التواصل مع أولياء الأمور',
      headerExtra: SearchFilterBar(hint: 'بحث', onChanged: (_) {}),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () {},
        icon: const Icon(Icons.message_rounded, color: Colors.white),
        label: const Text('رسالة جديدة',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
      ),
      child: sup.isLoading
          ? const Center(child: CircularProgressIndicator())
          : sup.parentContacts.isEmpty && sup.error != null
              ? AppErrorState(
                  message: sup.error!,
                  onRetry: () =>
                      context.read<SupervisorProvider>().loadParentContacts())
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final m = items[i];
                    final hasFollowUp =
                        m['follow_up_required'] == true || m['follow_up_required'] == '1';
                    return AppCard(
                      child: Row(children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: hasFollowUp
                                ? AppColors.warning.withValues(alpha: .14)
                                : AppColors.success.withValues(alpha: .14),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.account_circle_rounded,
                            color: hasFollowUp ? AppColors.warning : AppColors.success,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Expanded(
                                  child: Text(
                                    m['guardian'] is Map
                                        ? '${m['guardian']['name'] ?? ''}'
                                        : '${m['student'] is Map ? m['student']['full_name'] ?? '' : ''}',
                                    style: const TextStyle(fontWeight: FontWeight.w800),
                                  ),
                                ),
                                Text(
                                  m['contacted_at'] is String
                                      ? (m['contacted_at'] as String).substring(0, 10)
                                      : '',
                                  style: const TextStyle(color: AppColors.muted, fontSize: 11),
                                ),
                              ]),
                              const SizedBox(height: 3),
                              Text(
                                '${m['reason'] ?? ''}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    const TextStyle(color: AppColors.muted, fontSize: 12.5),
                              ),
                              const SizedBox(height: 6),
                              Row(children: [
                                StatusBadge(
                                  text: '${m['method'] ?? 'اتصال'}',
                                  kind: BadgeKind.info,
                                ),
                                if (hasFollowUp) ...[
                                  const SizedBox(width: 6),
                                  StatusBadge(
                                    text: 'متابعة مطلوبة',
                                    kind: BadgeKind.warning,
                                  ),
                                ],
                              ]),
                            ],
                          ),
                        ),
                      ]),
                    );
                  },
                ),
    );
  }
}
