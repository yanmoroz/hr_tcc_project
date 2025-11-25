import '../../../../core/base_types/result.dart';
import '../entities/notification.dart';

abstract class NotificationRepository {
  Future<Result<List<Notification>>> getNotifications();
  Notification? getNotification(int id);
  Future<Result<int>> getUnreadNotificationsCount();
  Future<Result<void>> markNotificationAsRead(int id);
  Future<Result<void>> markAllNotificationsAsRead();
  void updateNotification(Notification notification);
  Stream<List<Notification>> watchNotifications();
}
