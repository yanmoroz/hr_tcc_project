import 'package:rxdart/rxdart.dart';

import '../../../../core/base_types/result.dart';
import '../../../../core/base_types/base_repository.dart';
import '../../domain/domain.dart';
import '../datasources/notification_remote_data_source.dart';
import '../models/responses/notification_model.dart';

class NotificationRepositoryImpl
    with BaseRepository
    implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;
  final _notificationsController = BehaviorSubject<List<Notification>>();
  List<Notification> _cache = [];

  NotificationRepositoryImpl(this._remoteDataSource);

  @override
  Stream<List<Notification>> watchNotifications() =>
      _notificationsController.stream;

  @override
  Future<Result<List<Notification>>> getNotifications() async {
    final result = await _remoteDataSource.getNotifications();
    result.fold((error) => [], (notifications) {
      _cache = notifications.map((model) => model.toDomain()).toList();
      _notificationsController.add(_cache);
    });
    return mapResultList(result, (model) => model.toDomain());
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
    _cache = _cache
        .map((n) => n.id == notification.id ? notification : n)
        .toList();
    _notificationsController.add(_cache);
  }
}
