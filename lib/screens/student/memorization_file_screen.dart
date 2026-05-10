import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/student_service.dart';
import '../../widgets/common_widgets.dart';

class MemorizationFileScreen extends StatefulWidget {
  const MemorizationFileScreen({super.key});

  @override
  State<MemorizationFileScreen> createState() => _MemorizationFileScreenState();
}

class _MemorizationFileScreenState extends State<MemorizationFileScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _stats;

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
      final stats = await svc.getStudentSummary();
      setState(() {
        _stats = stats;
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
    final progress = (_stats?['progress'] ?? 0).toDouble();

    return RefreshIndicator(
      onRefresh: _loadData,
      child: AppShell(
        title: 'ملف الحفظ',
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
                        child: ProgressCard(title: 'تقدم الحفظ', value: progress, footer: 'التقدم العام في الحفظ'),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: InfoTile(
                          title: 'المحفوظ',
                          subtitle: '${_stats?['total_memorized'] ?? _stats?['memorization'] ?? '--'}',
                          icon: Icons.folder_outlined,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: InfoTile(
                          title: 'المراجعة',
                          subtitle: '${_stats?['total_reviewed'] ?? _stats?['review'] ?? '--'}',
                          icon: Icons.task_alt_outlined,
                        ),
                      ),
                    ],
                  ),
        bottomNavigationBar: const PrimaryBottomButton(title: 'عرض التفاصيل'),
      ),
    );
  }
}
