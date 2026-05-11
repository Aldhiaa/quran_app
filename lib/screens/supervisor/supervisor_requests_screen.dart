import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class SupervisorRequestsScreen extends StatelessWidget {
  const SupervisorRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reqs = [
      _R('طلب مواد تعليمية', 'مركز النور', BadgeKind.warning, 'بانتظار'),
      _R('طلب إجازة معلم', 'مركز الفرقان — أ. خالد', BadgeKind.info, 'قيد المراجعة'),
      _R('طلب نقل طالب', 'محمد الدوسري', BadgeKind.success, 'موافق'),
      _R('طلب صيانة', 'مركز الهداية', BadgeKind.danger, 'مرفوض'),
    ];
    return GreenHeaderScaffold(
      title: 'طلبات المراكز',
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        itemCount: reqs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => EntityListCard(
          leading: Icons.mail_outline_rounded,
          title: reqs[i].title,
          subtitle: reqs[i].from,
          badgeText: reqs[i].status,
          badgeKind: reqs[i].kind,
        ),
      ),
    );
  }
}

class _R {
  final String title;
  final String from;
  final BadgeKind kind;
  final String status;
  const _R(this.title, this.from, this.kind, this.status);
}
