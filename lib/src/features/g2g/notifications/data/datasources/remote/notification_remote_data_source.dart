import '../../../../../../core/base_types/result.dart';
import '../../models/responses/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<Result<List<NotificationModel>>> getNotifications();
  Future<Result<int>> getUnreadNotificationsCount();
  Future<Result<void>> markAsRead({int? id});
}
