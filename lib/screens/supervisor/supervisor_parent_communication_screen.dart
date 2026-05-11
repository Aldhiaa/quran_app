import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class SupervisorParentCommunicationScreen extends StatelessWidget {
  const SupervisorParentCommunicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _M('والد فيصل الزهراني', 'بخصوص تكرار الغياب لأسبوع كامل', '10:24 ص', BadgeKind.danger, 'عاجل'),
      _M('والد محمد الدوسري', 'دعوة لاجتماع لمناقشة الأداء', 'أمس', BadgeKind.info, 'مرسل'),
      _M('والد سعد الشهري', 'تأكيد متابعة الواجب المنزلي', '2 يوم', BadgeKind.success, 'مكتمل'),
    ];

    return GreenHeaderScaffold(
      title: 'التواصل مع أولياء الأمور',
      headerExtra: SearchFilterBar(hint: 'بحث', onChanged: (_) {}),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () {},
        icon: const Icon(Icons.message_rounded, color: Colors.white),
        label: const Text('رسالة جديدة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => AppCard(
          child: Row(children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: badgeColor(items[i].kind).withValues(alpha: .14),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(Icons.account_circle_rounded, color: badgeColor(items[i].kind)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(child: Text(items[i].name, style: const TextStyle(fontWeight: FontWeight.w800))),
                    Text(items[i].time, style: const TextStyle(color: AppColors.muted, fontSize: 11)),
                  ]),
                  const SizedBox(height: 3),
                  Text(items[i].msg,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.muted, fontSize: 12.5)),
                  const SizedBox(height: 6),
                  StatusBadge(text: items[i].status, kind: items[i].kind),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _M {
  final String name;
  final String msg;
  final String time;
  final BadgeKind kind;
  final String status;
  const _M(this.name, this.msg, this.time, this.kind, this.status);
}
