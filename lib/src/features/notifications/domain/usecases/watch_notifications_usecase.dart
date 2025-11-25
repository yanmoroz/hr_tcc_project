import '../../notifications.dart';

class WatchNotificationsUseCase {
  final NotificationRepository repository;

  WatchNotificationsUseCase(this.repository);

  Stream<List<Notification>> call() {
    return repository.watchNotifications();
  }
}
