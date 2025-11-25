import '../../notifications.dart';

class UpdateNotificationUsecase {
  final NotificationRepository notificationRepository;

  UpdateNotificationUsecase(this.notificationRepository);

  void call(Notification notification) {
    return notificationRepository.updateNotification(notification);
  }
}
