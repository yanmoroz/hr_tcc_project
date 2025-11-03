import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hr_tcc_project/src/core/auth/auth_token_provider.dart';
import 'package:hr_tcc_project/src/core/logging/app_logger.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/features/polls/data/data.dart';
import 'package:hr_tcc_project/src/features/polls/domain/domain.dart';
import '../../../../../../lib/src/core/types/result.dart';

void main() {
  group('StaffRemoteDataSource', () {
    late StaffRemoteDataSource dataSource;
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
      dataSource = StaffRemoteDataSourceImpl(apiClient);
    });

    group('getStaff', () {
      test('should fetch staff items for EMPLOYEE target from API and map to models', () async {
        // Act
        final result = await dataSource.getStaff(target: StaffTarget.employee);

        // Assert
        result.fold(
          (failure) {
            fail('Unexpected error: ${failure.message}');
          },
          (staffItems) {
            // If we get here, the API call succeeded
            expect(staffItems, isA<List<StaffItemModel>>());

            // Log the actual data for verification
            AppLogger.d(
              'Fetched staff items (EMPLOYEE): ${staffItems.length}\n${staffItems.map((i) => '  - ${i.toString()}').join('\n')}',
            );
          },
        );
      });

      test('should fetch staff items for DEPARTMENT target from API and map to models', () async {
        // Act
        final result = await dataSource.getStaff(target: StaffTarget.department);

        // Assert
        result.fold(
          (failure) {
            fail('Unexpected error: ${failure.message}');
          },
          (staffItems) {
            // If we get here, the API call succeeded
            expect(staffItems, isA<List<StaffItemModel>>());

            // Log the actual data for verification
            AppLogger.d(
              'Fetched staff items (DEPARTMENT): ${staffItems.length}\n${staffItems.map((i) => '  - ${i.toString()}').join('\n')}',
            );
          },
        );
      });

      test('should fetch staff items for ORGANISATION target from API and map to models', () async {
        // Act
        final result = await dataSource.getStaff(target: StaffTarget.organisation);

        // Assert
        result.fold(
          (failure) {
            fail('Unexpected error: ${failure.message}');
          },
          (staffItems) {
            // If we get here, the API call succeeded
            expect(staffItems, isA<List<StaffItemModel>>());

            // Log the actual data for verification
            AppLogger.d(
              'Fetched staff items (ORGANISATION): ${staffItems.length}\n${staffItems.map((i) => '  - ${i.toString()}').join('\n')}',
            );
          },
        );
      });

      test('should fetch staff items with search parameter from API and map to models', () async {
        // Act
        final result = await dataSource.getStaff(target: StaffTarget.employee, search: 'Абдул');

        // Assert
        result.fold(
          (failure) {
            fail('Unexpected error: ${failure.message}');
          },
          (staffItems) {
            // If we get here, the API call succeeded
            expect(staffItems, isA<List<StaffItemModel>>());

            // Log the actual data for verification
            AppLogger.d(
              'Fetched staff items with search: ${staffItems.length}\n${staffItems.map((i) => '  - ${i.toString()}').join('\n')}',
            );
          },
        );
      });

      test('should handle empty search parameter correctly', () async {
        // Act
        final result = await dataSource.getStaff(target: StaffTarget.employee, search: '');

        // Assert
        result.fold(
          (failure) {
            fail('Unexpected error: ${failure.message}');
          },
          (staffItems) {
            // If we get here, the API call succeeded
            expect(staffItems, isA<List<StaffItemModel>>());
          },
        );
      });
    });
  });
}
