import 'package:flutter/material.dart';
import '../../widgets/common_widgets.dart';

class CommunicationHubScreen extends StatelessWidget {
  const CommunicationHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'التواصل',
      body: Column(
        children: [
          InfoTile(
            title: 'إعلانات المؤسسة',
            subtitle: 'آخر إعلانات المركز',
            icon: Icons.campaign_outlined,
            onTap: () => Navigator.pushNamed(context, '/common/announcements'),
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'مجموعات الحلقات',
            subtitle: 'كل مجموعة',
            icon: Icons.groups_outlined,
            onTap: () => Navigator.pushNamed(context, '/common/groups'),
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'رسائل خاصة',
            subtitle: 'التواصل الفردي',
            icon: Icons.mail_outline,
            onTap: () => Navigator.pushNamed(context, '/common/private-messages'),
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'الإشعارات',
            subtitle: 'جميع التنبيهات',
            icon: Icons.notifications_active_rounded,
            onTap: () => Navigator.pushNamed(context, '/common/notifications'),
          ),
        ],
      ),
    );
  }
}
