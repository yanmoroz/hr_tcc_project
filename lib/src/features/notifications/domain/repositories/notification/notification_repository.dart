import '../../../../../core/base_types/result.dart';

import '../../domain.dart';

abstract class NotificationRepository {
  Future<Result<List<Notification>>> getNotifications();
  Future<Result<int>> getUnreadNotificationsCount();
  Future<Result<void>> markNotificationAsRead(int id);
  Future<Result<void>> markAllNotificationsAsRead();
}
