import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../services/student_service.dart';
import '../../widgets/common_widgets.dart';

class HomeworkScreen extends StatefulWidget {
  const HomeworkScreen({super.key});

  @override
  State<HomeworkScreen> createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _items = [];

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
      _items = await svc.getHomework();
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _setStatus(int id, String status) async {
    try {
      final svc = Provider.of<StudentService>(context, listen: false);
      await svc.updateHomeworkStatus(id, status);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تحديث حالة الواجب')),
      );
      _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _load,
      child: AppShell(
        title: 'الواجبات',
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
                : _items.isEmpty
                    ? const Center(child: Text('لا توجد واجبات حالياً'))
                    : ListView.separated(
                        itemCount: _items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final h = _items[i];
                          final id = h['id'] is int ? h['id'] as int : int.tryParse('${h['id']}') ?? 0;
                          final status = (h['status'] ?? 'not_started').toString();
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(h['title']?.toString() ?? 'واجب',
                                      style: const TextStyle(fontWeight: FontWeight.bold)),
                                  if ((h['description'] ?? '').toString().isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(h['description'].toString(),
                                        style: const TextStyle(color: Colors.grey)),
                                  ],
                                  if ((h['due_date'] ?? '').toString().isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Row(children: [
                                      const Icon(Icons.event, size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text('استحقاق: ${h['due_date']}',
                                          style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                    ]),
                                  ],
                                  const SizedBox(height: 10),
                                  Row(children: [
                                    _statusChip('prepared', status, 'تم التحضير', AppColors.success, () => _setStatus(id, 'prepared')),
                                    const SizedBox(width: 6),
                                    _statusChip('need_help', status, 'أحتاج مساعدة', AppColors.warning, () => _setStatus(id, 'need_help')),
                                    const SizedBox(width: 6),
                                    _statusChip('completed', status, 'منجز', AppColors.primary, () => _setStatus(id, 'completed')),
                                  ]),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }

  Widget _statusChip(String key, String current, String label, Color color, VoidCallback onTap) {
    final selected = current == key;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      selectedColor: color.withValues(alpha: 0.18),
      onSelected: (_) => onTap(),
    );
  }
}
