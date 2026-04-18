import 'dart:io';

import 'package:leyu_mobile/features/home/domain/entities/task_entity.dart';

import '../../../../core/utils/message.dart';
import '../entities/task_detail_entity.dart';
import '../repositories/task_repository.dart';

class TaskUsecase{

  final TaskRepository _taskRepository;
  TaskUsecase(this._taskRepository);

  Future<List<TaskEntity>> getMyTasks({int? page , int? pageSize, String? filter}) async {
    final result =  await _taskRepository.getMyTasks(page: page, pageSize: pageSize, filter: filter);
    return result.fold((failure){
      showErrorMessage("Fetching tasks failed: ${failure.message}");
      return [];
    }, (tasks){
      return tasks.map<TaskEntity>((e) => TaskEntity.fromModel(e)).toList();
    });
  }

  Future<TaskDetailEntity?> getTaskDetail(String taskId) async {
    final result = await _taskRepository.getTaskDetail(taskId);
    return result.fold((failure){
      showErrorMessage("Fetching task detail failed: ${failure.message}");
      return null;
    }, (taskDetail){
      return TaskDetailEntity.fromModel(taskDetail);
    });
  }

  Future<bool> submitAudioTask(String taskId, int batch, bool isTest, Map<String, File> recordings) async {
    final result = await _taskRepository.submitAudioTask(taskId, batch, isTest, recordings);
    return result.fold((failure) {
      showErrorMessage("Submitting audio task failed: ${failure.message}");
      return false;
    }, (success) {
      recordings.forEach((key, file) async {
        await file.delete();
      });
      return true;
    });
  }

  Future<bool> submitTextTask(String taskId, int batch, bool isTest, Map<String, String> textOutput) async {
    final result = await _taskRepository.submitTextTask(taskId, batch, isTest, textOutput);
    return result.fold((failure) {
      showErrorMessage("Submitting text task failed: ${failure.message}");
      return false;
    }, (success) {
      return true;
    });
  }

  Future<double> getBalance() async {
    try {
      final response = await _taskRepository.getBalance();
      return response;
    } on Exception catch (e) {
      print('Error fetching balance: $e');
      return 0.0;
    }
  }

  Future<List<dynamic>> getSubmissionHistory(String microTaskId) async {
    final result = await _taskRepository.getSubmissionHistory(microTaskId);
    return result.fold((failure) {
      showErrorMessage("Fetching submission history failed: ${failure.message}");
      return [];
    }, (submissions) {
      return submissions;
    });
  }

}