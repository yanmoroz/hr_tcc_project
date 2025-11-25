import 'package:collection/collection.dart';

import '../../../../core/base_types/result.dart';
import '../../../../core/base_types/base_repository.dart';
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
  Stream<List<Notification>> watchNotifications() =>
      _localDataSource.watchNotifications();

  @override
  Future<Result<List<Notification>>> getNotifications() async {
    final result = await _remoteDataSource.getNotifications();
    result.fold((error) => {}, (notifications) {
      final entities = notifications.map((model) => model.toDomain()).toList();
      _localDataSource.cacheNotifications(entities);
    });
    return mapResultList(result, (model) => model.toDomain());
  }

  @override
  Notification? getNotification(int id) {
    final cachedNotification = _localDataSource
        .getCachedNotifications()
        ?.firstWhereOrNull((notification) => notification.id == id);

    return cachedNotification;
  }

  @override
  Future<Result<int>> getUnreadNotificationsCount() async {
    return await _remoteDataSource.getUnreadNotificationsCount();
  }

  @override
  Future<Result<void>> markNotificationAsRead(int id) async {
    return await _remoteDataSource.markAsRead(id: id);
  }

  @override
  Future<Result<void>> markAllNotificationsAsRead() async {
    return await _remoteDataSource.markAsRead();
  }

  @override
  void updateNotification(Notification notification) {
    _localDataSource.updateNotification(notification);
  }
}
