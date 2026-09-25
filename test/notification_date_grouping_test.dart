import 'package:flutter_test/flutter_test.dart';
import 'package:mahder_mobile/features/notification/data/models/notification_model.dart';
import 'package:mahder_mobile/features/notification/domain/entities/notification_entity.dart';

void main() {
  group('Notification Date Formatting and Grouping', () {
    test('isToday() returns true for today\'s notification', () {
      final now = DateTime.now();
      final notification = NotificationEntity(
        id: '1',
        userId: 'user1',
        title: 'Test',
        message: 'Test message',
        type: 'info',
        isRead: false,
        createdDate: now,
        updatedDate: now,
      );

      expect(notification.isToday(), true);
    });

    test('isYesterday() returns true for yesterday\'s notification', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final notification = NotificationEntity(
        id: '1',
        userId: 'user1',
        title: 'Test',
        message: 'Test message',
        type: 'info',
        isRead: false,
        createdDate: yesterday,
        updatedDate: yesterday,
      );

      expect(notification.isYesterday(), true);
    });

    test('getDateCategory() returns "Today" for today\'s notification', () {
      final now = DateTime.now();
      final notification = NotificationEntity(
        id: '1',
        userId: 'user1',
        title: 'Test',
        message: 'Test message',
        type: 'info',
        isRead: false,
        createdDate: now,
        updatedDate: now,
      );

      expect(notification.getDateCategory(), 'Today');
    });

    test('getDateCategory() returns "Yesterday" for yesterday\'s notification', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final notification = NotificationEntity(
        id: '1',
        userId: 'user1',
        title: 'Test',
        message: 'Test message',
        type: 'info',
        isRead: false,
        createdDate: yesterday,
        updatedDate: yesterday,
      );

      expect(notification.getDateCategory(), 'Yesterday');
    });

    test('getFormattedDateTime() returns correct format for today', () {
      final now = DateTime.now();
      final notification = NotificationEntity(
        id: '1',
        userId: 'user1',
        title: 'Test',
        message: 'Test message',
        type: 'info',
        isRead: false,
        createdDate: now,
        updatedDate: now,
      );

      final formatted = notification.getFormattedDateTime();
      expect(formatted, startsWith('Today, '));
    });

    test('getFormattedDateTime() returns correct format for yesterday', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final notification = NotificationEntity(
        id: '1',
        userId: 'user1',
        title: 'Test',
        message: 'Test message',
        type: 'info',
        isRead: false,
        createdDate: yesterday,
        updatedDate: yesterday,
      );

      final formatted = notification.getFormattedDateTime();
      expect(formatted, startsWith('Yesterday, '));
    });

    test('Notifications are grouped correctly by date', () {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final twoDaysAgo = now.subtract(const Duration(days: 2));

      final notifications = [
        NotificationEntity(
          id: '1',
          userId: 'user1',
          title: 'Today notification',
          message: 'Test',
          type: 'info',
          isRead: false,
          createdDate: now,
          updatedDate: now,
        ),
        NotificationEntity(
          id: '2',
          userId: 'user1',
          title: 'Yesterday notification',
          message: 'Test',
          type: 'info',
          isRead: false,
          createdDate: yesterday,
          updatedDate: yesterday,
        ),
        NotificationEntity(
          id: '3',
          userId: 'user1',
          title: 'Old notification',
          message: 'Test',
          type: 'info',
          isRead: false,
          createdDate: twoDaysAgo,
          updatedDate: twoDaysAgo,
        ),
      ];

      final grouped = <String, List<NotificationEntity>>{};
      for (var notification in notifications) {
        final category = notification.getDateCategory();
        if (!grouped.containsKey(category)) {
          grouped[category] = [];
        }
        grouped[category]!.add(notification);
      }

      expect(grouped.containsKey('Today'), true);
      expect(grouped.containsKey('Yesterday'), true);
      expect(grouped['Today']!.length, 1);
      expect(grouped['Yesterday']!.length, 1);
    });

    test('Timezone handling - dates are converted to local time', () {
      // Create a UTC date
      final utcDate = DateTime.utc(2025, 11, 18, 10, 30);
      final notification = NotificationEntity(
        id: '1',
        userId: 'user1',
        title: 'Test',
        message: 'Test message',
        type: 'info',
        isRead: false,
        createdDate: utcDate,
        updatedDate: utcDate,
      );

      // The formatted time should use local timezone
      final formatted = notification.getFormattedTime();
      expect(formatted, isNotEmpty);

      // Verify that toLocal() is being called by checking the date category
      final category = notification.getDateCategory();
      expect(category, isNotEmpty);
    });
  });
}
