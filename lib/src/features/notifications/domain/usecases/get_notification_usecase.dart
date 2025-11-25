import '../entities/notification.dart';
import '../repositories/notification_repository.dart';

class GetNotificationUsecase {
  final NotificationRepository notificationRepository;

  GetNotificationUsecase(this.notificationRepository);

  Notification? call(int id) {
    return notificationRepository.getNotification(id);
  }
}
