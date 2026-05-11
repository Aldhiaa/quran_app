import 'package:flutter/material.dart';
import '../supervisor/supervisor_dashboard_screen.dart';
import '../supervisor/supervisor_centers_screen.dart';
import '../supervisor/supervisor_visits_screen.dart';
import '../supervisor/supervisor_reports_screen.dart';
import 'teacher_shell.dart';

class SupervisorShell extends StatefulWidget {
  const SupervisorShell({super.key});
  @override
  State<SupervisorShell> createState() => _SupervisorShellState();
}

class _SupervisorShellState extends State<SupervisorShell> {
  int _index = 0;
  static const _pages = <Widget>[
    SupervisorDashboardScreen(),
    SupervisorCentersScreen(),
    SupervisorVisitsScreen(),
    SupervisorReportsScreen(),
    MoreScreen(role: 'center_supervisor'),
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
