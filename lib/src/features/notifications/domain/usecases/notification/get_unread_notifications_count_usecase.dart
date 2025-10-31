import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../repositories/repositories.dart';

class GetUnreadNotificationsCountUsecase {
  final NotificationRepository notificationRepository;

  GetUnreadNotificationsCountUsecase(this.notificationRepository);

  Future<Either<NetworkException, int>> call() async {
    return await notificationRepository.getUnreadNotificationsCount();
  }
}
