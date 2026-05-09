import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../services/communication_service.dart';
import '../../models/notification_model.dart';
import '../../widgets/common_widgets.dart';
import '../../providers/auth_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<NotificationModel> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final commService = Provider.of<CommunicationService>(context, listen: false);
      final notifications = await commService.getNotifications();
      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _markAllRead() async {
    try {
      final commService = Provider.of<CommunicationService>(context, listen: false);
      await commService.markAllNotificationsRead();
      await _loadNotifications();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تعيين الكل كمقروء')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadNotifications,
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return AppShell(
            title: 'إشعارات',
            body: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_errorMessage!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                            const SizedBox(height: 16),
                            ElevatedButton(onPressed: _loadNotifications, child: const Text('إعادة المحاولة')),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Row(children: [
                            ChoiceChip(label: const Text('الكل'), selected: true, onSelected: (_) {}),
                            const SizedBox(width: 8),
                            ChoiceChip(label: const Text('غير مقروءة'), selected: false, onSelected: (_) {}),
                          ]),
                          const SizedBox(height: 12),
                          Expanded(
                            child: _notifications.isEmpty
                                ? const Center(child: Text('لا توجد إشعارات', style: TextStyle(fontSize: 16, color: Colors.grey)))
                                : ListView.builder(
                                    itemCount: _notifications.length,
                                    itemBuilder: (context, index) {
                                      final notification = _notifications[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: InfoTile(
                                          title: notification.title,
                                          subtitle: notification.subtitle ?? notification.message ?? '',
                                          icon: Icons.notifications_none_rounded,
                                          color: !notification.isRead ? Colors.blue : AppColors.primary,
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
            bottomNavigationBar: PrimaryBottomButton(
              title: 'تحديد الكل كمقروء',
              onPressed: _markAllRead,
            ),
          );
        },
      ),
    );
  }
}
