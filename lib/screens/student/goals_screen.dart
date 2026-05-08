import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/student_service.dart';
import '../../models/goal_model.dart';
import '../../widgets/common_widgets.dart';
import '../../providers/auth_provider.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<GoalModel> _goals = [];

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final studentService = Provider.of<StudentService>(context, listen: false);
      final goals = await studentService.getGoals();
      setState(() {
        _goals = goals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshGoals() async {
    await _loadGoals();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshGoals,
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return AppShell(
            title: 'أهدافي',
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
                              onPressed: _loadGoals,
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      )
                    : _goals.isEmpty
                        ? const Center(
                            child: Text(
                              'لا توجد أهداف محددة',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _goals.length,
                            itemBuilder: (context, index) {
                              final goal = _goals[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Card(
                                  child: ListTile(
                                    title: Text(goal.title),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (goal.description != null && goal.description.isNotEmpty)
                                          Text(
                                            goal.description!,
                                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                                          ),
                                        Text(
                                          'الهدف حتى: ${goal.targetDate}',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    trailing: goal.completed
                                        ? const Icon(Icons.check_circle, color: Colors.green)
                                        : const Icon(Icons.flag, color: Colors.orange),
                                    onTap: () {
                                      // In a real app, you might navigate to goal details or edit screen
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
            bottomNavigationBar: PrimaryBottomButton(
              title: 'إضافة هدف جديد',
              onPressed: () {
                // Navigate to add goal screen
                // For now, show a message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('سيتم إضافة شاشة إضافة الهدف قريباً')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}