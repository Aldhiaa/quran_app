import 'package:flutter/material.dart';
import '../../services/teacher_service.dart';
import '../../widgets/common_widgets.dart';

class WeeklyEvaluationScreen extends StatefulWidget {
  const WeeklyEvaluationScreen({super.key});

  @override
  State<WeeklyEvaluationScreen> createState() => _WeeklyEvaluationScreenState();
}

class _WeeklyEvaluationScreenState extends State<WeeklyEvaluationScreen> {
  final TeacherService _teacherService = TeacherService();
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _summary;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final summary = await _teacherService.getTeacherSummary();
      setState(() {
        _summary = summary;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _teacherService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'التقييم الأسبوعي',
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_errorMessage!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(onPressed: _loadData, child: const Text('إعادة المحاولة')),
                    ],
                  ),
                )
              : ListView(
                  children: [
                    Text('${_summary?['month'] ?? ''}/${_summary?['year'] ?? ''}',
                        style: const TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    const InfoTile(
                      title: 'تحديد طالب',
                      subtitle: 'اختر طالباً للتقييم',
                      icon: Icons.person_rounded,
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('معايير التقييم', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            _evalItem('المحافظة على الصلاة'),
                            _evalItem('الأدب مع الوالدين'),
                            _evalItem('المساعدة في المنزل'),
                            _evalItem('تنظيم الوقت للدراسة'),
                            _evalItem('حضور الحلقة بانتظام'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('المجموع', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('--/100', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
      bottomNavigationBar: const PrimaryBottomButton(title: 'حفظ التقييم'),
    );
  }

  Widget _evalItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          _scoreChip('0'),
          _scoreChip('5'),
          _scoreChip('10'),
        ],
      ),
    );
  }

  Widget _scoreChip(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: ChoiceChip(label: Text(label, style: const TextStyle(fontSize: 12)), selected: label == '10', onSelected: (_) {}),
    );
  }
}
