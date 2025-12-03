import '../../../../../core/base_types/result.dart';
import '../entities/notification.dart';
import '../repositories/notification_repository.dart';

class GetNotificationsUsecase {
  final NotificationRepository notificationRepository;

  GetNotificationsUsecase(this.notificationRepository);

  Future<Result<List<Notification>>> call() async {
    return await notificationRepository.getNotifications();
  }
}
