import '../../../../core/base_types/result.dart';
import '../repositories/notification_repository.dart';

class MarkNotificationAsReadUsecase {
  final NotificationRepository notificationRepository;

  MarkNotificationAsReadUsecase(this.notificationRepository);

  Future<Result<void>> call(int id) async {
    return await notificationRepository.markNotificationAsRead(id);
  }
}
