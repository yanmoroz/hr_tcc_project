import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hr_tcc_project/src/core/auth/auth_token_provider.dart';
import 'package:hr_tcc_project/src/core/logging/app_logger.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/core/types/result.dart';
import 'package:hr_tcc_project/src/features/discounts/data/data.dart';

void main() {
  group('LikeRemoteDataSource', () {
    late LikeRemoteDataSource dataSource;
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
      dataSource = LikeRemoteDataSourceImpl(apiClient);
    });

    group('toggleDiscountLike', () {
      test('should toggle discount like by discountId from API and map response to model', () async {
        // Act
        final result = await dataSource.toggleDiscountLike(49);

        // Assert
        result.fold(
          (failure) {
            fail('Unexpected error: ${failure.message}');
          },
          (likeResponse) {
            expect(likeResponse, isA<LikeResponse>());
            expect(likeResponse.like, isA<bool>());
            AppLogger.d('Toggled discount like, new state: ${likeResponse.like}');
          },
        );
      });
    });

    group('toggleCommentLike', () {
      test('should toggle comment like by discountId and commentId from API and map response to model', () async {
        // Act
        final result = await dataSource.toggleCommentLike(49, 6782);

        // Assert
        result.fold(
          (failure) {
            fail('Unexpected error: ${failure.message}');
          },
          (likeResponse) {
            expect(likeResponse, isA<LikeResponse>());
            expect(likeResponse.like, isA<bool>());
            AppLogger.d('Toggled comment like, new state: ${likeResponse.like}');
          },
        );
      });
    });
  });
}
