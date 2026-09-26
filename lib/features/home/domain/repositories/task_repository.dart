import 'dart:io';

import 'package:dartz/dartz.dart' hide Task;
import 'package:mahder_mobile/features/home/data/models/task_detail.dart';
import '../../../../core/errors/failure.dart';
import '../../data/datasources/task_remote_data_source.dart';
import '../../data/models/task.dart';
import '../../data/models/wallet_transaction.dart';

class TaskRepository {
  final TaskRemoteDataSource _remoteDataSource;

  TaskRepository(this._remoteDataSource);

  Future<Either<Failure, List<Task>>> getMyTasks({int? page , int? pageSize, String? filter}) async {
    try {
      final response = await _remoteDataSource.getMyTasks(page: page??1 , pageSize: pageSize??10, filter: filter);
      return Right(response);
    }
    on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
  Future<Either<Failure, TaskDetail>> getTaskDetail(String taskId) async {
    try {
      final response = await _remoteDataSource.getTaskDetail(taskId);
      return Right(response);
    }
    on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
  Future<Either<Failure, void>> submitAudioTask(String taskId, int batch, bool isTest, Map<String, File> recordings) async {
    try {
      await _remoteDataSource.submitAudioTask(taskId, batch,isTest, recordings);
      return const Right(null);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  Future<Either<Failure, void>> submitTextTask(String taskId, int batch, bool isTest, Map<String, String> textOutput) async {
    try {
      await _remoteDataSource.submitTextTask(taskId, batch,isTest, textOutput);
      return const Right(null);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  Future<double> getBalance() async {
    try {
      final response = await _remoteDataSource.getBalance();
      return response;
    } on Exception catch (e) {
      print('Error fetching balance: $e');
      return 0.0;
    }
  }

  Future<Either<Failure, void>> withdrawMoney({
    required double amount,
    required String phoneNumber,
    required String paymentMethod,
  }) async {
    try {
      await _remoteDataSource.withdrawMoney(
        amount: amount,
        phoneNumber: phoneNumber,
        paymentMethod: paymentMethod,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  Future<Either<Failure, List<WalletTransaction>>> getWalletTransactions({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _remoteDataSource.getWalletTransactions(
        page: page,
        pageSize: pageSize,
      );
      return Right(response);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  Future<Either<Failure, List<dynamic>>> getSubmissionHistory(String microTaskId) async {
    try {
      final response = await _remoteDataSource.getSubmissionHistory(microTaskId);
      return Right(response);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

}
