import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:hr_tcc_project/src/core/auth/auth_token_provider.dart';
import 'package:hr_tcc_project/src/core/logging/app_logger.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/features/g2g/notifications/notifications.dart';

import 'helpers/result_helper.dart';

void main() {
  group('Notifications', () {
    late AuthTokenProvider authTokenProvider;
    late ApiClient apiClient;
    late NotificationRemoteDataSource remoteDataSource;
    late NotificationLocalDataSource localDataSource;
    late NotificationRepository repository;
    late GetNotificationsUsecase getNotificationsUsecase;
    late MarkNotificationAsReadUsecase markNotificationAsReadUsecase;

    setUpAll(() async {
      await dotenv.load(fileName: ".env");
    });

    setUp(() {
      authTokenProvider = LocalAuthTokenProvider();
      apiClient = InsecureApiClient(authTokenProvider);
      remoteDataSource = NotificationRemoteDataSourceImpl(apiClient);
      localDataSource = NotificationLocalDataSourceImpl();
      repository = NotificationRepositoryImpl(
        remoteDataSource,
        localDataSource,
      );
      getNotificationsUsecase = GetNotificationsUsecase(repository);
      markNotificationAsReadUsecase = MarkNotificationAsReadUsecase(repository);
    });

    test('E2E', () async {
      final notifications = await getOrFail(getNotificationsUsecase());
      expect(notifications, isA<List<Notification>>());
      AppLogger.d('Fetched notifications: ${notifications.length} items');

      await getOrFail(markNotificationAsReadUsecase(notifications.first.id));
      AppLogger.d('Marked notification as read: ${notifications.first.id}');
    });
  });
}
