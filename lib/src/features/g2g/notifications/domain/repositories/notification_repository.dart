import '../../../../../core/base_types/result.dart';
import '../entities/notification.dart';

abstract class NotificationRepository {
  Future<Result<List<Notification>>> getNotifications();
  Future<Result<int>> getUnreadNotificationsCount();
  Future<Result<void>> markNotificationAsRead(int id);
  Future<Result<void>> markAllNotificationsAsRead();

  Notification? getNotification(int id);

  Stream<List<Notification>> watchNotifications();
}
