import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:hr_tcc_project/src/core/auth/auth_status_notifier.dart';
import 'package:hr_tcc_project/src/core/auth/auth_token_provider.dart';
import 'package:hr_tcc_project/src/core/entities/application_form.dart';
import 'package:hr_tcc_project/src/core/entities/application_form_group.dart';
import 'package:hr_tcc_project/src/core/logging/app_logger.dart';
import 'package:hr_tcc_project/src/core/dictionaries/dictionaries.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'helpers/result_helper.dart';

void main() {
  group('Dictionaries', () {
    late AuthTokenProvider authTokenProvider;
    late ApiClient apiClient;
    late DictionariesRemoteDataSource dataSource;
    late DictionariesCache cache;
    late DictionariesRepository dictionariesRepository;

    setUpAll(() async {
      await dotenv.load(fileName: ".env");
    });

    setUp(() {
      authTokenProvider = LocalAuthTokenProvider();
      apiClient = InsecureApiClient(
        authTokenProvider,
        AuthStatusNotifier(authTokenProvider),
      );
      dataSource = DictionariesRemoteDataSourceImpl(apiClient);
      cache = DictionariesCache();
      dictionariesRepository = DictionariesRepositoryImpl(dataSource, cache);
    });

    test('E2E', () async {
      final applicationForms = await getOrFail(
        dictionariesRepository.getApplicationForms(),
      );
      expect(applicationForms, isA<List<ApplicationForm>>());
      AppLogger.d('Application forms: ${applicationForms.length}');

      final applicationFormGroups = await getOrFail(
        dictionariesRepository.getApplicationFormGroups(),
      );
      expect(applicationFormGroups, isA<List<ApplicationFormGroup>>());
      AppLogger.d('Application form groups: ${applicationFormGroups.length}');
    });
  });
}
