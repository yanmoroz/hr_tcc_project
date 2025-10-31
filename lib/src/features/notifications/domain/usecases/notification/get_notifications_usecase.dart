import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../entities/entities.dart';
import '../../repositories/repositories.dart';

class GetNotificationsUsecase {
  final NotificationRepository notificationRepository;

  GetNotificationsUsecase(this.notificationRepository);

  Future<Either<NetworkException, List<Notification>>> call() async {
    return await notificationRepository.getNotifications();
  }
}
