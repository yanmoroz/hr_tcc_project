import 'package:fpdart/fpdart.dart';

import '../../../../../core/data/base_repository.dart';
import '../../../../../core/exceptions/network/network_exception.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repositories.dart';
import '../../datasources/data_sources.dart';
import '../../models/models.dart';

class NotificationRepositoryImpl with BaseRepository implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;

  NotificationRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<NetworkException, List<Notification>>> getNotifications() async {
    final result = await _remoteDataSource.getNotifications();

    return mapResultList(result, (model) => model.toDomain());
  }

  @override
  Future<Either<NetworkException, int>> getUnreadNotificationsCount() async {
    return await _remoteDataSource.getUnreadNotificationsCount();
  }

  @override
  Future<Either<NetworkException, void>> markNotificationAsRead(int id) async {
    return await _remoteDataSource.markAsRead(id: id);
  }

  @override
  Future<Either<NetworkException, void>> markAllNotificationsAsRead() async {
    return await _remoteDataSource.markAsRead();
  }
}
