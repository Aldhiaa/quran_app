import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';
import '../services/student_service.dart';
import '../services/communication_service.dart';
import '../models/student_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  final StudentService _studentService;
  final CommunicationService _communicationService;

  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _errorMessage;
  StudentModel? _user;

  AuthProvider({
    AuthService? authService,
    StudentService? studentService,
    CommunicationService? communicationService,
  })  : _authService = authService ?? AuthService(),
        _studentService = studentService ?? StudentService(),
        _communicationService = communicationService ?? CommunicationService();

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;
  StudentModel? get user => _user;

  StudentService get studentService => _studentService;
  CommunicationService get communicationService => _communicationService;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final authData = await _authService.login(email, password);
      final userData = await _authService.getCurrentUser();

      if (userData != null) {
        _user = StudentModel.fromJson(userData);
        _isAuthenticated = true;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginDemo() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _user = StudentModel(
      id: 1,
      name: 'مستخدم تجريبي',
      email: 'demo@quran.app',
      progress: 0.65,
      parts: '15',
      status: 'نشط',
      role: 'student',
    );
    _isAuthenticated = true;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    _isAuthenticated = false;
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userData = await _authService.getCurrentUser();
      if (userData != null) {
        _user = StudentModel.fromJson(userData);
        _isAuthenticated = true;
      } else {
        _isAuthenticated = false;
        _user = null;
      }
    } catch (e) {
      _isAuthenticated = false;
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authService.dispose();
    _studentService.dispose();
    _communicationService.dispose();
    super.dispose();
  }
}