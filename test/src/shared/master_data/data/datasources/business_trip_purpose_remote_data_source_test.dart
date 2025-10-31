import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hr_tcc_project/src/core/auth/auth_token_provider.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/shared/master_data/data/datasources/data_sources.dart';
import 'package:hr_tcc_project/src/shared/master_data/data/models/models.dart';

void main() {
  group('BusinessTripPurposeRemoteDataSource', () {
    late BusinessTripPurposeRemoteDataSource dataSource;
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
      dataSource = BusinessTripPurposeRemoteDataSourceImpl(apiClient);
    });

    group('getBusinessTripPurposes', () {
      test('should fetch business trip purposes from API and map to models', () async {
        // Act
        final result = await dataSource.getBusinessTripPurposes();

        // Assert
        result.fold(
          (failure) {
            fail('Unexpected error: ${failure.message}');
          },
          (models) {
            // If we get here, the API call succeeded
            expect(models, isA<List<BusinessTripPurposeModel>>());

            // Print the actual data for verification
            print('Fetched business trip purposes: ${models.length}');
            for (final businessTripPurpose in models) {
              print('  - ${businessTripPurpose.toString()}');
              // Verify fields
              expect(businessTripPurpose.id, isNotEmpty);
              expect(businessTripPurpose.name, isNotEmpty);
              expect(businessTripPurpose.obligation, isA<bool>());
            }
          },
        );
      });
    });
  });
}

