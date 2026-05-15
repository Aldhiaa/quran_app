import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/guide_provider.dart';
import '../../widgets/common_widgets.dart';

class GuideCenterDetailScreen extends StatefulWidget {
  const GuideCenterDetailScreen({super.key});
  @override
  State<GuideCenterDetailScreen> createState() => _GuideCenterDetailScreenState();
}

class _GuideCenterDetailScreenState extends State<GuideCenterDetailScreen> {
  int? _centerId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is int && _centerId == null) {
      _centerId = args;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.read<GuideProvider>().loadCenterDetail(args);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final guide = context.watch<GuideProvider>();
    final center = guide.centerDetail['center'] as Map<String, dynamic>? ?? {};
    final circles = (center['circles'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    return GreenHeaderScaffold(
      title: '${center['name'] ?? ''}',
      child: guide.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('معلومات المركز', style: TextStyle(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 10),
                      InfoTile(
                        icon: Icons.location_on_rounded,
                        label: 'الفرع',
                        value: '${center['branch']['name'] ?? ''}',
                      ),
                      const Divider(),
                      InfoTile(
                        icon: Icons.menu_book_rounded,
                        label: 'عدد الحلقات',
                        value: '${circles.length}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                if (circles.isNotEmpty) ...[
                  const AppSectionTitle(title: 'الحلقات'),
                  const SizedBox(height: 8),
                  ...circles.map((c) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: EntityListCard(
                          leading: Icons.menu_book_rounded,
                          title: '${c['name'] ?? ''}',
                          subtitle: '${c['teacher']['full_name'] ?? c['teacher']['name'] ?? ''}',
                          badgeText: '${c['active_students_count'] ?? '0'} طالبة',
                        ),
                      )),
                ],
                if (guide.error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: AppErrorState(message: guide.error!),
                  ),
              ],
            ),
    );
  }
}
