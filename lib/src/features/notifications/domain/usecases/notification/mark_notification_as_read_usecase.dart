import 'package:fpdart/fpdart.dart';

import '../../../../../core/exceptions/network/network_exception.dart';
import '../../repositories/repositories.dart';

class MarkNotificationAsReadUsecase {
  final NotificationRepository notificationRepository;

  MarkNotificationAsReadUsecase(this.notificationRepository);

  Future<Either<NetworkException, void>> call(int id) async {
    return await notificationRepository.markNotificationAsRead(id);
  }
}
