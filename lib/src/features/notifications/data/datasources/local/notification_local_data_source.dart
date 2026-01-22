import '../../../domain/domain.dart';

abstract class NotificationLocalDataSource {
  void cacheNotifications(List<Notification> notifications);

  void clear();

  void dispose();

  List<Notification> getCachedNotifications();

  void markAllAsRead();

  void markAsRead(int id);

  void updateNotification(Notification notification);

  Stream<List<Notification>> watchNotifications();
}
