import 'package:dartz/dartz.dart';
import 'package:leyu_mobile/core/errors/failure.dart';
import 'package:leyu_mobile/features/notification/data/datasources/notification_remote_data_source.dart';
import 'package:leyu_mobile/features/notification/data/models/notification_response_model.dart';

class NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;

  NotificationRepository(this._remoteDataSource);

  /// Fetch notifications with pagination and error handling
  Future<Either<Failure, NotificationResponseModel>> getNotifications({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _remoteDataSource.getNotifications(
        page: page,
        limit: limit,
      );
      return Right(response);
    } catch (e) {
      if (e is Exception) {
        final failure = mapExceptionToFailure(e);
        return Left(_enhanceFailureMessage(failure, 'load notifications'));
      }
      return const Left(ServerFailure('Failed to load notifications. Please try again.'));
    }
  }

  /// Get unread notification count with error handling
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final count = await _remoteDataSource.getUnreadCount();
      return Right(count);
    } catch (e) {
      if (e is Exception) {
        final failure = mapExceptionToFailure(e);
        return Left(_enhanceFailureMessage(failure, 'load notification count'));
      }
      return const Left(ServerFailure('Failed to load notification count'));
    }
  }

  /// Mark notification as read with error handling
  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    try {
      await _remoteDataSource.markAsRead(notificationId);
      return const Right(null);
    } catch (e) {
      if (e is Exception) {
        final failure = mapExceptionToFailure(e);
        return Left(_enhanceFailureMessage(failure, 'mark notification as read'));
      }
      return const Left(ServerFailure('Failed to mark notification as read'));
    }
  }

  /// Mark all notifications as read with error handling
  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await _remoteDataSource.markAllAsRead();
      return const Right(null);
    } catch (e) {
      if (e is Exception) {
        final failure = mapExceptionToFailure(e);
        return Left(_enhanceFailureMessage(failure, 'mark all notifications as read'));
      }
      return const Left(ServerFailure('Failed to mark all notifications as read'));
    }
  }

  /// Enhance failure messages with user-friendly context
  Failure _enhanceFailureMessage(Failure failure, String action) {
    if (failure is NetworkFailure) {
      return const NetworkFailure('No internet connection. Please check your network and try again.');
    } else if (failure is TimeoutFailure) {
      return const TimeoutFailure('Request timed out. Please try again.');
    } else if (failure is UnauthorizedFailure) {
      return const UnauthorizedFailure('Session expired. Please log in again.');
    } else if (failure is NotFoundFailure) {
      return const NotFoundFailure('Notification not found.');
    } else if (failure is ServerFailure) {
      return const ServerFailure('Server error. Please try again later.');
    }
    return failure;
  }
}
