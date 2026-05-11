import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _started = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  String _routeFor(String role) {
    switch (role) {
      case 'teacher':
        return '/teacher/home';
      case 'center_supervisor':
        return '/supervisor/home';
      case 'guide':
        return '/guide/home';
      default:
        return '/student/home';
    }
  }

  Future<void> _bootstrap() async {
    if (_started) return;
    _started = true;
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.checkAuthStatus();
    if (!mounted) return;
    if (auth.isAuthenticated) {
      Navigator.pushReplacementNamed(context, _routeFor(auth.role));
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.headerGradient),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .08),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.accentGold, width: 1.6),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.mosque_rounded, size: 50, color: AppColors.accentGold),
                ),
                const SizedBox(height: 18),
                const Text('حلق القرآن',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.accentGold,
                    )),
                const SizedBox(height: 4),
                const Text('منظومة إدارة الحلقات القرآنية',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 28),
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    color: AppColors.accentGold,
                    strokeWidth: 2.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
