import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/communication_service.dart';
import '../../models/message_model.dart';
import '../../widgets/common_widgets.dart';
import '../../providers/auth_provider.dart';

class PrivateMessagesScreen extends StatefulWidget {
  const PrivateMessagesScreen({super.key});

  @override
  State<PrivateMessagesScreen> createState() => _PrivateMessagesScreenState();
}

class _PrivateMessagesScreenState extends State<PrivateMessagesScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<MessageModel> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final commService = Provider.of<CommunicationService>(context, listen: false);
      final messages = await commService.getMessages();
      setState(() {
        _messages = messages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _showComposeDialog() {
    showDialog(
      context: context,
      builder: (ctx) => _ComposeMessageDialog(
        onSent: _loadMessages,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadMessages,
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return AppShell(
            title: 'رسائل خاصة',
            body: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_errorMessage!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                            const SizedBox(height: 16),
                            ElevatedButton(onPressed: _loadMessages, child: const Text('إعادة المحاولة')),
                          ],
                        ),
                      )
                    : _messages.isEmpty
                        ? const Center(child: Text('لا توجد رسائل', style: TextStyle(fontSize: 16, color: Colors.grey)))
                        : ListView.builder(
                            itemCount: _messages.length,
                            itemBuilder: (context, index) {
                              final message = _messages[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Card(
                                  child: ListTile(
                                    leading: CircleAvatar(child: Text(message.senderName.isNotEmpty ? message.senderName[0] : '?')),
                                    title: Text(message.senderName),
                                    subtitle: Text(message.content),
                                    trailing: !message.isRead
                                        ? const CircleAvatar(radius: 6, backgroundColor: Colors.green)
                                        : null,
                                  ),
                                ),
                              );
                            },
                          ),
            bottomNavigationBar: PrimaryBottomButton(
              title: 'رسالة جديدة',
              onPressed: _showComposeDialog,
            ),
          );
        },
      ),
    );
  }
}

class _ComposeMessageDialog extends StatefulWidget {
  final VoidCallback onSent;
  const _ComposeMessageDialog({required this.onSent});

  @override
  State<_ComposeMessageDialog> createState() => _ComposeMessageDialogState();
}

class _ComposeMessageDialogState extends State<_ComposeMessageDialog> {
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _recipientController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _sending = true);

    try {
      final commService = Provider.of<CommunicationService>(context, listen: false);
      final receiverId = int.tryParse(_recipientController.text.trim());
      if (receiverId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('معرف المستخدم غير صالح')),
        );
        return;
      }

      await commService.sendMessage(
        receiverId: receiverId,
        subject: _subjectController.text.trim(),
        body: _bodyController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إرسال الرسالة')),
        );
        widget.onSent();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل الإرسال: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text('رسالة جديدة'),
        content: Form(
          key: _formKey,
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _recipientController,
                  decoration: const InputDecoration(
                    labelText: 'معرف المستخدم',
                    hintText: 'أدخل رقم المستخدم',
                    prefixIcon: Icon(Icons.person),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || v.trim().isEmpty ? 'الرجاء إدخال معرف المستخدم' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _subjectController,
                  decoration: const InputDecoration(
                    labelText: 'الموضوع',
                    hintText: 'عنوان الرسالة',
                    prefixIcon: Icon(Icons.subject),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? 'الرجاء إدخال الموضوع' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _bodyController,
                  decoration: const InputDecoration(
                    labelText: 'النص',
                    hintText: 'محتوى الرسالة',
                    prefixIcon: Icon(Icons.message),
                  ),
                  maxLines: 4,
                  validator: (v) => v == null || v.trim().isEmpty ? 'الرجاء إدخال نص الرسالة' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _sending ? null : () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: _sending ? null : _send,
            child: _sending
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('إرسال'),
          ),
        ],
      ),
    );
  }
}
