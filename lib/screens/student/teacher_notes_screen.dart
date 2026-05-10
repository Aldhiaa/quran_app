import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../services/student_service.dart';
import '../../widgets/common_widgets.dart';

class TeacherNotesScreen extends StatefulWidget {
  const TeacherNotesScreen({super.key});

  @override
  State<TeacherNotesScreen> createState() => _TeacherNotesScreenState();
}

class _TeacherNotesScreenState extends State<TeacherNotesScreen> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _notes = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final svc = Provider.of<StudentService>(context, listen: false);
      _notes = await svc.getTeacherNotes();
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  ({IconData icon, Color color, String label}) _typeMeta(String type) {
    switch (type) {
      case 'encouragement':
        return (icon: Icons.favorite_rounded, color: AppColors.success, label: 'تشجيع');
      case 'correction':
        return (icon: Icons.edit_note_rounded, color: AppColors.info, label: 'تصحيح');
      case 'warning':
        return (icon: Icons.warning_amber_rounded, color: AppColors.warning, label: 'تنبيه');
      case 'intervention':
        return (icon: Icons.healing_rounded, color: AppColors.danger, label: 'خطة علاجية');
      default:
        return (icon: Icons.chat_bubble_rounded, color: AppColors.primary, label: 'ملاحظة');
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _load,
      child: AppShell(
        title: 'ملاحظات المعلم',
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
                : _notes.isEmpty
                    ? const Center(child: Text('لا توجد ملاحظات'))
                    : ListView.separated(
                        itemCount: _notes.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final n = _notes[i];
                          final meta = _typeMeta((n['note_type'] ?? n['type'] ?? '').toString());
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    CircleAvatar(
                                      backgroundColor: meta.color.withValues(alpha: 0.15),
                                      child: Icon(meta.icon, color: meta.color, size: 20),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(meta.label,
                                        style: TextStyle(color: meta.color, fontWeight: FontWeight.bold)),
                                    const Spacer(),
                                    Text(
                                      (n['created_at'] ?? '').toString().split('T').first,
                                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                  ]),
                                  const SizedBox(height: 8),
                                  Text((n['note_text'] ?? n['text'] ?? '').toString()),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
