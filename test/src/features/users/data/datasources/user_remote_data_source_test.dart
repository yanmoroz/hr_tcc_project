import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hr_tcc_project/src/core/auth/auth_token_provider.dart';
import 'package:hr_tcc_project/src/shared/files/domain/entities/system_type.dart';
import 'package:hr_tcc_project/src/core/logging/app_logger.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/core/base_types/result.dart';
import 'package:hr_tcc_project/src/features/users/data/data.dart';

void main() {
  group('UserRemoteDataSource', () {
    late UserRemoteDataSource dataSource;
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
      dataSource = UserRemoteDataSourceImpl(apiClient);
    });

    group('getUsers', () {
      test(
        'should fetch users for ELMA system type from API and map to models',
        () async {
          // Act
          final result = await dataSource.getUsers(systemType: SystemType.elma);

          // Assert
          result.fold(
            (failure) {
              fail('Unexpected error: ${failure.message}');
            },
            (users) {
              expect(users, isA<List<UserModel>>());
              AppLogger.d(
                'Fetched ELMA users: ${users.length}\n${users.map((u) => '  - ${u.title} (${u.position})').join('\n')}',
              );
            },
          );
        },
      );

      test(
        'should fetch users for KP system type from API and map to models',
        () async {
          // Act
          final result = await dataSource.getUsers(systemType: SystemType.kp);

          // Assert
          result.fold(
            (failure) {
              fail('Unexpected error: ${failure.message}');
            },
            (users) {
              expect(users, isA<List<UserModel>>());
              AppLogger.d('Fetched KP users: ${users.length}');
            },
          );
        },
      );

      test(
        'should fetch users with search parameter from API and map to models',
        () async {
          // Act
          final result = await dataSource.getUsers(
            systemType: SystemType.elma,
            search: 'Иван',
          );

          // Assert
          result.fold(
            (failure) {
              fail('Unexpected error: ${failure.message}');
            },
            (users) {
              expect(users, isA<List<UserModel>>());
              AppLogger.d(
                'Fetched users with search "Иван": ${users.length}\n${users.map((u) => '  - ${u.title} (${u.position})').join('\n')}',
              );
            },
          );
        },
      );
    });
  });
}
