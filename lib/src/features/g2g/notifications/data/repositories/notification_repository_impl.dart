import 'package:collection/collection.dart';

import '../../../../../core/base_types/result.dart';
import '../../../../../core/base_types/base_repository.dart';
import '../../domain/domain.dart';
import '../datasources/local/notification_local_data_source.dart';
import '../datasources/remote/notification_remote_data_source.dart';
import '../models/responses/notification_model.dart';

class NotificationRepositoryImpl
    with BaseRepository
    implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;
  final NotificationLocalDataSource _localDataSource;

  NotificationRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Result<List<Notification>>> getNotifications() async {
    final result = await _remoteDataSource.getNotifications();
    return result.fold((error) => Result.left(error), (notifications) {
      final entities = notifications.map((model) => model.toDomain()).toList();
      _localDataSource.cacheNotifications(entities);
      return Result.right(entities);
    });
  }

  @override
  Future<Result<int>> getUnreadNotificationsCount() async {
    return await _remoteDataSource.getUnreadNotificationsCount();
  }

  @override
  Future<Result<void>> markNotificationAsRead(int id) async {
    final result = await _remoteDataSource.markAsRead(id: id);
    result.fold((_) {}, (_) => _localDataSource.markAsRead(id));
    return result;
  }

  @override
  Future<Result<void>> markAllNotificationsAsRead() async {
    final result = await _remoteDataSource.markAsRead();
    result.fold((_) {}, (_) => _localDataSource.markAllAsRead());
    return result;
  }

  @override
  Notification? getNotification(int id) {
    final cachedNotification = _localDataSource
        .getCachedNotifications()
        .firstWhereOrNull((notification) => notification.id == id);

    return cachedNotification;
  }

  @override
  Stream<List<Notification>> watchNotifications() =>
      _localDataSource.watchNotifications();
}
