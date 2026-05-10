import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _goHome(BuildContext context, String role) {
    final route = role == 'teacher' ? '/teacher/home' : '/student/home';
    Navigator.pushNamedAndRemoveUntil(context, route, (_) => false);
  }

  Future<void> _login(BuildContext context, AuthProvider auth) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) return;
    await auth.login(email, password);
    if (!mounted) return;
    if (auth.isAuthenticated) _goHome(context, auth.role);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              const Text(
                'تعليم القرآن الكريم',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'سجل دخولك للمتابعة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              CustomTextField(
                controller: _emailController,
                label: 'البريد الإلكتروني',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                label: 'كلمة المرور',
                icon: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'تسجيل الدخول',
                isLoading: authProvider.isLoading,
                onPressed: authProvider.isLoading ? () {} : () => _login(context, authProvider),
              ),
              const SizedBox(height: 16),
              if (authProvider.errorMessage != null)
                Text(
                  authProvider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'تجربة بدون اتصال',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.school_outlined),
                    label: const Text('كمعلم'),
                    onPressed: () async {
                      await authProvider.loginDemo(role: 'teacher');
                      if (mounted) _goHome(context, 'teacher');
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.person_outline),
                    label: const Text('كطالب'),
                    onPressed: () async {
                      await authProvider.loginDemo(role: 'student');
                      if (mounted) _goHome(context, 'student');
                    },
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}