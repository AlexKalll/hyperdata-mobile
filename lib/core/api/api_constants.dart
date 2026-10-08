import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://mahder-api.duckdns.org/api';

  // Notification endpoints
  static const String notificationsMe = "/notifications/me";
  static const String notificationsCountNew = "/notifications/count-new";
  static const String notificationsMarkAsRead = "/notifications"; // + /:id/read
  static const String notificationsMarkAllAsRead = "/notifications/read-all";
}
