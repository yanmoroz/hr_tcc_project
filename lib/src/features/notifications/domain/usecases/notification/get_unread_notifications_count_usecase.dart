import '../../../../../core/types/result.dart';

import '../../repositories/repositories.dart';

class GetUnreadNotificationsCountUsecase {
  final NotificationRepository notificationRepository;

  GetUnreadNotificationsCountUsecase(this.notificationRepository);

  Future<Result<int>> call() async {
    return await notificationRepository.getUnreadNotificationsCount();
  }
}
