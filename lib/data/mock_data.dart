import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class MockData {
  static const teacherName = 'أ. فاطمة محمد';
  static const studentName = 'أسماء علي أحمد';

  static final List<Map<String, dynamic>> halaqat = [
    {'title': 'حلقة الحفظ', 'count': 15, 'level': 'المركز الأول'},
    {'title': 'حلقة التجويد', 'count': 10, 'level': 'المركز الأول'},
    {'title': 'حلقة المراجعة', 'count': 12, 'level': 'المركز الأول'},
  ];

  static final List<Map<String, dynamic>> students = [
    {'name': 'أسماء علي أحمد', 'progress': .95, 'parts': '5 أجزاء', 'status': 'ممتاز'},
    {'name': 'إيمان خالد سعيد', 'progress': .78, 'parts': '3 أجزاء', 'status': 'جيد جدًا'},
    {'name': 'نورة محمد سالم', 'progress': .88, 'parts': '4 أجزاء', 'status': 'ممتاز'},
    {'name': 'هدى ياسر حسن', 'progress': .63, 'parts': 'جزآن', 'status': 'جيد'},
    {'name': 'لبان أحمد عبدالله', 'progress': .97, 'parts': '6 أجزاء', 'status': 'ممتاز'},
  ];

  static final List<Map<String, dynamic>> dailyTasks = [
    {'title': 'مراجعة من صفحة 1 إلى 3', 'done': true},
    {'title': 'حفظ 4 صفحات جديدة', 'done': true},
    {'title': 'أذكار بعد الصلاة', 'done': false},
    {'title': 'سلوك: مساعدة في المنزل', 'done': false},
  ];

  static final List<Map<String, dynamic>> weeklyScores = [
    {'title': 'المحافظة على الصلاة', 'score': '10/10'},
    {'title': 'الأدب مع الوالدين', 'score': '9/10'},
    {'title': 'المساعدة في المنزل', 'score': '8/10'},
    {'title': 'تنظيم الوقت للدراسة', 'score': '10/10'},
    {'title': 'حضور الحلقة بانتظام', 'score': '10/10'},
    {'title': 'المراجعة اليومية', 'score': '9/10'},
    {'title': 'الذكر والدعاء', 'score': '8/10'},
  ];

  static final List<Map<String, dynamic>> examCriteria = [
    {'title': 'الحفظ', 'value': '40/50'},
    {'title': 'التلاوة', 'value': '45/50'},
    {'title': 'الأحكام', 'value': '25/30'},
    {'title': 'المتن', 'value': '18/20'},
    {'title': 'السلوك', 'value': '48/50'},
  ];

  static final List<Map<String, dynamic>> notifications = [
    {'title': 'إعلان جديد', 'subtitle': 'مسابقة حفظ جديدة', 'color': AppColors.warning},
    {'title': 'تذكير', 'subtitle': 'أكملي إرسال متابعة اليوم', 'color': AppColors.danger},
    {'title': 'تنبيه جديد', 'subtitle': 'تم اعتماد نتيجة طالبة', 'color': AppColors.info},
    {'title': 'رسالة جديدة', 'subtitle': 'رسالة خاصة من المشرفة', 'color': AppColors.success},
  ];

  static final List<Map<String, dynamic>> messages = [
    {'name': 'المعلمة فاطمة محمد', 'last': 'أحسنتِ اليوم 🌟', 'unread': true},
    {'name': 'أ. سعاد علي', 'last': 'سيتم رفع التقرير غدًا', 'unread': false},
    {'name': 'أ. هدى ياسر', 'last': 'تابعي مراجعة الصفحات', 'unread': false},
  ];

  static final List<String> reviewItems = [
    'من صفحة 1 إلى 3',
    'من صفحة 6 إلى 9',
    'من صفحة 10 إلى 12',
    'من صفحة 13 إلى 15',
  ];
}
