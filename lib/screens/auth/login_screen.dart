import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common_widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

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
                'القرآن الكريم',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
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
                controller: emailController,
                label: 'البريد الإلكتروني',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: passwordController,
                label: 'كلمة المرور',
                icon: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 24),
              if (authProvider.isLoading)
                const Center(child: CircularProgressIndicator())
              else
                CustomButton(
                  text: 'تسجيل الدخول',
                  onPressed: () {
                    final email = emailController.text.trim();
                    final password = passwordController.text;
                    if (email.isNotEmpty && password.isNotEmpty) {
                      authProvider.login(email, password);
                    }
                  },
                ),
              const SizedBox(height: 16),
              if (authProvider.errorMessage != null)
                Text(
                  authProvider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  authProvider.login('admin@quran.app', 'password123');
                },
                child: const Text('تجربة الحساب التجريبي'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}