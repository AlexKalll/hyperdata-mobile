import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mahder_mobile/core/api/api_client.dart';
import 'package:mahder_mobile/features/home/data/datasources/task_remote_data_source.dart';
import 'package:mahder_mobile/features/home/data/models/task.dart';
import 'package:mahder_mobile/features/home/data/models/task_detail.dart';

class RecordingApiClient implements ApiClient {
  String? endpoint;
  dynamic payload;

  @override
  Future<Response> post(String endpoint, {dynamic data, Options? options}) async {
    this.endpoint = endpoint;
    payload = data;
    return Response(requestOptions: RequestOptions(path: endpoint), statusCode: 200);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('text submissions send only attempts and is_test, not batch', () async {
    final client = RecordingApiClient();
    final source = TaskRemoteDataSource(client);

    for (final isTest in [false, true]) {
      await source.submitTextTask('task-1', 3, isTest, {'micro-1': 'Answer'});

      expect(client.endpoint, '/task-distribution/task-1/contribute');
      expect(client.payload, {
        'is_test': isTest,
        'attempts': [
          {'micro_task_id': 'micro-1', 'text_data_set': 'Answer'},
        ],
      });
    }
  });

  test('task detail reads deadline', () {
    final detail = TaskDetail.fromJson({'deadline': '2026-09-30T12:00:00Z'});
    expect(detail.task.dueDate, DateTime.utc(2026, 9, 30, 12));
  });

  test('task list still reads dead_line', () {
    final task = Task.fromJson({'dead_line': '2026-09-30T12:00:00Z'});
    expect(task.dueDate, DateTime.utc(2026, 9, 30, 12));
  });

  test('missing and invalid deadlines remain nullable', () {
    expect(Task.fromJson({}).dueDate, isNull);
    expect(TaskDetail.fromJson({'deadline': null}).task.dueDate, isNull);
    expect(Task.fromJson({'dead_line': 'invalid'}).dueDate, isNull);
    expect(TaskDetail.fromJson({'deadline': 'invalid'}).task.dueDate, isNull);
  });
}
