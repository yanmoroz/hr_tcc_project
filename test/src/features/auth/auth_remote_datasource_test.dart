import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hr_tcc_project/src/core/base_types/result.dart';
import 'package:hr_tcc_project/src/core/logging/app_logger.dart';
import 'package:hr_tcc_project/src/core/network/keycloak_api_client.dart';
import 'package:hr_tcc_project/src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:hr_tcc_project/src/features/auth/data/models/auth_response_model.dart';

import '../../helpers/result_helper.dart';

void main() {
  group('AuthRemoteDataSource', () {
    late KeycloakApiClient keycloakClient;
    late AuthRemoteDataSource dataSource;

    setUpAll(() async {
      await dotenv.load(fileName: ".env");
    });

    setUp(() {
      keycloakClient = KeycloakApiClient();
      dataSource = AuthRemoteDataSourceImpl(keycloakClient);
    });

    test('login should return AuthResponseModel on successful authentication',
        () async {
      // Arrange
      final username = dotenv.env['TEST_USERNAME'];
      final password = dotenv.env['TEST_PASSWORD'];

      // Skip test if credentials are not configured
      if (username == null || password == null) {
        AppLogger.w(
          'Skipping login test: TEST_USERNAME and TEST_PASSWORD not configured in .env',
        );
        return;
      }

      // Act
      final result = await getOrFail(
        dataSource.login(username: username, password: password),
      );

      // Assert
      expect(result, isA<AuthResponseModel>());
      expect(result.accessToken, isNotEmpty);
      expect(result.tokenType, equals('Bearer'));
      expect(result.expiresIn, greaterThan(0));
      AppLogger.d('Login successful: ${result.toString()}');
    });

    test('login should return error on invalid credentials', () async {
      // Arrange
      const username = 'invalid_user';
      const password = 'invalid_password';

      // Act
      final result = await dataSource.login(
        username: username,
        password: password,
      );

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          AppLogger.d('Login failed as expected: ${failure.message}');
          expect(failure.message, isNotEmpty);
        },
        (_) => fail('Expected login to fail with invalid credentials'),
      );
    });

    test('refreshToken should return new tokens on valid refresh token',
        () async {
      // Arrange
      final username = dotenv.env['TEST_USERNAME'];
      final password = dotenv.env['TEST_PASSWORD'];

      // Skip test if credentials are not configured
      if (username == null || password == null) {
        AppLogger.w(
          'Skipping refresh token test: TEST_USERNAME and TEST_PASSWORD not configured in .env',
        );
        return;
      }

      // First, get a valid refresh token
      final loginResult = await getOrFail(
        dataSource.login(username: username, password: password),
      );

      expect(loginResult.refreshToken, isNotNull);
      final refreshToken = loginResult.refreshToken!;

      // Act
      final result = await getOrFail(
        dataSource.refreshToken(refreshToken),
      );

      // Assert
      expect(result, isA<AuthResponseModel>());
      expect(result.accessToken, isNotEmpty);
      expect(result.tokenType, equals('Bearer'));
      expect(result.expiresIn, greaterThan(0));
      AppLogger.d('Token refresh successful: ${result.toString()}');
    });

    test('refreshToken should return error on invalid refresh token', () async {
      // Arrange
      const invalidRefreshToken = 'invalid_refresh_token';

      // Act
      final result = await dataSource.refreshToken(invalidRefreshToken);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          AppLogger.d('Token refresh failed as expected: ${failure.message}');
          expect(failure.message, isNotEmpty);
        },
        (_) => fail('Expected refresh to fail with invalid token'),
      );
    });
  });
}
