import 'package:rxdart/rxdart.dart';

import '../../../domain/domain.dart';
import 'notification_local_data_source.dart';

/// Implementation of [NotificationLocalDataSource] that uses an in-memory
/// cache with RxDart's BehaviorSubject for reactive updates.
class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  final _notificationsController = BehaviorSubject<List<Notification>>.seeded(
    [],
  );
  List<Notification> _cache = [];

  @override
  Stream<List<Notification>> watchNotifications() =>
      _notificationsController.stream;

  @override
  List<Notification>? getCachedNotifications() =>
      _cache.isEmpty ? null : _cache;

  @override
  void cacheNotifications(List<Notification> notifications) {
    _cache = notifications;
    _notificationsController.add(_cache);
  }

  @override
  void updateNotification(Notification notification) {
    _cache = _cache
        .map((n) => n.id == notification.id ? notification : n)
        .toList();
    _notificationsController.add(_cache);
  }

  @override
  void clear() {
    _cache = [];
    _notificationsController.add(_cache);
  }

  @override
  void dispose() {
    _notificationsController.close();
  }
}
