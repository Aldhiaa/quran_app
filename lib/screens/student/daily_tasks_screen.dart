import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/student_service.dart';
import '../../models/daily_task_model.dart';
import '../../widgets/common_widgets.dart';
import '../../providers/auth_provider.dart';

class DailyTasksScreen extends StatefulWidget {
  const DailyTasksScreen({super.key});

  @override
  State<DailyTasksScreen> createState() => _DailyTasksScreenState();
}

class _DailyTasksScreenState extends State<DailyTasksScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<DailyTaskModel> _dailyTasks = [];

  @override
  void initState() {
    super.initState();
    _loadDailyTasks();
  }

  Future<void> _loadDailyTasks() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final studentService = Provider.of<StudentService>(context, listen: false);
      final tasks = await studentService.getDailyTasks();
      setState(() {
        _dailyTasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshTasks() async {
    await _loadDailyTasks();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshTasks,
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return AppShell(
            title: 'مهامي اليومية',
            body: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'خطأ: $_errorMessage',
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadDailyTasks,
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      )
                    : _dailyTasks.isEmpty
                        ? const Center(
                            child: Text(
                              'لا توجد مهام يومية',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _dailyTasks.length,
                            itemBuilder: (context, index) {
                              final task = _dailyTasks[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10, left: 16, right: 16),
                                child: Card(
                                  child: CheckboxListTile(
                                    value: task.done,
                                    onChanged: (bool? value) {
                                      // In a real app, you might update the task status via API
                                      setState(() {
                                        task.done = value ?? false;
                                      });
                                    },
                                    title: Text(task.title),
                                    secondary: Icon(
                                      task.done ? Icons.check_circle : Icons.radio_button_unchecked,
                                      color: task.done ? Colors.green : Colors.grey,
                                    ),
                                    controlAffinity: ListTileControlAffinity.leading,
                                  ),
                                ),
                              );
                            },
                          ),
            bottomNavigationBar: _dailyTasks.isNotEmpty
                ? PrimaryBottomButton(
                    title: 'تم تنفيذ المهام',
                    onPressed: () {
                      // Show success message or navigate
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم تنفيذ جميع المهام بنجاح!')),
                      );
                    },
                  )
                : null,
          );
        },
      ),
    );
  }
}