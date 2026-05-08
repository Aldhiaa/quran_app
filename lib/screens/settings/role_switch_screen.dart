import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/common_widgets.dart';
import '../../providers/auth_provider.dart';

class RoleSwitchScreen extends StatefulWidget {
  const RoleSwitchScreen({super.key});
  @override
  State<RoleSwitchScreen> createState() => _RoleSwitchScreenState();
}

class _RoleSwitchScreenState extends State<RoleSwitchScreen> {
  String? _selectedRole;
  bool _switching = false;

  @override
  void initState() {
    super.initState();
    _selectedRole = Provider.of<AuthProvider>(context, listen: false).user?.role;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    final currentRole = user?.role ?? '';

    return AppShell(
      title: 'تبديل الدور',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('الدور الحالي: $currentRole\nاختر الدور الذي تريد التبديل إليه.'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (user != null) ...[
            _roleOption('super_admin', 'مدير النظام', 'صلاحية كاملة على جميع المستويات'),
            _roleOption('org_manager', 'مدير المؤسسة', 'إدارة الفروع والمراكز'),
            _roleOption('branch_manager', 'مدير فرع', 'إدارة فرع محدد'),
            _roleOption('center_supervisor', 'مشرف مركز', 'إشراف على مركز تحفيظ'),
            _roleOption('guide', 'موجه', 'زيارات إشرافية وتقارير'),
            _roleOption('teacher', 'مدرس', 'إدارة الحلقات والطلاب'),
            _roleOption('parent', 'ولي أمر', 'متابعة الطلاب'),
          ],
        ],
      ),
      bottomNavigationBar: PrimaryBottomButton(
        title: _switching ? 'جاري التبديل...' : 'تبديل',
        onPressed: _selectedRole != null && !_switching ? () {
          setState(() => _switching = true);
          Future.delayed(const Duration(seconds: 1), () {
            setState(() => _switching = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم التبديل بنجاح')),
            );
          });
        } : null,
      ),
    );
  }

  Widget _roleOption(String value, String title, String subtitle) {
    final isSelected = _selectedRole == value;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Card(
        color: isSelected ? Colors.deepPurple.shade50 : null,
        child: RadioListTile<String>(
          value: value,
          groupValue: _selectedRole,
          onChanged: (v) => setState(() => _selectedRole = v),
          title: Text(title),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        ),
      ),
    );
  }
}
