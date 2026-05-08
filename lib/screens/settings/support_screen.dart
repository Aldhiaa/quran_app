import 'package:flutter/material.dart';
import '../../widgets/common_widgets.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'المساعدة والدعم',
      body: Column(
        children: [
          InfoTile(
            title: 'الأسئلة الشائعة',
            subtitle: 'إجابات لأكثر الأسئلة تكراراً',
            icon: Icons.quiz_outlined,
            onTap: () => _showFaq(context),
          ),
          const SizedBox(height: 8),
          const InfoTile(title: 'تواصل مع الدعم', subtitle: 'فتح تذكرة دعم فني', icon: Icons.headset_mic_outlined),
          const SizedBox(height: 8),
          const InfoTile(title: 'سياسة الخصوصية', subtitle: 'حماية البيانات والمعلومات', icon: Icons.privacy_tip_outlined),
          const SizedBox(height: 8),
          const InfoTile(title: 'شروط الاستخدام', subtitle: 'ضوابط استخدام التطبيق', icon: Icons.gavel_outlined),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('للتواصل المباشر', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('support@quran.app'),
                  const Text('+966 5X XXX XXXX'),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const PrimaryBottomButton(title: 'إرسال اقتراح'),
    );
  }

  void _showFaq(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الأسئلة الشائعة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 12),
            Text('كيف يمكنني إضافة تقرير يومي؟', style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 4),
            Text('من شاشة المعلم، اختر "إضافة تقرير يومي" ثم املأ البيانات.', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 12),
            Text('كيف يمكنني تغيير كلمة المرور؟', style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 4),
            Text('من الإعدادات > تغيير كلمة المرور.', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
