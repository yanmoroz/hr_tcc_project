import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hr_tcc_project/src/core/auth/auth_token_provider.dart';
import 'package:hr_tcc_project/src/core/logging/app_logger.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/features/applications/data/data.dart';

void main() {
  group('ApplicationRemoteDataSource', () {
    late ApplicationRemoteDataSource dataSource;
    late ApiClient apiClient;
    late AuthTokenProvider authTokenProvider;

    setUpAll(() async {
      await dotenv.load(fileName: ".env");
    });

    setUp(() {
      authTokenProvider = LocalAuthTokenProvider();
      apiClient = InsecureApiClient(authTokenProvider);
      dataSource = ApplicationRemoteDataSourceImpl(apiClient);
    });

    group('getApplications', () {
      test('should fetch list of applications with pagination from API', () async {
        // Act
        final result = await dataSource.getApplications(page: 0, pageSize: 20);

        // Assert
        result.fold(
          (failure) {
            fail('Unexpected error: $failure');
          },
          (response) {
            expect(response, isA<ApplicationListResponseModel>());
            AppLogger.d(
              'Fetched applications: ${response.applicationInfos.length} items out of ${response.total} total',
            );
            for (final stat in response.statistics) {
              AppLogger.d('  - ${stat.statusGroupName}: ${stat.count} applications');
            }
          },
        );
      });
    });

    group('getApplicationDetail', () {
      test('should fetch application detail by id from API', () async {
        // First get a list to extract an ID
        final listResult = await dataSource.getApplications(page: 0, pageSize: 1);

        await listResult.fold((failure) => fail('Failed to get list: $failure'), (response) async {
          if (response.applicationInfos.isEmpty) {
            AppLogger.d('No applications available to test detail endpoint');
            return;
          }

          final applicationId = response.applicationInfos.first.id;
          AppLogger.d('Testing detail endpoint with ID: $applicationId');

          // Act
          final detailResult = await dataSource.getApplicationDetail(applicationId);

          // Assert
          detailResult.fold(
            (failure) {
              fail('Unexpected error: $failure');
            },
            (detail) {
              expect(detail, isA<ApplicationDetailModel>());
              AppLogger.d('Fetched application detail: $detail');
            },
          );
        });
      });
    });

    group('createApplication', () {
      test('should handle create application request (expected to fail without valid data)', () async {
        // This is a placeholder test - actual creation would require valid request data
        // based on application form type
        final request = {
          'applicationFormCode': 'courierDelivery',
          'deliveryType': true,
          'deliveryAddress': 'Test Address',
        };

        final result = await dataSource.createApplication(request);

        result.fold(
          (error) {
            // Expected to fail with incomplete/invalid data
            AppLogger.d('Create application failed (expected): ${error.toString()}');
            expect(error, isA<Exception>());
          },
          (response) {
            expect(response, isA<CreateApplicationResultModel>());
            AppLogger.d('Application created with status: ${response.status}');
            if (response.instance != null) {
              AppLogger.d('Process instance ID: ${response.instance}');
            }
          },
        );
      });
    });

    group('cancelApplication', () {
      test('should handle cancel application request (expected to fail without valid application)', () async {
        // Using a dummy ID - expected to fail
        const dummyId = '00000000-0000-0000-0000-000000000000';

        final result = await dataSource.cancelApplication(dummyId);

        result.fold(
          (error) {
            // Expected to fail with invalid ID
            AppLogger.d('Cancel application failed (expected): ${error.toString()}');
            expect(error, isA<Exception>());
          },
          (response) {
            expect(response, isA<CancelApplicationResultModel>());
            AppLogger.d('Application cancelled with status: ${response.status}');
          },
        );
      });
    });

    group('checkCancelStatus', () {
      test('should handle check cancel status request (expected to fail without valid application)', () async {
        // Using a dummy ID - expected to fail
        const dummyId = '00000000-0000-0000-0000-000000000000';

        final result = await dataSource.checkCancelStatus(dummyId);

        result.fold(
          (error) {
            // Expected to fail with invalid ID
            AppLogger.d('Check cancel status failed (expected): ${error.toString()}');
            expect(error, isA<Exception>());
          },
          (response) {
            expect(response, isA<CancelApplicationResultModel>());
            AppLogger.d('Cancel status: ${response.status}');
          },
        );
      });
    });

    group('checkApplicationStatus', () {
      test('should handle check application status request (expected to fail without valid instance)', () async {
        final result = await dataSource.checkApplicationStatus(
          applicationFormCode: 'courierDelivery',
          instance: '00000000-0000-0000-0000-000000000000',
        );

        result.fold(
          (error) {
            // Expected to fail with invalid instance ID
            AppLogger.d('Check application status failed (expected): ${error.toString()}');
            expect(error, isA<Exception>());
          },
          (response) {
            expect(response, isA<CreateApplicationResultModel>());
            AppLogger.d('Application status: ${response.status}');
          },
        );
      });
    });
  });
}
