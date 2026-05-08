import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../services/teacher_service.dart';
import '../../widgets/common_widgets.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final TeacherService _teacherService = TeacherService();
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _students = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final students = await _teacherService.getStudents();
      setState(() {
        _students = students;
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

  List<Map<String, dynamic>> get _filteredStudents {
    if (_searchQuery.isEmpty) return _students;
    return _students.where((s) =>
      (s['name'] ?? s['full_name'] ?? '').toString().contains(_searchQuery)
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadStudents,
      child: AppShell(
        title: 'طلابي',
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_errorMessage!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        ElevatedButton(onPressed: _loadStudents, child: const Text('إعادة المحاولة')),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      TextField(
                        decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'ابحث عن طالب...'),
                        onChanged: (value) => setState(() => _searchQuery = value),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: _filteredStudents.isEmpty
                            ? const Center(child: Text('لا يوجد طلاب', style: TextStyle(fontSize: 16, color: Colors.grey)))
                            : ListView.builder(
                                itemCount: _filteredStudents.length,
                                itemBuilder: (context, index) {
                                  final student = _filteredStudents[index];
                                  final name = student['name'] ?? student['full_name'] ?? '';
                                  final parts = student['parts'] ?? student['current_level'] ?? '';
                                  final progress = (student['progress'] ?? 0).toDouble();
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Card(
                                      child: ListTile(
                                        onTap: () => Navigator.pushNamed(context, '/teacher/student-detail'),
                                        leading: CircleAvatar(child: Text(name.isNotEmpty ? name[0] : '?')),
                                        title: Text(name),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 4),
                                            Text('المستوى: $parts'),
                                            const SizedBox(height: 6),
                                            LinearProgressIndicator(
                                              value: progress > 0 ? progress : null,
                                              minHeight: 7,
                                              borderRadius: BorderRadius.circular(100),
                                              backgroundColor: AppColors.secondary.withOpacity(.2),
                                              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                                            ),
                                          ],
                                        ),
                                        trailing: progress > 0 ? Text('${(progress * 100).round()}%') : null,
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
