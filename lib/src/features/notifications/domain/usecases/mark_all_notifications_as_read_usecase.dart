import '../../../../core/base_types/result.dart';
import '../repositories/notification_repository.dart';

class MarkAllNotificationsAsReadUsecase {
  final NotificationRepository notificationRepository;

  MarkAllNotificationsAsReadUsecase(this.notificationRepository);

  Future<Result<void>> call() async {
    return await notificationRepository.markAllNotificationsAsRead();
  }
}
