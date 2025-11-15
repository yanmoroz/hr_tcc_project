import '../../../../../core/base_types/result.dart';

import '../../domain.dart';

class MarkAllNotificationsAsReadUsecase {
  final NotificationRepository notificationRepository;

  MarkAllNotificationsAsReadUsecase(this.notificationRepository);

  Future<Result<void>> call() async {
    return await notificationRepository.markAllNotificationsAsRead();
  }
}
