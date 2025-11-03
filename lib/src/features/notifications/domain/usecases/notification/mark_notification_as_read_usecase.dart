import '../../../../../core/types/result.dart';

import '../../domain.dart';

class MarkNotificationAsReadUsecase {
  final NotificationRepository notificationRepository;

  MarkNotificationAsReadUsecase(this.notificationRepository);

  Future<Result<void>> call(int id) async {
    return await notificationRepository.markNotificationAsRead(id);
  }
}
