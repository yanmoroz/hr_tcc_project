import '../../../../../core/base_types/result.dart';
import '../repositories/notification_repository.dart';

class GetUnreadNotificationsCountUsecase {
  final NotificationRepository notificationRepository;

  GetUnreadNotificationsCountUsecase(this.notificationRepository);

  Future<Result<int>> call() async {
    return await notificationRepository.getUnreadNotificationsCount();
  }
}
