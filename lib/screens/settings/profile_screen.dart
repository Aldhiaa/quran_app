import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/common_widgets.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        final user = auth.user;
        return AppShell(
          title: 'الملف الشخصي',
          body: Column(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: Colors.deepPurple.shade100,
                child: Text(
                  (user?.name ?? '?').substring(0, 1),
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                ),
              ),
              const SizedBox(height: 6),
              Text(user?.role ?? '', style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'الاسم', prefixIcon: Icon(Icons.person_outline)),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'البريد الإلكتروني', prefixIcon: Icon(Icons.email_outlined)),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.badge_outlined),
                  title: const Text('الدور'),
                  trailing: Text(user?.role ?? '--'),
                ),
              ),
            ],
          ),
          bottomNavigationBar: PrimaryBottomButton(
            title: _saving ? 'جاري الحفظ...' : 'حفظ التغييرات',
            onPressed: _saving ? null : () {},
          ),
        );
      },
    );
  }
}
