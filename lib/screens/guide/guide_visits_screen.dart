import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class GuideVisitsScreen extends StatefulWidget {
  const GuideVisitsScreen({super.key});
  @override
  State<GuideVisitsScreen> createState() => _GuideVisitsScreenState();
}

class _GuideVisitsScreenState extends State<GuideVisitsScreen> {
  int _filter = 0;
  int _day = 2;

  @override
  Widget build(BuildContext context) {
    final visits = [
      _V('9:00 ص', 'مركز الإيمان', 'إشراف تربوي • حلقة النور', BadgeKind.warning, 'مجدولة'),
      _V('11:30 ص', 'مركز التقوى', 'زيارة متابعة', BadgeKind.warning, 'مجدولة'),
      _V('1:00 م', 'مركز الرشاد', 'تقييم حلقة نموذجية', BadgeKind.info, 'مفاجئة'),
      _V('4:00 م', 'مركز السلام', 'مراجعة خطة', BadgeKind.success, 'مكتملة'),
    ];

    return GreenHeaderScaffold(
      title: 'جدول الزيارات',
      showBack: false,
      headerExtra: _WeekStrip(selected: _day, onSelect: (i) => setState(() => _day = i)),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () => Navigator.pushNamed(context, '/guide/visits/create'),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('زيارة جديدة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
      ),
      child: ListView(
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
                  onTap: () => Navigator.pushNamed(context, '/guide/visits/create'),
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
                          Text(v.time,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800, color: AppColors.primary, fontSize: 12)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(v.center, style: const TextStyle(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 4),
                          Text(v.detail, style: const TextStyle(color: AppColors.muted, fontSize: 12.5)),
                        ],
                      ),
                    ),
                    StatusBadge(text: v.status, kind: v.kind),
                  ]),
                ),
              )),
        ],
      ),
    );
  }
}

class _V {
  final String time;
  final String center;
  final String detail;
  final BadgeKind kind;
  final String status;
  const _V(this.time, this.center, this.detail, this.kind, this.status);
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
