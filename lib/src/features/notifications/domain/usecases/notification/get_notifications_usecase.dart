import '../../../../../core/types/result.dart';

import '../../domain.dart';
import '../../domain.dart';

class GetNotificationsUsecase {
  final NotificationRepository notificationRepository;

  GetNotificationsUsecase(this.notificationRepository);

  Future<Result<List<Notification>>> call() async {
    return await notificationRepository.getNotifications();
  }
}
