import 'package:flutter/material.dart';
import '../../services/teacher_service.dart';
import '../../widgets/common_widgets.dart';

class HalaqatScreen extends StatefulWidget {
  const HalaqatScreen({super.key});

  @override
  State<HalaqatScreen> createState() => _HalaqatScreenState();
}

class _HalaqatScreenState extends State<HalaqatScreen> {
  final TeacherService _teacherService = TeacherService();
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _circles = [];

  @override
  void initState() {
    super.initState();
    _loadCircles();
  }

  Future<void> _loadCircles() async {
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
      onRefresh: _loadCircles,
      child: AppShell(
        title: 'حلقاتي',
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_errorMessage!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        ElevatedButton(onPressed: _loadCircles, child: const Text('إعادة المحاولة')),
                      ],
                    ),
                  )
                : _circles.isEmpty
                    ? const Center(child: Text('لا توجد حلقات', style: TextStyle(fontSize: 16, color: Colors.grey)))
                    : ListView.builder(
                        itemCount: _circles.length,
                        itemBuilder: (context, index) {
                          final circle = _circles[index];
                          final name = circle['name'] ?? '';
                          final level = circle['level'] ?? '';
                          final count = circle['students_count'] ?? circle['capacity'] ?? '--';
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: InfoTile(
                              title: name,
                              subtitle: '$level - $count طالب',
                              icon: Icons.class_rounded,
                              onTap: () => Navigator.pushNamed(context, '/teacher/students'),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
