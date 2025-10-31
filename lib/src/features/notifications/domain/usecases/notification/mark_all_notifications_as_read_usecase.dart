import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../repositories/repositories.dart';

class MarkAllNotificationsAsReadUsecase {
  final NotificationRepository notificationRepository;

  MarkAllNotificationsAsReadUsecase(this.notificationRepository);

  Future<Either<NetworkException, void>> call() async {
    return await notificationRepository.markAllNotificationsAsRead();
  }
}
