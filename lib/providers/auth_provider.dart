import 'package:flutter/foundation.dart';

import '../models/auth/auth_user.dart';
import '../services/auth_service.dart';
import '../services/communication_service.dart';
import '../services/student_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  final StudentService _studentService;
  final CommunicationService _communicationService;

  bool _isLoading = false;
  bool _isAuthenticated = false;
  bool _isDemo = false;
  String? _errorMessage;
  AuthUser? _user;

  AuthProvider({
    AuthService? authService,
    StudentService? studentService,
    CommunicationService? communicationService,
  })  : _authService = authService ?? AuthService(),
        _studentService = studentService ?? StudentService(),
        _communicationService = communicationService ?? CommunicationService();

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  bool get isDemo => _isDemo;
  String? get errorMessage => _errorMessage;
  AuthUser? get user => _user;
  String get role => _user?.role ?? 'guest';

  bool get isStudent => role == 'student';
  bool get isTeacher => role == 'teacher';
  bool get isSupervisor => role == 'center_supervisor';
  bool get isGuide => role == 'guide';

  StudentService get studentService => _studentService;
  CommunicationService get communicationService => _communicationService;

  Future<void> login(String email, String password) async {
    _setLoading();

    try {
      final authData = await _authService.login(email, password);
      final userData = await _authService.getCurrentUser();
      _user = AuthUser.fromJson(userData ?? authData);
      _isAuthenticated = true;
      _isDemo = false;
    } catch (e) {
      _errorMessage = e.toString();
      _isAuthenticated = false;
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginDemo({String role = 'student'}) async {
    _setLoading();
    await Future.delayed(const Duration(milliseconds: 250));

    _user = AuthUser(
      id: 1,
      name: switch (role) {
        'teacher' => 'أ. سعد القحطاني',
        'center_supervisor' => 'أ. محمد العمري',
        'guide' => 'أ. منى السبيعي',
        _ => 'أحمد العتيبي',
      },
      email: 'demo@quran.app',
      role: role,
      centerIds: role == 'center_supervisor' ? const [1, 2] : const [],
      circleIds: role == 'teacher' || role == 'student' ? const [1] : const [],
    );
    _isAuthenticated = true;
    _isDemo = true;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshUser() async {
    if (_isDemo) return;
    try {
      final userData = await _authService.getCurrentUser();
      if (userData != null) {
        _user = AuthUser.fromJson(userData);
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> logout() async {
    if (!_isDemo) await _authService.logout();
    _isAuthenticated = false;
    _isDemo = false;
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    _setLoading();

    try {
      final userData = await _authService.getCurrentUser();
      if (userData != null) {
        _user = AuthUser.fromJson(userData);
        _isAuthenticated = true;
      } else {
        _isAuthenticated = false;
        _user = null;
      }
    } catch (_) {
      _isAuthenticated = false;
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _setLoading() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authService.dispose();
    _studentService.dispose();
    _communicationService.dispose();
    super.dispose();
  }
}

