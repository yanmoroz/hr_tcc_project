import '../../../../../core/types/result.dart';

import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetNotificationsUsecase {
  final NotificationRepository notificationRepository;

  GetNotificationsUsecase(this.notificationRepository);

  Future<Result<List<Notification>>> call() async {
    return await notificationRepository.getNotifications();
  }
}
