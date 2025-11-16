import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:hr_tcc_project/src/core/auth/auth_token_provider.dart';
import 'package:hr_tcc_project/src/core/base_types/result.dart';
import 'package:hr_tcc_project/src/core/entities/application_form.dart';
import 'package:hr_tcc_project/src/core/entities/application_form_group.dart';
import 'package:hr_tcc_project/src/core/logging/app_logger.dart';
import 'package:hr_tcc_project/src/core/master_data/datasources/master_data_remote_data_source_impl.dart';
import 'package:hr_tcc_project/src/core/master_data/master_data_cache.dart';
import 'package:hr_tcc_project/src/core/master_data/datasources/master_data_remote_data_source.dart';
import 'package:hr_tcc_project/src/core/master_data/repositories/master_data_repository.dart';
import 'package:hr_tcc_project/src/core/master_data/repositories/master_data_repository_impl.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';

void main() {
  group('MasterData', () {
    late AuthTokenProvider authTokenProvider;
    late ApiClient apiClient;
    late MasterDataRemoteDataSource dataSource;
    late MasterDataCache cache;
    late MasterDataRepository masterDataRepository;

    setUpAll(() async {
      await dotenv.load(fileName: ".env");
    });

    setUp(() {
      authTokenProvider = LocalAuthTokenProvider();
      apiClient = InsecureApiClient(authTokenProvider);
      dataSource = MasterDataRemoteDataSourceImpl(apiClient);
      cache = MasterDataCache();
      masterDataRepository = MasterDataRepositoryImpl(dataSource, cache);
    });

    test('E2E', () async {
      final result1 = await masterDataRepository.getApplicationForms();
      final result2 = await masterDataRepository.getApplicationFormGroups();

      result1.fold(
        (failure) {
          fail('Unexpected error: ${failure.message}');
        },
        (applicationForms) {
          expect(applicationForms, isA<List<ApplicationForm>>());
          AppLogger.d('Application forms: ${applicationForms.length}');

          result2.fold(
            (failure) {
              fail('Unexpected error: ${failure.toString()}');
            },
            (applicationFormGroups) {
              expect(applicationFormGroups, isA<List<ApplicationFormGroup>>());
              AppLogger.d(
                'Application form groups: ${applicationFormGroups.length}',
              );
            },
          );
        },
      );
    });
  });
}
