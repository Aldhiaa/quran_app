import 'package:flutter/material.dart';
import '../guide/guide_dashboard_screen.dart';
import '../guide/guide_centers_screen.dart';
import '../guide/guide_visits_screen.dart';
import '../guide/guide_reports_screen.dart';
import 'teacher_shell.dart';

class GuideShell extends StatefulWidget {
  const GuideShell({super.key});
  @override
  State<GuideShell> createState() => _GuideShellState();
}

class _GuideShellState extends State<GuideShell> {
  int _index = 0;
  static const _pages = <Widget>[
    GuideDashboardScreen(),
    GuideCentersScreen(),
    GuideVisitsScreen(),
    GuideReportsScreen(),
    MoreScreen(role: 'guide'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.business_rounded), label: 'المراكز'),
          NavigationDestination(icon: Icon(Icons.event_available_rounded), label: 'الزيارات'),
          NavigationDestination(icon: Icon(Icons.assessment_rounded), label: 'التقارير'),
          NavigationDestination(icon: Icon(Icons.more_horiz_rounded), label: 'المزيد'),
        ],
      ),
    );
  }
}
