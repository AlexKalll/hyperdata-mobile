import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart' hide Response;
import 'package:mahder_mobile/core/api/api_client.dart';
import 'package:mahder_mobile/core/api/api_interceptor.dart';
import 'package:mahder_mobile/core/cache/local_storage.dart';
import 'package:mahder_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mahder_mobile/routes/app_routes.dart';

import 'support/fake_api_transport.dart';

class MemoryTokenStorage extends LocalStorage {
  String accessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjF9.signature';
  String refreshToken = 'old-refresh';

  @override
  Future<String?> getAccessToken() async => accessToken;
  @override
  Future<String?> getRefreshToken() async => refreshToken;
  @override
  Future<void> saveTokens(
      {required String accessToken, required String refreshToken}) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }
}

void main() {
  setUp(
      () => dotenv.testLoad(fileInput: 'API_BASE_URL=https://mobile.test/api'));

  for (final status in [200, 201]) {
    test('interceptor rotates tokens and resumes request on HTTP $status',
        () async {
      final storage = MemoryTokenStorage();
      final refreshDio = Dio();
      final dio = Dio(BaseOptions(baseUrl: 'https://mobile.test/api'));
      addTearDown(refreshDio.close);
      addTearDown(dio.close);
      var refreshCalls = 0;
      refreshDio.httpClientAdapter = FakeApiTransport((request) {
        refreshCalls++;
        expect(request.method, 'POST');
        expect(request.uri.toString(),
            'https://mobile.test/api/iam/auth/refresh-token');
        expect(request.data, {'refresh_token': 'old-refresh'});
        return {
          'data': {'access_token': 'new-access', 'refresh_token': 'new-refresh'}
        };
      }, statusCode: status);
      dio.interceptors
          .add(ApiInterceptor(localStorage: storage, refreshDio: refreshDio));
      dio.httpClientAdapter = FakeApiTransport((request) {
        expect(request.headers['Authorization'], 'Bearer new-access');
        return {'data': 7};
      });

      expect((await dio.get('/notifications/count-new')).data, {'data': 7});
      expect(refreshCalls, 1);
      expect(storage.accessToken, 'new-access');
      expect(storage.refreshToken, 'new-refresh');
    });
  }

  test('explicit auth refresh reads data.refresh_token on HTTP 201', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://mobile.test/api'));
    addTearDown(dio.close);
    dio.httpClientAdapter = FakeApiTransport((request) {
      expect(request.uri.path, '/api/iam/auth/refresh-token');
      expect(request.data, {'refresh_token': 'old-refresh'});
      return {
        'data': {'access_token': 'new-access', 'refresh_token': 'new-refresh'}
      };
    }, statusCode: 201);
    expect(
        await AuthRemoteDataSource(ApiClient(dio: dio))
            .refreshToken('old-refresh'),
        {'accessToken': 'new-access', 'refreshToken': 'new-refresh'});
  });

  for (final status in [201, 204, 401]) {
    testWidgets(
        'invalid refresh HTTP $status rejects without overwriting tokens',
        (tester) async {
      addTearDown(Get.reset);
      await tester.pumpWidget(GetMaterialApp(
        home: const Scaffold(body: Text('Protected screen')),
        getPages: [
          GetPage(
              name: AppRoutes.login,
              page: () => const Scaffold(body: Text('Login')))
        ],
      ));
      final storage = MemoryTokenStorage();
      final oldAccess = storage.accessToken;
      final refreshDio = Dio();
      final dio = Dio(BaseOptions(baseUrl: 'https://mobile.test/api'));
      addTearDown(refreshDio.close);
      addTearDown(dio.close);
      refreshDio.httpClientAdapter = FakeApiTransport(
          (_) => {
                'data': {
                  'access_token': 'new-access',
                  'new_refresh_token': 'wrong-key'
                },
              },
          statusCode: status);
      dio.interceptors
          .add(ApiInterceptor(localStorage: storage, refreshDio: refreshDio));
      var protectedCalls = 0;
      dio.httpClientAdapter = FakeApiTransport((_) {
        protectedCalls++;
        return {};
      });
      await tester.runAsync(() async {
        await expectLater(
            dio.get('/notifications/count-new'), throwsA(isA<DioException>()));
      });
      await tester.pumpAndSettle();
      expect(find.text('Login'), findsOneWidget);
      expect(protectedCalls, 0);
      expect(storage.accessToken, oldAccess);
      expect(storage.refreshToken, 'old-refresh');
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
}
