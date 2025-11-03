import '../../../../../core/types/result.dart';

import '../../repositories/repositories.dart';

class MarkAllNotificationsAsReadUsecase {
  final NotificationRepository notificationRepository;

  MarkAllNotificationsAsReadUsecase(this.notificationRepository);

  Future<Result<void>> call() async {
    return await notificationRepository.markAllNotificationsAsRead();
  }
}
