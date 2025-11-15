import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hr_tcc_project/src/core/auth/auth_token_provider.dart';
import 'package:hr_tcc_project/src/core/logging/app_logger.dart';
import 'package:hr_tcc_project/src/core/master_data/master_data_remote_data_source.dart';
import 'package:hr_tcc_project/src/core/master_data/models/alpina_digital_prev_access_model.dart';
import 'package:hr_tcc_project/src/core/master_data/models/application_form_group_model.dart';
import 'package:hr_tcc_project/src/core/master_data/models/application_form_model.dart';
import 'package:hr_tcc_project/src/core/master_data/models/office_model.dart';
import 'package:hr_tcc_project/src/core/master_data/models/system_status_group_model.dart';
import 'package:hr_tcc_project/src/core/master_data/models/system_status_model.dart';
import 'package:hr_tcc_project/src/core/master_data/models/training_form_model.dart';
import 'package:hr_tcc_project/src/core/master_data/models/training_month_model.dart';
import 'package:hr_tcc_project/src/core/master_data/models/training_type_model.dart';
import 'package:hr_tcc_project/src/core/master_data/models/trip_purpose_model.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import '../../../../../../lib/src/core/types/result.dart';

void main() {
  group('MasterDataRemoteDataSource', () {
    late MasterDataRemoteDataSource dataSource;
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
      dataSource = MasterDataRemoteDataSource(apiClient);
    });

    group('getCoreDictionaries', () {
      test(
        'should fetch core dictionaries from API and map to models',
        () async {
          // Act
          final result = await dataSource.fetchAllCoreDictionaries();

          // Assert
          result.fold(
            (failure) {
              fail('Unexpected error: ${failure.message}');
            },
            (response) {
              // If we get here, the API call succeeded
              expect(
                response.applicationFormGroups,
                isA<List<ApplicationFormGroupModel>>(),
              );
              expect(
                response.applicationForms,
                isA<List<ApplicationFormModel>>(),
              );
              expect(
                response.systemStatusGroups,
                isA<List<SystemStatusGroupModel>>(),
              );
              expect(response.systemStatuses, isA<List<SystemStatusModel>>());
              expect(response.tripPurposes, isA<List<TripPurposeModel>>());
              expect(response.trainingTypes, isA<List<TrainingTypeModel>>());
              expect(response.trainingForms, isA<List<TrainingFormModel>>());
              expect(response.trainingMonths, isA<List<TrainingMonthModel>>());
              expect(
                response.alpinaDigitalPrevAccesses,
                isA<List<AlpinaDigitalPrevAccessModel>>(),
              );
              expect(response.offices, isA<List<OfficeModel>>());

              // Log the actual data for verification
              AppLogger.d('''Fetched core dictionaries:
  - ApplicationFormGroups: ${response.applicationFormGroups.length}
${response.applicationFormGroups.map((g) => '    - ${g.toString()}').join('\n')}
  - ApplicationForms: ${response.applicationForms.length}
${response.applicationForms.map((f) => '    - ${f.toString()}').join('\n')}
  - SystemStatusGroups: ${response.systemStatusGroups.length}
${response.systemStatusGroups.map((g) => '    - ${g.toString()}').join('\n')}
  - SystemStatuses: ${response.systemStatuses.length}
${response.systemStatuses.map((s) => '    - ${s.toString()}').join('\n')}
  - TripPurposes: ${response.tripPurposes.length}
${response.tripPurposes.map((p) => '    - ${p.toString()}').join('\n')}
  - TrainingTypes: ${response.trainingTypes.length}
${response.trainingTypes.map((t) => '    - ${t.toString()}').join('\n')}
  - TrainingForms: ${response.trainingForms.length}
${response.trainingForms.map((f) => '    - ${f.toString()}').join('\n')}
  - TrainingMonths: ${response.trainingMonths.length}
${response.trainingMonths.map((m) => '    - ${m.toString()}').join('\n')}
  - AlpinaDigitalPrevAccesses: ${response.alpinaDigitalPrevAccesses.length}
${response.alpinaDigitalPrevAccesses.map((a) => '    - ${a.toString()}').join('\n')}
  - Offices: ${response.offices.length}
${response.offices.map((o) => '    - ${o.toString()}').join('\n')}''');
            },
          );
        },
      );
    });
  });
}
