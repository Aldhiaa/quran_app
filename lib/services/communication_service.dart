import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../core/api_constants.dart';
import '../models/message_model.dart';
import '../models/announcement_model.dart';
import '../models/notification_model.dart';

class CommunicationService {
  final _storage = const FlutterSecureStorage();
  final http.Client _httpClient;

  CommunicationService({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  List<dynamic> _extractItems(dynamic data) {
    if (data is Map && data.containsKey('data')) return data['data'];
    if (data is List) return data;
    return [];
  }

  Future<List<MessageModel>> getMessages() async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) throw Exception('غير مصرح به');

      final response = await _httpClient.get(
        Uri.parse(ApiConstants.messages),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _extractItems(data).map((json) => MessageModel.fromJson(json)).toList();
      }
      throw Exception('فشل تحميل الرسائل: ${response.statusCode}');
    } on SocketException catch (_) {
      throw Exception('لا يوجد اتصال بالإنترنت');
    } catch (e) {
      throw Exception('خطأ في تحميل الرسائل: $e');
    }
  }

  Future<Map<String, dynamic>> sendMessage({
    required int receiverId,
    required String subject,
    required String body,
  }) async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) throw Exception('غير مصرح به');

      final response = await _httpClient.post(
        Uri.parse(ApiConstants.messages),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'receiver_id': receiverId,
          'subject': subject,
          'body': body,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      final msg = jsonDecode(response.body)['message'] ?? 'فشل إرسال الرسالة';
      throw Exception(msg);
    } on SocketException catch (_) {
      throw Exception('لا يوجد اتصال بالإنترنت');
    } catch (e) {
      throw Exception('خطأ في إرسال الرسالة: $e');
    }
  }

  Future<List<AnnouncementModel>> getAnnouncements() async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) throw Exception('غير مصرح به');

      final response = await _httpClient.get(
        Uri.parse(ApiConstants.announcements),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _extractItems(data).map((json) => AnnouncementModel.fromJson(json)).toList();
      }
      throw Exception('فشل تحميل الإعلانات: ${response.statusCode}');
    } on SocketException catch (_) {
      throw Exception('لا يوجد اتصال بالإنترنت');
    } catch (e) {
      throw Exception('خطأ في تحميل الإعلانات: $e');
    }
  }

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) throw Exception('غير مصرح به');

      final response = await _httpClient.get(
        Uri.parse(ApiConstants.notifications),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _extractItems(data).map((json) => NotificationModel.fromJson(json)).toList();
      }
      throw Exception('فشل تحميل الإشعارات: ${response.statusCode}');
    } on SocketException catch (_) {
      throw Exception('لا يوجد اتصال بالإنترنت');
    } catch (e) {
      throw Exception('خطأ في تحميل الإشعارات: $e');
    }
  }

  Future<void> markNotificationRead(String notificationId) async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) throw Exception('غير مصرح به');

      final response = await _httpClient.post(
        Uri.parse('${ApiConstants.baseUrl}/notifications/$notificationId/read'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('فشل تعيين الإشعار كمقروء: ${response.statusCode}');
      }
    } on SocketException catch (_) {
      throw Exception('لا يوجد اتصال بالإنترنت');
    } catch (e) {
      throw Exception('خطأ في تعيين الإشعار كمقروء: $e');
    }
  }

  Future<void> markAllNotificationsRead() async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) throw Exception('غير مصرح به');

      final response = await _httpClient.post(
        Uri.parse(ApiConstants.markAllNotificationsRead),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('فشل تعيين الكل كمقروء: ${response.statusCode}');
      }
    } on SocketException catch (_) {
      throw Exception('لا يوجد اتصال بالإنترنت');
    } catch (e) {
      throw Exception('خطأ في تعيين الكل كمقروء: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getRecipients() async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) throw Exception('غير مصرح به');

      final response = await _httpClient.get(
        Uri.parse('${ApiConstants.baseUrl}/students'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final items = _extractItems(data);
        return items.map((item) => {
          'id': item['id'] ?? item['user_id'],
          'name': item['name'] ?? item['user']['name'] ?? 'طالب',
          'role': 'student',
        }).toList();
      }
      return [];
    } on SocketException catch (_) {
      throw Exception('لا يوجد اتصال بالإنترنت');
    } catch (e) {
      throw Exception('خطأ في جلب المستخدمين: $e');
    }
  }

  Future<int> getUnreadMessagesCount() async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) throw Exception('غير مصرح به');

      final response = await _httpClient.get(
        Uri.parse(ApiConstants.unreadCountMessages),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['unread_count'] ?? data['count'] ?? 0;
      }
      return 0;
    } on SocketException catch (_) {
      throw Exception('لا يوجد اتصال بالإنترنت');
    } catch (e) {
      throw Exception('خطأ في جلب عدد الرسائل غير المقروءة: $e');
    }
  }

  Future<int> getUnreadNotificationsCount() async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) throw Exception('غير مصرح به');

      final response = await _httpClient.get(
        Uri.parse(ApiConstants.unreadCountNotifications),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['count'] ?? 0;
      }
      return 0;
    } on SocketException catch (_) {
      throw Exception('لا يوجد اتصال بالإنترنت');
    } catch (e) {
      throw Exception('خطأ في جلب عدد الإشعارات غير المقروءة: $e');
    }
  }

  void dispose() {
    _httpClient.close();
  }
}
