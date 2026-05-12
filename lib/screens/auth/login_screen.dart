import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _obscure = true;

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
    final route = switch (role) {
      'teacher' => '/teacher/home',
      'center_supervisor' => '/supervisor/home',
      'guide' => '/guide/home',
      _ => '/student/home',
    };
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

  Future<void> _demo(BuildContext context, AuthProvider auth, String role) async {
    await auth.loginDemo(role: role);
    if (!mounted) return;
    _goHome(context, role);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Deep green header
          Container(
            height: 320,
            decoration: const BoxDecoration(
              gradient: AppColors.headerGradient,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 22, 24, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .08),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.accentGold, width: 1.6),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.mosque_rounded, color: AppColors.accentGold, size: 40),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'نظام المنارة',
                      style: TextStyle(
                        color: AppColors.accentGold,
                        fontWeight: FontWeight.w800,
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'منظومة إدارة الحلقات القرآنية',
                      style: TextStyle(color: Colors.white.withValues(alpha: .85), fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 270, 20, 24),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .06),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'تسجيل الدخول',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.text),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'مرحباً بك، يرجى تسجيل الدخول للمتابعة',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.muted, fontSize: 12.5),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'البريد الإلكتروني أو رقم الجوال',
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton(onPressed: () {}, child: const Text('نسيت كلمة المرور؟')),
                    ),
                    const SizedBox(height: 4),
                    ElevatedButton(
                      onPressed: authProvider.isLoading
                          ? null
                          : () => _login(context, authProvider),
                      child: authProvider.isLoading
                          ? const SizedBox(
                              width: 20, height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text('تسجيل الدخول'),
                    ),
                    if (authProvider.errorMessage != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        authProvider.errorMessage!,
                        style: const TextStyle(color: AppColors.danger),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 14),
                    Row(children: [
                      const Expanded(child: Divider(color: AppColors.border)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text('أو دخول تجريبي',
                            style: TextStyle(color: AppColors.muted.withValues(alpha: .9), fontSize: 12)),
                      ),
                      const Expanded(child: Divider(color: AppColors.border)),
                    ]),
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _demo(context, authProvider, 'teacher'),
                          child: const Text('معلم'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _demo(context, authProvider, 'student'),
                          child: const Text('طالب'),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    Row(children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _demo(context, authProvider, 'center_supervisor'),
                          child: const Text('مشرف مركز'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _demo(context, authProvider, 'guide'),
                          child: const Text('موجهة'),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
