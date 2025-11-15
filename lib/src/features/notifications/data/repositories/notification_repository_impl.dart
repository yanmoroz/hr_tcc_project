import '../../../../core/base_types/result.dart';
import '../../../../core/base_types/base_repository.dart';
import '../../domain/domain.dart';
import '../datasources/notification_remote_data_source.dart';
import '../models/notification_model.dart';

class NotificationRepositoryImpl
    with BaseRepository
    implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;

  NotificationRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<Notification>>> getNotifications() async {
    final result = await _remoteDataSource.getNotifications();

    return mapResultList(result, (model) => model.toDomain());
  }

  @override
  Future<Result<int>> getUnreadNotificationsCount() async {
    return await _remoteDataSource.getUnreadNotificationsCount();
  }

  @override
  Future<Result<void>> markNotificationAsRead(int id) async {
    return await _remoteDataSource.markAsRead(id: id);
  }

  @override
  Future<Result<void>> markAllNotificationsAsRead() async {
    return await _remoteDataSource.markAsRead();
  }
}
