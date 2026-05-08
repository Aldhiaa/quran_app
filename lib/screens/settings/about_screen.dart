import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/common_widgets.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'عن التطبيق',
      body: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              CircleAvatar(radius: 36, backgroundColor: AppColors.primary.withOpacity(.1), child: const Icon(Icons.menu_book_rounded, color: AppColors.primary, size: 34)),
              const SizedBox(height: 16),
              Text('مؤسسة المنارة للتنمية', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('الحلقات القرآنية'),
              const SizedBox(height: 16),
              const Text('تطبيق مخصص لإدارة ومتابعة حلقات تحفيظ القرآن الكريم للمعلمين والطلاب.', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              const Text('الإصدار 1.0.0'),
              const SizedBox(height: 16),
              const Text('جميع الحقوق محفوظة © 2026'),
            ],
          ),
        ),
      ),
    );
  }
}
