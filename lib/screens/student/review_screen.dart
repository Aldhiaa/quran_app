import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/student_service.dart';
import '../../models/daily_task_model.dart';
import '../../widgets/common_widgets.dart';
import '../../providers/auth_provider.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<DailyTaskModel> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final studentService = Provider.of<StudentService>(context, listen: false);
      final tasks = await studentService.getDailyTasks();
      setState(() {
        _tasks = tasks;
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
    return RefreshIndicator(
      onRefresh: _loadTasks,
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return AppShell(
            title: 'مراجعتي',
            body: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_errorMessage!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                            const SizedBox(height: 16),
                            ElevatedButton(onPressed: _loadTasks, child: const Text('إعادة المحاولة')),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Row(children: [
                            ChoiceChip(label: const Text('الأسبوعية'), selected: true, onSelected: (_) {}),
                            const SizedBox(width: 8),
                            ChoiceChip(label: const Text('اليومية'), selected: false, onSelected: (_) {}),
                          ]),
                          const SizedBox(height: 12),
                          Expanded(
                            child: _tasks.isEmpty
                                ? const Center(child: Text('لا توجد مراجعات', style: TextStyle(fontSize: 16, color: Colors.grey)))
                                : ListView.builder(
                                    itemCount: _tasks.length,
                                    itemBuilder: (context, index) {
                                      final task = _tasks[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: Card(
                                          child: ListTile(
                                            title: Text(task.title),
                                            trailing: Text(task.done ? 'مكتملة' : 'لم تبدأ'),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
          );
        },
      ),
    );
  }
}
