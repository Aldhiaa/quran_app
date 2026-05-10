import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/student_service.dart';
import '../../widgets/common_widgets.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
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
    final rate = (_summary?['attendance']?['rate'] ?? 0).toDouble();
    final present = _summary?['attendance']?['present_records'] ?? 0;
    final total = _summary?['attendance']?['total_records'] ?? 0;

    return RefreshIndicator(
      onRefresh: _loadData,
      child: AppShell(
        title: 'حضوري',
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
                        child: ProgressCard(title: 'سجل الحضور', value: rate / 100, footer: '${rate}% نسبة الحضور'),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(children: [
                          StatCard(label: 'حاضر', value: '$present'),
                          const SizedBox(width: 10),
                          StatCard(label: 'إجمالي', value: '$total'),
                          const SizedBox(width: 10),
                          StatCard(label: 'النسبة', value: '${rate}%'),
                        ]),
                      ),
                    ],
                  ),
      ),
    );
  }
}
