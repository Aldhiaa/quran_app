class CommunicationEndpoints {
  const CommunicationEndpoints._();

  static const messages = '/messages';
  static const announcements = '/announcements';
  static const unreadMessagesCount = '/messages-unread-count';
  static const notifications = '/notifications';
  static const unreadNotificationsCount = '/notifications/unread-count';
  static const readAllNotifications = '/notifications/read-all';

  static String message(int id) => '/messages/$id';
  static String readMessage(int id) => '/messages/$id/read';
  static String notificationRead(String id) => '/notifications/$id/read';
}

