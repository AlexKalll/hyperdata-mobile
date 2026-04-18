import 'dart:io';

import 'package:dio/dio.dart';
import 'package:leyu_mobile/core/utils/message.dart';
import 'package:leyu_mobile/features/home/data/models/task.dart';
import 'package:leyu_mobile/features/home/data/models/task_detail.dart';

import '../../../../core/api/api_client.dart';

class TaskRemoteDataSource{

  final ApiClient _apiClient;

  TaskRemoteDataSource(this._apiClient);

  Future<List<Task>> getMyTasks({int page = 1 , int pageSize = 10, String? filter}) async {
    Map<String, dynamic> params = {
      'page': page,
      'limit': pageSize,
    };

    if (filter != null && filter != 'all') {
      params['status'] = filter.toUpperCase();
    }

    final response = await _apiClient.get('/task-distribution/my-tasks',
        params: params);
    print('Response from getMyTasks: ${response.data}');
      List<dynamic>? tasksData = response.data['data']['result'];
      if (tasksData == null) {
        showErrorMessage("Couldn't fetch tasks. Please try again later.");
        return [];
      }
      return tasksData.map((task) => Task.fromJson(task)).toList();
  }

  Future<TaskDetail> getTaskDetail(String taskId) async {
    final response = await _apiClient.get('/task-distribution/assigned-tasks/$taskId');
    print('Response from getTaskDetail: ${response.data}');
    return TaskDetail.fromJson(response.data['data']);
  }

  Future<void> submitAudioTask(String taskId, int batch, bool isTest, Map<String, File> recordings) async {
      Map<String , MultipartFile> rec = recordings.map((key, value) => MapEntry(key, MultipartFile.fromFileSync(value.path)));
      FormData data = FormData.fromMap(rec);
      data.fields.add(MapEntry('batch', batch.toString()));
      data.fields.add(MapEntry('is_test', isTest.toString()));
      await _apiClient.post('/task-distribution/$taskId/contribute_audio',
          data: data,
          options: Options(headers: {
              'Content-Type': 'multipart/form-data',
            },
          ));
  }

  Future<void> submitTextTask(String taskId, int batch, bool isTest, Map<String, String> textOutputs) async {
      await _apiClient.post('/task-distribution/$taskId/contribute',
          data: {
            'batch': batch,
            'is_test': isTest,
            'attempts': [
              for (var entry in textOutputs.entries)
                {
                  'micro_task_id': entry.key,
                  'text_data_set': entry.value,
                }
            ]
          },);
  }

  Future<double> getBalance() async {
    final response = await _apiClient.get('/wallet/balance');
    print('Response from getBalance: ${response.data}');
    return double.parse(response.data['data'].toString());
  }

  Future<List<dynamic>> getSubmissionHistory(String microTaskId) async {
    final response = await _apiClient.get('/task-distribution/contributor-micro-task-submissions/$microTaskId');
    print('Response from getSubmissionHistory: ${response.data}');
    return response.data['data'] as List<dynamic>;
  }

}