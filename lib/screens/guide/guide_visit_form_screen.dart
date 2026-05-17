import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/guide_provider.dart';
import '../../widgets/common_widgets.dart';

class GuideVisitFormScreen extends StatefulWidget {
  const GuideVisitFormScreen({super.key});
  @override
  State<GuideVisitFormScreen> createState() => _GuideVisitFormScreenState();
}

class _GuideVisitFormScreenState extends State<GuideVisitFormScreen> {
  int? _visitId;
  final _notesController = TextEditingController();
  final _recommendationsController = TextEditingController();

  // Creation mode fields
  final _centerController = TextEditingController();
  final _circleController = TextEditingController();
  String _visitType = 'scheduled';
  DateTime _visitDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);

  bool _isSubmitting = false;

  final List<String> _items = const [
    'انتظام الحضور',
    'الالتزام بالخطة',
    'جودة التحفيظ',
    'تفاعل الطالبات',
    'بيئة الحلقة',
  ];
  late final List<bool> _checks = List<bool>.filled(_items.length, false);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is int && _visitId == null) {
      _visitId = args;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.read<GuideProvider>().loadVisitDetail(args);
      });
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _recommendationsController.dispose();
    _centerController.dispose();
    _circleController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);
    try {
      final guide = context.read<GuideProvider>();
      if (_visitId == null) {
        // Create new visit first
        final result = await guide.createVisit({
          'center_id': 1, // TODO: use actual selected center
          'circle_id': 1,
          'branch_id': 1,
          'visit_type': _visitType,
          'visit_date': _visitDate.toIso8601String().split('T').first,
          'start_time':
              '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}',
        });
        final newId = (result['id'] as num?)?.toInt();
        if (newId != null) {
          await guide.updateVisit(newId, {
            'guide_notes': _notesController.text,
            'recommendations': _recommendationsController.text,
          });
          await guide.submitVisit(newId);
        }
      } else {
        await guide.updateVisit(_visitId!, {
          'guide_notes': _notesController.text,
          'recommendations': _recommendationsController.text,
        });
        await guide.submitVisit(_visitId!);
      }
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final guide = context.watch<GuideProvider>();
    final visit = guide.visitDetail;

    return GreenHeaderScaffold(
      title: 'استمارة الزيارة',
      bottomNavigationBar: _isSubmitting
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.send_rounded),
                label: const Text('تقديم الزيارة',
                    style: TextStyle(fontWeight: FontWeight.w800)),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md)),
                ),
              ),
            ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('بيانات الزيارة',
                    style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                _row(Icons.business_rounded, 'المركز',
                    '${visit['center']['name'] ?? ''}'),
                const Divider(),
                _row(Icons.person_2_rounded, 'المشرفة',
                    '${visit['teacher']['full_name'] ?? visit['teacher']['name'] ?? ''}'),
                const Divider(),
                _row(Icons.calendar_month_rounded, 'التاريخ',
                    '${visit['visit_date'] ?? ''}'),
                const Divider(),
                _row(Icons.access_time_rounded, 'الوقت',
                    '${visit['start_time'] ?? ''}'),
                const Divider(),
                _row(Icons.assignment_rounded, 'نوع الزيارة',
                    _visitTypeLabel(visit)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('بنود التقييم',
                    style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                ...List.generate(_items.length,
                    (i) => CheckboxListTile(
                          value: _checks[i],
                          onChanged: (v) =>
                              setState(() => _checks[i] = v ?? false),
                          title: Text(_items[i],
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: AppColors.primary,
                          dense: true,
                        )),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('الملاحظات',
                    style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                TextField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'اكتب الملاحظات هنا...',
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('التوصيات',
                    style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                TextField(
                  controller: _recommendationsController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'اكتب التوصيات هنا...',
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _visitTypeLabel(Map<String, dynamic> v) {
    final type = (v['visit_type'] as dynamic)?.toString() ?? '';
    switch (type) {
      case 'scheduled':
        return 'مجدولة';
      case 'surprise':
        return 'مفاجئة';
      case 'model_circle':
        return 'تقييم حلقة نموذجية';
      case 'educational_supervision':
        return 'إشراف تربوي';
      case 'training_followup':
        return 'متابعة تدريبية';
      default:
        return type;
    }
  }

  Widget _row(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 12.5)),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
      ]),
    );
  }
}
