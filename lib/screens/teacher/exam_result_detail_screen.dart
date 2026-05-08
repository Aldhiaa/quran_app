import 'package:flutter/material.dart';
import '../../services/teacher_service.dart';
import '../../widgets/common_widgets.dart';

class ExamResultDetailScreen extends StatefulWidget {
  const ExamResultDetailScreen({super.key});

  @override
  State<ExamResultDetailScreen> createState() => _ExamResultDetailScreenState();
}

class _ExamResultDetailScreenState extends State<ExamResultDetailScreen> {
  final TeacherService _teacherService = TeacherService();
  bool _isLoading = true;
  String? _errorMessage;

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
      await _teacherService.getDashboardStats();
      setState(() { _isLoading = false; });
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
      title: 'تفاصيل نتيجة الطالب',
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
                  children: const [
                    InfoTile(title: 'الطالب', subtitle: 'اختر طالباً لعرض النتيجة', icon: Icons.person),
                    SizedBox(height: 12),
                    ProgressCard(title: 'النتيجة العامة', value: 0, footer: '--/--'),
                    SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('اختر طالباً واختباراً لعرض التفاصيل',
                            style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
      bottomNavigationBar: const PrimaryBottomButton(title: 'مشاركة التقرير'),
    );
  }
}
