import 'package:flutter/material.dart';
import '../../widgets/common_widgets.dart';

class ScreenCatalogScreen extends StatelessWidget {
  const ScreenCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final teacher = [
      ['لوحة المعلم', 'الواجهة الرئيسية للمعلم', 'dashboard_customize', '/teacher/dashboard'],
      ['حلقاتي', 'إدارة الحلقات والفصول', 'menu_book_rounded', '/teacher/halaqat'],
      ['طلابي', 'قائمة الطلاب', 'groups_rounded', '/teacher/students'],
      ['تفاصيل الطالب', 'تقدم وحضور وملاحظات', 'person_rounded', '/teacher/student-detail'],
      ['المتابعة اليومية', 'الحضور والمهام اليومية', 'today_rounded', '/teacher/daily-followup'],
      ['إضافة تقرير يومي', 'إدخال حفظ ومراجعة وتلاوة', 'edit_note_rounded', '/teacher/daily-report-entry'],
      ['التقييم الأسبوعي', 'تقييم السلوك والالتزام', 'rule_rounded', '/teacher/weekly-evaluation'],
      ['الاختبارات الشهرية', 'إدارة الاختبارات الشهرية', 'fact_check_rounded', '/teacher/monthly-exams'],
      ['إضافة اختبار شهري', 'إنشاء اختبار جديد', 'add_task_rounded', '/teacher/monthly-exam-create'],
      ['نتائج الاختبار', 'قائمة النتائج', 'leaderboard_rounded', '/teacher/exam-results'],
      ['تفاصيل النتيجة', 'تفاصيل نتيجة طالب', 'analytics_rounded', '/teacher/exam-result-detail'],
      ['إدخال الدرجات', 'إدخال درجات الاختبار', 'checklist_rounded', '/teacher/grades-entry'],
      ['مركز التقارير', 'التقارير اليومية والأسبوعية والشهرية', 'assessment_rounded', '/teacher/reports-center'],
    ];

    final common = [
      ['التواصل', 'محور الرسائل والإعلانات', 'hub_rounded', '/common/communication'],
      ['إعلانات المؤسسة', 'الإعلانات العامة', 'campaign_rounded', '/common/announcements'],
      ['مجموعات الحلقات', 'محادثات المجموعات', 'forum_rounded', '/common/groups'],
      ['رسائل خاصة', 'دردشة فردية', 'mail_rounded', '/common/private-messages'],
      ['الإشعارات', 'جميع التنبيهات', 'notifications_active_rounded', '/common/notifications'],
    ];

    final student = [
      ['لوحة الطالب', 'الرئيسية الخاصة بالطالب', 'dashboard_rounded', '/student/dashboard'],
      ['المهام اليومية', 'قائمة المهام المنجزة والمنتظرة', 'task_alt_rounded', '/student/daily-tasks'],
      ['تقدمي', 'الإحصاءات والمؤشرات', 'show_chart_rounded', '/student/progress'],
      ['المراجعة', 'جدول المراجعات', 'auto_stories_rounded', '/student/review'],
      ['نتائجي', 'الاختبارات والتقييمات', 'query_stats_rounded', '/student/results'],
      ['حضوري', 'متابعة الحضور والغياب', 'how_to_reg_rounded', '/student/attendance'],
      ['أهدافي', 'الأهداف الحالية والقادمة', 'flag_rounded', '/student/goals'],
      ['ملف الحفظ', 'ملف الحفظ والمراجعة', 'folder_copy_rounded', '/student/memorization-file'],
      ['إنجازاتي', 'الشارات والإنجازات', 'workspace_premium_rounded', '/student/achievements'],
    ];

    final settings = [
      ['الإعدادات', 'إعدادات التطبيق العامة', 'settings_rounded', '/settings/app'],
      ['الملف الشخصي', 'بيانات المستخدم', 'badge_rounded', '/settings/profile'],
      ['الدعم والمساعدة', 'الأسئلة والتواصل مع الدعم', 'support_agent_rounded', '/settings/support'],
      ['عن التطبيق', 'معلومات التطبيق', 'info_rounded', '/settings/about'],
      ['تبديل الدور', 'التحويل بين معلم ومشرف وموجّه', 'published_with_changes_rounded', '/settings/role-switch'],
    ];

    return AppShell(
      title: 'جميع شاشات التطبيق',
      body: ListView(
        children: [
          const AppSectionTitle(title: 'شاشات المعلم'),
          ...teacher.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ScreenMenuCard(title: e[0] as String, subtitle: e[1] as String, icon: _icon(e[2] as String), route: e[3] as String),
              )),
          const SizedBox(height: 14),
          const AppSectionTitle(title: 'شاشات مشتركة'),
          ...common.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ScreenMenuCard(title: e[0] as String, subtitle: e[1] as String, icon: _icon(e[2] as String), route: e[3] as String),
              )),
          const SizedBox(height: 14),
          const AppSectionTitle(title: 'شاشات الطالب'),
          ...student.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ScreenMenuCard(title: e[0] as String, subtitle: e[1] as String, icon: _icon(e[2] as String), route: e[3] as String),
              )),
          const SizedBox(height: 14),
          const AppSectionTitle(title: 'الإعدادات والمزيد'),
          ...settings.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ScreenMenuCard(title: e[0] as String, subtitle: e[1] as String, icon: _icon(e[2] as String), route: e[3] as String),
              )),
        ],
      ),
    );
  }

  static IconData _icon(String key) {
    switch (key) {
      case 'dashboard_customize': return Icons.dashboard_customize_rounded;
      case 'menu_book_rounded': return Icons.menu_book_rounded;
      case 'groups_rounded': return Icons.groups_rounded;
      case 'person_rounded': return Icons.person_rounded;
      case 'today_rounded': return Icons.today_rounded;
      case 'edit_note_rounded': return Icons.edit_note_rounded;
      case 'rule_rounded': return Icons.rule_rounded;
      case 'fact_check_rounded': return Icons.fact_check_rounded;
      case 'add_task_rounded': return Icons.add_task_rounded;
      case 'leaderboard_rounded': return Icons.leaderboard_rounded;
      case 'analytics_rounded': return Icons.analytics_rounded;
      case 'checklist_rounded': return Icons.checklist_rounded;
      case 'assessment_rounded': return Icons.assessment_rounded;
      case 'hub_rounded': return Icons.hub_rounded;
      case 'campaign_rounded': return Icons.campaign_rounded;
      case 'forum_rounded': return Icons.forum_rounded;
      case 'mail_rounded': return Icons.mail_rounded;
      case 'notifications_active_rounded': return Icons.notifications_active_rounded;
      case 'dashboard_rounded': return Icons.dashboard_rounded;
      case 'task_alt_rounded': return Icons.task_alt_rounded;
      case 'show_chart_rounded': return Icons.show_chart_rounded;
      case 'auto_stories_rounded': return Icons.auto_stories_rounded;
      case 'query_stats_rounded': return Icons.query_stats_rounded;
      case 'how_to_reg_rounded': return Icons.how_to_reg_rounded;
      case 'flag_rounded': return Icons.flag_rounded;
      case 'folder_copy_rounded': return Icons.folder_copy_rounded;
      case 'workspace_premium_rounded': return Icons.workspace_premium_rounded;
      case 'settings_rounded': return Icons.settings_rounded;
      case 'badge_rounded': return Icons.badge_rounded;
      case 'support_agent_rounded': return Icons.support_agent_rounded;
      case 'info_rounded': return Icons.info_rounded;
      default: return Icons.circle;
    }
  }
}
