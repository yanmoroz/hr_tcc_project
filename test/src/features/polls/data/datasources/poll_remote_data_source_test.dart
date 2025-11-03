import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hr_tcc_project/src/core/auth/auth_token_provider.dart';
import 'package:hr_tcc_project/src/core/logging/app_logger.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/features/polls/data/datasources/data_sources.dart';
import 'package:hr_tcc_project/src/features/polls/data/models/models.dart';
import '../../../../../../lib/src/core/types/result.dart';

void main() {
  group('PollRemoteDataSource', () {
    late PollRemoteDataSource dataSource;
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
      dataSource = PollRemoteDataSourceImpl(apiClient);
    });

    group('getPolls', () {
      test('should fetch polls from API and map to models', () async {
        // Act
        final result = await dataSource.getPolls(status: 0, page: 0);

        // Assert
        result.fold(
          (failure) {
            fail('Unexpected error: ${failure.message}');
          },
          (polls) {
            // If we get here, the API call succeeded
            expect(polls, isA<List<PollModel>>());

            // Log the actual data for verification
            AppLogger.d('Fetched polls: ${polls.length}\n${polls.map((p) => '  - ${p.toString()}').join('\n')}');
          },
        );
      });
    });
  });
}
