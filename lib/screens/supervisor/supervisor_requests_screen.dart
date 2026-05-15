import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/supervisor_provider.dart';
import '../../widgets/common_widgets.dart';

class SupervisorRequestsScreen extends StatefulWidget {
  const SupervisorRequestsScreen({super.key});
  @override
  State<SupervisorRequestsScreen> createState() => _SupervisorRequestsScreenState();
}

class _SupervisorRequestsScreenState extends State<SupervisorRequestsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<SupervisorProvider>().loadCenterRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sup = context.watch<SupervisorProvider>();
    final reqs = sup.centerRequests;

    return GreenHeaderScaffold(
      title: 'طلبات المراكز',
      child: sup.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              itemCount: reqs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final r = reqs[i];
                final status = '${r['status'] ?? ''}';
                final kind = status == 'approved' ? BadgeKind.success : (status == 'rejected' ? BadgeKind.danger : BadgeKind.warning);
                return EntityListCard(
                  leading: Icons.mail_outline_rounded,
                  title: '${r['title'] ?? ''}',
                  subtitle: r['center'] is Map ? '${r['center']['name'] ?? ''}' : '',
                  badgeText: status == 'pending' ? 'بانتظار' : (status == 'approved' ? 'موافق' : 'مرفوض'),
                  badgeKind: kind,
                );
              },
            ),
    );
  }
}
