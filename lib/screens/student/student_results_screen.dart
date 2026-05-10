import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/student_service.dart';
import '../../widgets/common_widgets.dart';

class StudentResultsScreen extends StatefulWidget {
  const StudentResultsScreen({super.key});

  @override
  State<StudentResultsScreen> createState() => _StudentResultsScreenState();
}

class _StudentResultsScreenState extends State<StudentResultsScreen> {
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
      final svc = Provider.of<StudentService>(context, listen: false);
      final summary = await svc.getStudentSummary();
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
  Widget build(BuildContext context) {
    final avg = _summary?['monthly_test_average'];
    final progress = avg != null ? (avg as num).toDouble() / 100 : 0.0;

    return RefreshIndicator(
      onRefresh: _loadData,
      child: AppShell(
        title: 'نتائجي',
        showBack: false,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ProgressCard(title: 'النسبة العامة', value: progress, footer: avg != null ? '$avg%' : '--'),
                      ),
                      const SizedBox(height: 12),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('إحصائيات الشهر', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 12),
                              _statRow('جلسات اليوم', '${_summary?['daily_sessions']?['total'] ?? '--'}'),
                              _statRow('حضور', '${_summary?['attendance']?['rate'] ?? '--'}%'),
                              _statRow('الخطط العلاجية', '${_summary?['remedial_plans']?['open'] ?? '0'}'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _statRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(value, style: const TextStyle(fontWeight: FontWeight.bold))],
      ),
    );
  }
}
