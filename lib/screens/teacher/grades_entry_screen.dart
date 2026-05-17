import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_theme.dart';
import '../../providers/teacher_provider.dart';
import '../../widgets/common_widgets.dart';

class GradesEntryScreen extends StatefulWidget {
  const GradesEntryScreen({super.key});

  @override
  State<GradesEntryScreen> createState() => _GradesEntryScreenState();
}

class _GradesEntryScreenState extends State<GradesEntryScreen> {
  final _fields = [
    ('الحفظ', 50, Icons.menu_book_rounded, AppColors.primary),
    ('التلاوة', 50, Icons.record_voice_over_rounded, AppColors.info),
    ('أحكام التجويد', 30, Icons.auto_awesome_rounded, AppColors.accentGold),
    ('المتن', 20, Icons.article_rounded, AppColors.success),
    ('السلوك', 50, Icons.people_rounded, AppColors.warning),
  ];

  late List<int> _scores;
  final _notesCtrl = TextEditingController();

  int get totalPossible => _fields.fold(0, (sum, f) => sum + f.$2);
  int get totalScore => _scores.fold(0, (sum, s) => sum + s);
  double get percentage => totalPossible > 0 ? totalScore / totalPossible : 0;

  @override
  void initState() {
    super.initState();
    _scores = List.filled(_fields.length, 0);
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teacher = context.watch<TeacherProvider>();
    final student = teacher.selectedStudent;
    final studentName = student?['full_name'] as String? ?? student?['name'] as String? ?? 'الطالب';

    return GreenHeaderScaffold(
      title: 'إدخال الدرجات',
      headerExtra: AppCard(
        color: Colors.white.withValues(alpha: .12),
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .15),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(studentName[0],
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(studentName,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                const SizedBox(height: 2),
                Text('اختبار شهر شعبان',
                    style: TextStyle(color: Colors.white.withValues(alpha: .7), fontSize: 12)),
              ],
            ),
          ),
          ProgressRing(value: percentage, size: 40, strokeWidth: 4,
              trackColor: Colors.white24, color: Colors.white),
          const SizedBox(width: 8),
          Text('$totalScore',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
        ]),
      ),
      bottomNavigationBar: _buildBottomBar(teacher),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('درجات الاختبار', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                ...List.generate(_fields.length, (i) {
                  final (label, max, icon, color) = _fields[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Icon(icon, size: 18, color: color),
                          const SizedBox(width: 6),
                          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          const Spacer(),
                          Text('${_scores[i]} / $max',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: _scores[i] == max ? AppColors.success : AppColors.primary)),
                        ]),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: LinearProgressIndicator(
                            value: max > 0 ? _scores[i] / max : 0,
                            minHeight: 6,
                            backgroundColor: color.withValues(alpha: .1),
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(children: [
                          _ScoreButton(
                            icon: Icons.remove_rounded,
                            onTap: () {
                              if (_scores[i] > 0) {
                                setState(() => _scores[i] = (_scores[i] - 1).clamp(0, max));
                              }
                            },
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: 'الدرجة',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                                  isDense: true,
                                ),
                                style: const TextStyle(fontWeight: FontWeight.w700),
                                onChanged: (v) {
                                  final val = int.tryParse(v);
                                  if (val != null) {
                                    setState(() => _scores[i] = val.clamp(0, max));
                                  }
                                },
                              ),
                            ),
                          ),
                          _ScoreButton(
                            icon: Icons.add_rounded,
                            onTap: () {
                              if (_scores[i] < max) {
                                setState(() => _scores[i] = (_scores[i] + 1).clamp(0, max));
                              }
                            },
                          ),
                        ]),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Notes
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ملاحظات المعلم', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                TextField(
                  controller: _notesCtrl,
                  decoration: const InputDecoration(
                    hintText: 'أضف ملاحظات حول أداء الطالب...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(TeacherProvider teacher) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () {
              final data = {
                'scores': List.generate(_fields.length, (i) => {
                  'subject': _fields[i].$1,
                  'score': _scores[i],
                  'max_score': _fields[i].$2,
                }),
                'notes': _notesCtrl.text,
                'total_score': totalScore,
                'total_possible': totalPossible,
                'percentage': (percentage * 100).round(),
              };
              debugPrint('Saving grades: $data');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم حفظ الدرجات: $totalScore / $totalPossible'),
                  backgroundColor: AppColors.success,
                ),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.save_rounded),
            label: const Text('حفظ الدرجات',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          ),
        ),
      ),
    );
  }
}

class _ScoreButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ScoreButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
    );
  }
}
