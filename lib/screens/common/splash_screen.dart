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

  Future<void> _bootstrap() async {
    if (_started) return;
    _started = true;
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.checkAuthStatus();
    if (!mounted) return;
    if (auth.isAuthenticated) {
      final route = auth.role == 'teacher' ? '/teacher/home' : '/student/home';
      Navigator.pushReplacementNamed(context, route);
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              child: const Icon(Icons.menu_book_rounded, size: 56, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            const Text(
              'تعليم القرآن الكريم',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(strokeWidth: 2.5),
          ],
        ),
      ),
    );
  }
}
