import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hr_tcc_project/src/core/auth/auth_token_provider.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/shared/master_data/data/datasources/data_sources.dart';
import 'package:hr_tcc_project/src/shared/master_data/data/models/models.dart';

void main() {
  group('CoreDictionariesRemoteDataSource', () {
    late CoreDictionariesRemoteDataSource dataSource;
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
      dataSource = CoreDictionariesRemoteDataSourceImpl(apiClient);
    });

    group('getCoreDictionaries', () {
      test('should fetch core dictionaries from API and map to models', () async {
        // Act
        final result = await dataSource.getCoreDictionaries();

        // Assert
        result.fold(
          (failure) {
            fail('Unexpected error: ${failure.message}');
          },
          (response) {
            // If we get here, the API call succeeded
            expect(response.applicationFormGroups, isA<List<ApplicationFormGroupModel>>());
            expect(response.applicationForms, isA<List<ApplicationFormModel>>());
            expect(response.systemStatusesGroups, isA<List<SystemStatusGroupModel>>());
            expect(response.systemStatuses, isA<List<SystemStatusModel>>());
            expect(response.tripPurposes, isA<List<TripPurposeModel>>());
            expect(response.trainingTypes, isA<List<TrainingTypeModel>>());
            expect(response.trainingForms, isA<List<TrainingFormModel>>());
            expect(response.trainingMonths, isA<List<TrainingMonthModel>>());
            expect(response.alpinaDigitalPrevAccesses, isA<List<AlpinaDigitalPrevAccessModel>>());
            expect(response.offices, isA<List<OfficeModel>>());

            // Print the actual data for verification
            print('Fetched core dictionaries:');
            print('  - ApplicationFormGroups: ${response.applicationFormGroups.length}');
            for (final applicationFormGroup in response.applicationFormGroups) {
              print('    - ${applicationFormGroup.toString()}');
            }
            print('  - ApplicationForms: ${response.applicationForms.length}');
            for (final applicationForm in response.applicationForms) {
              print('    - ${applicationForm.toString()}');
            }
            print('  - SystemStatusesGroups: ${response.systemStatusesGroups.length}');
            for (final systemStatusGroup in response.systemStatusesGroups) {
              print('    - ${systemStatusGroup.toString()}');
            }
            print('  - SystemStatuses: ${response.systemStatuses.length}');
            for (final systemStatus in response.systemStatuses) {
              print('    - ${systemStatus.toString()}');
            }
            print('  - TripPurposes: ${response.tripPurposes.length}');
            for (final tripPurpose in response.tripPurposes) {
              print('    - ${tripPurpose.toString()}');
            }
            print('  - TrainingTypes: ${response.trainingTypes.length}');
            for (final trainingType in response.trainingTypes) {
              print('    - ${trainingType.toString()}');
            }
            print('  - TrainingForms: ${response.trainingForms.length}');
            for (final trainingForm in response.trainingForms) {
              print('    - ${trainingForm.toString()}');
            }
            print('  - TrainingMonths: ${response.trainingMonths.length}');
            for (final trainingMonth in response.trainingMonths) {
              print('    - ${trainingMonth.toString()}');
            }
            print('  - AlpinaDigitalPrevAccesses: ${response.alpinaDigitalPrevAccesses.length}');
            for (final alpinaDigitalPrevAccess in response.alpinaDigitalPrevAccesses) {
              print('    - ${alpinaDigitalPrevAccess.toString()}');
            }
            print('  - Offices: ${response.offices.length}');
            for (final office in response.offices) {
              print('    - ${office.toString()}');
            }
          },
        );
      });
    });
  });
}
