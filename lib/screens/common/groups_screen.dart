import 'package:flutter/material.dart';
import '../../services/teacher_service.dart';
import '../../widgets/common_widgets.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final TeacherService _teacherService = TeacherService();
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _circles = [];

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final circles = await _teacherService.getCircles();
      setState(() {
        _circles = circles;
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
    return RefreshIndicator(
      onRefresh: _loadGroups,
      child: AppShell(
        title: 'مجموعة الحلقات',
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_errorMessage!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        ElevatedButton(onPressed: _loadGroups, child: const Text('إعادة المحاولة')),
                      ],
                    ),
                  )
                : _circles.isEmpty
                    ? const Center(child: Text('لا توجد مجموعات', style: TextStyle(fontSize: 16, color: Colors.grey)))
                    : ListView.builder(
                        itemCount: _circles.length,
                        itemBuilder: (context, index) {
                          final circle = _circles[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: InfoTile(
                              title: circle['name'] ?? '',
                              subtitle: '${circle['students_count'] ?? circle['capacity'] ?? '--'} عضو',
                              icon: Icons.forum_outlined,
                            ),
                          );
                        },
                      ),
        bottomNavigationBar: const PrimaryBottomButton(title: 'إنشاء مجموعة'),
      ),
    );
  }
}
