import '../../../../../core/types/result.dart';

import '../../repositories/repositories.dart';

class MarkNotificationAsReadUsecase {
  final NotificationRepository notificationRepository;

  MarkNotificationAsReadUsecase(this.notificationRepository);

  Future<Result<void>> call(int id) async {
    return await notificationRepository.markNotificationAsRead(id);
  }
}
