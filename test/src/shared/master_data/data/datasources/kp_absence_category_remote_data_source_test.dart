import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hr_tcc_project/src/core/auth/auth_token_provider.dart';
import 'package:hr_tcc_project/src/core/logging/app_logger.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/shared/master_data/data/data.dart';
import '../../../../../../lib/src/core/types/result.dart';

void main() {
  group('KpAbsenceCategoryRemoteDataSource', () {
    late KpAbsenceCategoryRemoteDataSource dataSource;
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
      dataSource = KpAbsenceCategoryRemoteDataSourceImpl(apiClient);
    });

    group('getKpAbsenceCategories', () {
      test('should fetch absence categories from API and map to models', () async {
        // Act
        final result = await dataSource.getKpAbsenceCategories();

        // Assert
        result.fold(
          (failure) {
            fail('Unexpected error: ${failure.message}');
          },
          (models) {
            // If we get here, the API call succeeded
            expect(models, isA<List<KpAbsenceCategoryModel>>());
            expect(models.isNotEmpty, isTrue);

            // Log the actual data for verification
            AppLogger.d('Fetched ${models.length} absence categories:\n${models.join('\n')}');
          },
        );
      });
    });
  });
}
