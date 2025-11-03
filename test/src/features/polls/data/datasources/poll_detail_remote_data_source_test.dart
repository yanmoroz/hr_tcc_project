import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hr_tcc_project/src/core/auth/auth_token_provider.dart';
import 'package:hr_tcc_project/src/core/logging/app_logger.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/features/polls/data/datasources/data_sources.dart';
import 'package:hr_tcc_project/src/features/polls/data/models/models.dart';
import '../../../../../../lib/src/core/types/result.dart';

void main() {
  group('PollDetailRemoteDataSource', () {
    late PollDetailRemoteDataSource dataSource;
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
      dataSource = PollDetailRemoteDataSourceImpl(apiClient);
    });

    group('getPollDetail', () {
      test('should fetch poll detail from API and map to model', () async {
        // Act - using a test poll ID (you may need to adjust this)
        final result = await dataSource.getPollDetail(1);

        // Assert
        result.fold(
          (failure) {
            fail('Unexpected error: ${failure.message}');
          },
          (pollDetail) {
            // If we get here, the API call succeeded
            expect(pollDetail, isA<PollDetailModel>());
            // Log the actual data for verification
            AppLogger.d('Fetched poll detail:\n${pollDetail.toString()}');
          },
        );
      });
    });
  });
}
