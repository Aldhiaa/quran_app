import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/communication_service.dart';
import '../../models/announcement_model.dart';
import '../../widgets/common_widgets.dart';
import '../../providers/auth_provider.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<AnnouncementModel> _announcements = [];

  @override
  void initState() {
    super.initState();
    _loadAnnouncements();
  }

  Future<void> _loadAnnouncements() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final commService = Provider.of<CommunicationService>(context, listen: false);
      final announcements = await commService.getAnnouncements();
      setState(() {
        _announcements = announcements;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadAnnouncements,
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return AppShell(
            title: 'إعلانات المؤسسة',
            body: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_errorMessage!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                            const SizedBox(height: 16),
                            ElevatedButton(onPressed: _loadAnnouncements, child: const Text('إعادة المحاولة')),
                          ],
                        ),
                      )
                    : _announcements.isEmpty
                        ? const Center(child: Text('لا توجد إعلانات', style: TextStyle(fontSize: 16, color: Colors.grey)))
                        : ListView.builder(
                            itemCount: _announcements.length,
                            itemBuilder: (context, index) {
                              final announcement = _announcements[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: InfoTile(
                                  title: announcement.title,
                                  subtitle: announcement.subtitle ?? announcement.content,
                                  icon: Icons.campaign_outlined,
                                ),
                              );
                            },
                          ),
          );
        },
      ),
    );
  }
}
