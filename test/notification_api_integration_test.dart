import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mahder_mobile/core/api/api_client.dart';
import 'package:mahder_mobile/features/notification/data/datasources/notification_remote_data_source.dart';

import 'support/fake_api_transport.dart';

void main() {
  test('unread count uses the count endpoint and parses data',
      () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://mobile.test/api'));
    addTearDown(dio.close);
    dio.httpClientAdapter = FakeApiTransport((request) {
      expect(request.method, 'GET');
      expect(request.uri.path, '/api/notifications/count-new');
      return {'data': 7};
    });
    final source = NotificationRemoteDataSource(ApiClient(dio: dio));
    expect(await source.getUnreadCount(), 7);
  });

  test('notifications sends pagination and parses nonempty results', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://mobile.test/api'));
    addTearDown(dio.close);
    dio.httpClientAdapter = FakeApiTransport((request) {
      expect(request.method, 'GET');
      expect(request.uri.path, '/api/notifications/me');
      expect(request.queryParameters, {'page': 2, 'limit': 5});
      return {
        'data': {
          'result': [
            {'id': 'notice-1', 'title': 'Task reviewed', 'is_read': true}
          ],
          'total': 6,
          'page': 2,
          'limit': 5,
          'totalPages': 2,
        },
      };
    });
    final source = NotificationRemoteDataSource(ApiClient(dio: dio));
    final result = await source.getNotifications(page: 2, limit: 5);
    expect(result.page, 2);
    expect(result.limit, 5);
    expect(result.total, 6);
    expect(result.totalPages, 2);
    expect(result.notifications.single.id, 'notice-1');
    expect(result.notifications.single.title, 'Task reviewed');
    expect(result.notifications.single.isRead, isTrue);
  });
}
