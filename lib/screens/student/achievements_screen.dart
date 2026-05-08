import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/student_service.dart';
import '../../models/achievement_model.dart';
import '../../widgets/common_widgets.dart';
import '../../providers/auth_provider.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<AchievementModel> _achievements = [];

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final studentService = Provider.of<StudentService>(context, listen: false);
      final achievements = await studentService.getAchievements();
      setState(() {
        _achievements = achievements;
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
      onRefresh: _loadAchievements,
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return AppShell(
            title: 'إنجازاتي',
            body: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_errorMessage!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                            const SizedBox(height: 16),
                            ElevatedButton(onPressed: _loadAchievements, child: const Text('إعادة المحاولة')),
                          ],
                        ),
                      )
                    : _achievements.isEmpty
                        ? const Center(child: Text('لا توجد إنجازات بعد', style: TextStyle(fontSize: 16, color: Colors.grey)))
                        : ListView.builder(
                            itemCount: _achievements.length,
                            itemBuilder: (context, index) {
                              final achievement = _achievements[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: InfoTile(
                                  title: achievement.title,
                                  subtitle: achievement.description ?? '${achievement.awardedBy ?? ''}',
                                  icon: Icons.workspace_premium_rounded,
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
