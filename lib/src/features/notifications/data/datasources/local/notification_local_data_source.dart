import '../../../domain/domain.dart';

/// Local data source for caching notifications in memory and providing
/// reactive streams for UI updates.
abstract class NotificationLocalDataSource {
  /// Returns a stream of cached notifications that updates whenever the cache changes.
  Stream<List<Notification>> watchNotifications();

  /// Returns currently cached notifications, or null if cache is empty.
  List<Notification>? getCachedNotifications();

  /// Caches a list of notifications and broadcasts the update to watchers.
  void cacheNotifications(List<Notification> notifications);

  /// Updates a single notification in the cache and broadcasts the change.
  void updateNotification(Notification notification);

  /// Clears all cached notifications.
  void clear();

  /// Disposes of resources (streams, etc.)
  void dispose();
}
