import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hr_tcc_project/src/core/auth/auth_token_provider.dart';
import 'package:hr_tcc_project/src/core/logging/app_logger.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/features/applications/applications.dart';

import 'helpers/result_helper.dart';

void main() {
  group('Applications', () {
    late AuthTokenProvider authTokenProvider;
    late ApiClient apiClient;
    late ApplicationRemoteDataSource dataSource;
    late ApplicationRepository repository;

    setUpAll(() async {
      await dotenv.load(fileName: ".env");
    });

    setUp(() {
      authTokenProvider = LocalAuthTokenProvider();
      apiClient = InsecureApiClient(authTokenProvider);
      dataSource = ApplicationRemoteDataSourceImpl(apiClient);
      repository = ApplicationRepositoryImpl(dataSource);
    });

    test('Application Detail', () async {
      final applications = await getOrFail(
        repository.getApplications(page: 0, pageSize: 10),
      );
      expect(applications.applications, isA<List<ApplicationInfo>>());
      AppLogger.d(
        'Fetched applications: ${applications.applications.length} items',
      );

      // final applicationDetail = await getOrFail(
      //   repository.getApplicationDetail(applications.applications.first.id),
      // );
      // expect(applicationDetail, isA<ApplicationDetail>());
      // AppLogger.d(
      //   'Fetched application detail: ${applicationDetail.toString()}',
      // );
    });

    test('Create Application - Alpina Digital Access', () async {
      final params = CreateApplicationParams.alpinaDigitalAccess(
        desiredStartDate: DateTime(
          2025,
          12,
          10,
          13,
          3,
          45,
        ).toUtc().toIso8601String(),
        comment: 'Хочу доступ',
        alpinaDigitalPrevAccessCode: 'ne_znayu',
        agreementAcceptance: true,
      );

      final application = await getOrFail(repository.createApplication(params));

      expect(application, isA<CreateApplicationResult>());
      AppLogger.d('Created application: ${application.toString()}');
    });

    test('Create Application - Absence', () async {
      final params = CreateApplicationParams.absence(
        category: 3,
        note: 'Захотел выспаться',
        fromDateTime: DateTime(
          2025,
          10,
          15,
          13,
          0,
          0,
        ).toUtc().toIso8601String(),
        toDateTime: DateTime(2025, 10, 15, 18, 0, 0).toUtc().toIso8601String(),
      );

      final application = await getOrFail(repository.createApplication(params));

      expect(application, isA<CreateApplicationResult>());
      AppLogger.d('Created absence application: ${application.toString()}');
    });
  });
}
