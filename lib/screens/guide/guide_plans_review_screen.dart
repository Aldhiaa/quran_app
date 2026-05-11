import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class GuidePlansReviewScreen extends StatelessWidget {
  const GuidePlansReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plans = [
      _P('خطة شهر شعبان — مركز الإيمان', 'مقدمة من: أ. منى السبيعي', BadgeKind.warning, 'بانتظار المراجعة'),
      _P('خطة فصلية — مركز التقوى', 'مقدمة من: أ. هند العتيبي', BadgeKind.info, 'قيد المراجعة'),
      _P('خطة شهر رجب — مركز الرشاد', 'مقدمة من: أ. سارة المالكي', BadgeKind.danger, 'تحتاج تعديل'),
      _P('خطة شهر شعبان — مركز السلام', 'مقدمة من: أ. أمل القحطاني', BadgeKind.success, 'معتمدة'),
    ];

    return GreenHeaderScaffold(
      title: 'مراجعة الخطط',
      headerExtra: SearchFilterBar(hint: 'بحث', onChanged: (_) {}),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        itemCount: plans.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => EntityListCard(
          leading: Icons.menu_book_rounded,
          title: plans[i].title,
          subtitle: plans[i].sub,
          badgeText: plans[i].status,
          badgeKind: plans[i].kind,
        ),
      ),
    );
  }
}

class _P {
  final String title;
  final String sub;
  final BadgeKind kind;
  final String status;
  const _P(this.title, this.sub, this.kind, this.status);
}
