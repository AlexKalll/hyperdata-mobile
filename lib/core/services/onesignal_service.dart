import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

/// Centralized service for managing OneSignal push notifications
///
/// This service handles:
/// - OneSignal SDK initialization
/// - User identification and login/logout
/// - User segmentation with tags
/// - Notification permissions
/// - Notification handlers
class OneSignalService {
  static final Logger _logger = Logger();
  static String get _appId => dotenv.env['ONESIGNAL_APP_ID'] ?? '';

  /// Initialize OneSignal SDK
  ///
  /// Should be called once during app startup in main.dart
  /// Sets up notification handlers and permission observers
  static Future<void> initialize() async {
    try {
      _logger.i('Initializing OneSignal...');

      // Initialize OneSignal with app ID
      OneSignal.initialize(_appId);

      // Request notification permission
      await OneSignal.Notifications.requestPermission(true);

      // Set up notification handlers
      _setupNotificationHandlers();

      // Set up permission observer
      _setupPermissionObserver();

      _logger.i('OneSignal initialized successfully');
    } catch (e) {
      _logger.e('Error initializing OneSignal: $e');
    }
  }

  /// Login user with external user ID
  ///
  /// Associates the device with a specific user ID for targeted notifications
  /// Call this after successful user login
  static Future<void> loginUser(String userId) async {
    try {
      _logger.i('Logging in OneSignal user: $userId');
      await OneSignal.login(userId);
      _logger.i('OneSignal user logged in successfully');
    } catch (e) {
      _logger.e('Error logging in OneSignal user: $e');
    }
  }

  /// Logout current user
  ///
  /// Clears the external user ID and user-specific data
  /// Call this when user logs out of the app
  static Future<void> logoutUser() async {
    try {
      _logger.i('Logging out OneSignal user');
      await OneSignal.logout();
      _logger.i('OneSignal user logged out successfully');
    } catch (e) {
      _logger.e('Error logging out OneSignal user: $e');
    }
  }

  /// Set user tags for segmentation
  ///
  /// Tags allow you to send targeted notifications to specific user groups
  /// Example: {'role': 'contributor', 'phone': '+251912345678'}
  static Future<void> setUserTags(Map<String, String> tags) async {
    try {
      _logger.i('Setting OneSignal user tags: $tags');
      await OneSignal.User.addTags(tags);
      _logger.i('OneSignal user tags set successfully');
    } catch (e) {
      _logger.e('Error setting OneSignal user tags: $e');
    }
  }

  /// Remove specific user tags
  static Future<void> removeUserTags(List<String> tagKeys) async {
    try {
      _logger.i('Removing OneSignal user tags: $tagKeys');
      await OneSignal.User.removeTags(tagKeys);
      _logger.i('OneSignal user tags removed successfully');
    } catch (e) {
      _logger.e('Error removing OneSignal user tags: $e');
    }
  }

  /// Check if user has granted notification permission
  static Future<bool> hasNotificationPermission() async {
    try {
      final permission = OneSignal.Notifications.permission;
      return permission;
    } catch (e) {
      _logger.e('Error checking notification permission: $e');
      return false;
    }
  }

  /// Request notification permission from user
  static Future<bool> requestNotificationPermission() async {
    try {
      _logger.i('Requesting notification permission');
      final accepted = await OneSignal.Notifications.requestPermission(true);
      _logger.i('Notification permission: ${accepted ? "granted" : "denied"}');
      return accepted;
    } catch (e) {
      _logger.e('Error requesting notification permission: $e');
      return false;
    }
  }

  /// Opt user in to push notifications
  static Future<void> optInToPushNotifications() async {
    try {
      _logger.i('Opting in to push notifications');
      await OneSignal.User.pushSubscription.optIn();
      _logger.i('Opted in to push notifications successfully');
    } catch (e) {
      _logger.e('Error opting in to push notifications: $e');
    }
  }

  /// Opt user out of push notifications
  static Future<void> optOutOfPushNotifications() async {
    try {
      _logger.i('Opting out of push notifications');
      await OneSignal.User.pushSubscription.optOut();
      _logger.i('Opted out of push notifications successfully');
    } catch (e) {
      _logger.e('Error opting out of push notifications: $e');
    }
  }

  /// Get OneSignal player ID (device ID)
  static String? getPlayerId() {
    try {
      return OneSignal.User.pushSubscription.id;
    } catch (e) {
      _logger.e('Error getting OneSignal player ID: $e');
      return null;
    }
  }

  /// Get external user ID
  static String? getExternalUserId() {
    try {
      // Note: OneSignal SDK v5 doesn't expose externalId directly
      // You can track it separately if needed
      return null;
    } catch (e) {
      _logger.e('Error getting external user ID: $e');
      return null;
    }
  }

  /// Set up notification click handlers
  static void _setupNotificationHandlers() {
    // Handle notification opened (when user taps on notification)
    OneSignal.Notifications.addClickListener((event) {
      _logger.i('Notification clicked: ${event.notification.notificationId}');
      _logger.i('Notification data: ${event.notification.additionalData}');

      // Handle notification click based on additional data
      _handleNotificationClick(event.notification.additionalData);
    });

    // Handle notification received while app is in foreground
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      _logger.i(
          'Notification received in foreground: ${event.notification.notificationId}');

      // You can prevent the notification from displaying by calling:
      // event.preventDefault();

      // Or modify the notification before displaying:
      // event.notification.display();
    });
  }

  /// Set up permission observer
  static void _setupPermissionObserver() {
    OneSignal.Notifications.addPermissionObserver((state) {
      _logger.i('Notification permission changed: $state');
    });
  }

  /// Handle notification click based on additional data
  ///
  /// Override this method to implement custom navigation logic
  /// based on notification data
  static void _handleNotificationClick(Map<String, dynamic>? additionalData) {
    if (additionalData == null) return;

    _logger.i('Processing notification click with data: $additionalData');

    // Example: Navigate to specific screen based on notification type
    // if (additionalData.containsKey('screen')) {
    //   final screen = additionalData['screen'];
    //   Get.toNamed(screen);
    // }

    // Example: Handle task notification
    // if (additionalData.containsKey('taskId')) {
    //   final taskId = additionalData['taskId'];
    //   Get.toNamed(AppRoutes.taskDetail, arguments: {'taskId': taskId});
    // }
  }
}
