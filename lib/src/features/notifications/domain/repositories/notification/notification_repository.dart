import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';

abstract class NotificationRepository {
  Future<Either<NetworkException, List<Notification>>> getNotifications();
  Future<Either<NetworkException, int>> getUnreadNotificationsCount();
  Future<Either<NetworkException, void>> markNotificationAsRead(int id);
  Future<Either<NetworkException, void>> markAllNotificationsAsRead();
}
