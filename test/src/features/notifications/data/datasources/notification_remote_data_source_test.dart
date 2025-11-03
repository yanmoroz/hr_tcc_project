import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hr_tcc_project/src/core/auth/auth_token_provider.dart';
import 'package:hr_tcc_project/src/core/logging/app_logger.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/features/notifications/data/data.dart';
import '../../../../../../lib/src/core/types/result.dart';

void main() {
  group('NotificationRemoteDataSource', () {
    late NotificationRemoteDataSource dataSource;
    late ApiClient apiClient;
    late AuthTokenProvider authTokenProvider;

    setUpAll(() async {
      // Load environment variables for testing
      await dotenv.load(fileName: ".env");
    });

    setUp(() {
      // Create real instances (no mocks)
      authTokenProvider = LocalAuthTokenProvider();
      apiClient = InsecureApiClient(authTokenProvider);
      dataSource = NotificationRemoteDataSourceImpl(apiClient);
    });

    group('getNotifications', () {
      test('should fetch notifications from API and map to models', () async {
        // Act
        final result = await dataSource.getNotifications();

        // Assert
        result.fold(
          (failure) {
            fail('Unexpected error: ${failure.message}');
          },
          (notifications) {
            // If we get here, the API call succeeded
            expect(notifications, isA<List<NotificationModel>>());
            expect(notifications.isNotEmpty, true);

            // Log the actual data for verification
            AppLogger.d(
              'Fetched notifications: ${notifications.length}\n${notifications.map((n) => '  - ${n.toString()}').join('\n')}',
            );
          },
        );
      });
    });

    group('getUnreadNotificationsCount', () {
      test('should fetch unread notifications count from API', () async {
        // Act
        final result = await dataSource.getUnreadNotificationsCount();

        // Assert
        result.fold(
          (failure) {
            fail('Unexpected error: ${failure.message}');
          },
          (count) {
            // If we get here, the API call succeeded
            expect(count, isA<int>());
            expect(count, greaterThanOrEqualTo(0));

            // Log the actual count for verification
            AppLogger.d('Unread notifications count: $count');
          },
        );
      });
    });
  });
}
