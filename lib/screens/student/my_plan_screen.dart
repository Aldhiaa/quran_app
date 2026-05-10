import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../data/quran_surahs.dart';
import '../../services/student_service.dart';
import '../../widgets/common_widgets.dart';

class MyPlanScreen extends StatefulWidget {
  const MyPlanScreen({super.key});

  @override
  State<MyPlanScreen> createState() => _MyPlanScreenState();
}

class _MyPlanScreenState extends State<MyPlanScreen> {
  bool _loading = true;
  String? _error;
  Map<String, dynamic> _plan = const {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final svc = Provider.of<StudentService>(context, listen: false);
      _plan = await svc.getStudentPlan();
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _formatRange(Map? r) {
    if (r == null) return '—';
    final fs = (r['from_surah'] ?? 0) is int ? r['from_surah'] as int : int.tryParse('${r['from_surah']}') ?? 0;
    final ts = (r['to_surah'] ?? 0) is int ? r['to_surah'] as int : int.tryParse('${r['to_surah']}') ?? 0;
    if (fs <= 0 || ts <= 0) return '—';
    final fa = r['from_ayah'] ?? 1;
    final ta = r['to_ayah'] ?? 1;
    final f = surahByNumber(fs).arabicName;
    final t = surahByNumber(ts).arabicName;
    if (fs == ts) return '$f (آية $fa - $ta)';
    return '$f آية $fa → $t آية $ta';
  }

  @override
  Widget build(BuildContext context) {
    final today = _plan['today'] is Map ? _plan['today'] as Map : const {};
    final week = _plan['week'] is Map ? _plan['week'] as Map : const {};
    final month = _plan['month'] is Map ? _plan['month'] as Map : const {};

    return RefreshIndicator(
      onRefresh: _load,
      child: AppShell(
        title: 'خطتي',
        showBack: false,
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
                : ListView(
                    children: [
                      _planCard(
                        title: 'مهام اليوم',
                        icon: Icons.today_rounded,
                        color: AppColors.primary,
                        memorization: _formatRange(today['memorization']),
                        review: _formatRange(today['review']),
                        note: today['note']?.toString(),
                      ),
                      const SizedBox(height: 8),
                      _planCard(
                        title: 'الخطة الأسبوعية',
                        icon: Icons.view_week_rounded,
                        color: AppColors.info,
                        memorization: _formatRange(week['memorization']),
                        review: _formatRange(week['review']),
                        note: week['note']?.toString(),
                      ),
                      const SizedBox(height: 8),
                      _planCard(
                        title: 'الخطة الشهرية',
                        icon: Icons.calendar_month_rounded,
                        color: AppColors.secondary,
                        memorization: _formatRange(month['memorization']),
                        review: _formatRange(month['review']),
                        note: month['note']?.toString(),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.assignment_rounded),
                          title: const Text('الواجبات'),
                          subtitle: const Text('المهام المطلوب تحضيرها'),
                          trailing: const Icon(Icons.chevron_left_rounded),
                          onTap: () => Navigator.pushNamed(context, '/student/homework'),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _planCard({
    required String title,
    required IconData icon,
    required Color color,
    required String memorization,
    required String review,
    String? note,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              CircleAvatar(backgroundColor: color.withValues(alpha: 0.12), child: Icon(icon, color: color)),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ]),
            const SizedBox(height: 10),
            _kv('الحفظ', memorization),
            const SizedBox(height: 4),
            _kv('المراجعة', review),
            if ((note ?? '').isNotEmpty) ...[
              const SizedBox(height: 6),
              Text('ملاحظة: $note', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Row(children: [
      SizedBox(width: 60, child: Text(k, style: const TextStyle(color: Colors.grey))),
      Expanded(child: Text(v, style: const TextStyle(fontWeight: FontWeight.w600))),
    ]);
  }
}
