import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hr_tcc_project/src/core/auth/auth_token_provider.dart';
import 'package:hr_tcc_project/src/core/logging/app_logger.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/core/network/api_constants.dart';
import 'package:hr_tcc_project/src/core/base_types/result.dart';
import 'package:hr_tcc_project/src/shared/comments/data/data.dart';

void main() {
  setUpAll(() async {
    // Load environment variables for testing
    await dotenv.load(fileName: ".env");
  });

  group('Discount Like Tests', () {
    late LikeRemoteDataSource dataSource;
    late ApiClient apiClient;
    late AuthTokenProvider authTokenProvider;

    setUp(() {
      // Create real instances (no mocks)
      authTokenProvider = LocalAuthTokenProvider();
      apiClient = InsecureApiClient(authTokenProvider);

      // Create data source with discount-specific endpoints for testing
      dataSource = LikeRemoteDataSourceImpl(
        apiClient: apiClient,
        toggleEntityLikeEndpoint: ApiConstants.discountLikeEndpoint,
        toggleCommentLikeEndpoint: ApiConstants.commentLikeEndpoint,
      );
    });

    group('toggleEntityLike', () {
      test(
        'should toggle entity like by entityId from API and map response to model',
        () async {
          // Act - Using discount ID 49 for testing
          final result = await dataSource.toggleEntityLike(49);

          // Assert
          result.fold(
            (failure) {
              fail('Unexpected error: ${failure.message}');
            },
            (likeResponse) {
              expect(likeResponse, isA<LikeResponse>());
              expect(likeResponse.like, isA<bool>());
              AppLogger.d(
                'Toggled entity like, new state: ${likeResponse.like}',
              );
            },
          );
        },
      );
    });

    group('toggleCommentLike', () {
      test(
        'should toggle comment like by entityId and commentId from API and map response to model',
        () async {
          // Act - Using discount ID 49 and comment ID 6782 for testing
          final result = await dataSource.toggleCommentLike(49, 6782);

          // Assert
          result.fold(
            (failure) {
              fail('Unexpected error: ${failure.message}');
            },
            (likeResponse) {
              expect(likeResponse, isA<LikeResponse>());
              expect(likeResponse.like, isA<bool>());
              AppLogger.d(
                'Toggled comment like, new state: ${likeResponse.like}',
              );
            },
          );
        },
      );
    });
  });

  group('News Like Tests', () {
    late LikeRemoteDataSource newsDataSource;
    late ApiClient apiClient;
    late AuthTokenProvider authTokenProvider;

    setUp(() {
      // Create real instances (no mocks)
      authTokenProvider = LocalAuthTokenProvider();
      apiClient = InsecureApiClient(authTokenProvider);

      // Create data source with news-specific endpoints for testing
      newsDataSource = LikeRemoteDataSourceImpl(
        apiClient: apiClient,
        toggleEntityLikeEndpoint: ApiConstants.newsLikeEndpoint,
        toggleCommentLikeEndpoint: ApiConstants.newsCommentLikeEndpoint,
      );
    });

    group('toggleEntityLike', () {
      test(
        'should toggle entity like by entityId from API and map response to model',
        () async {
          // Act - Using news ID 1 for testing
          final result = await newsDataSource.toggleEntityLike(100);

          // Assert
          result.fold(
            (failure) {
              fail('Unexpected error: ${failure.message}');
            },
            (likeResponse) {
              expect(likeResponse, isA<LikeResponse>());
              expect(likeResponse.like, isA<bool>());
              AppLogger.d(
                'Toggled entity like, new state: ${likeResponse.like}',
              );
            },
          );
        },
      );
    });

    group('toggleCommentLike', () {
      test(
        'should toggle comment like by entityId and commentId from API and map response to model',
        () async {
          // Act - Using news ID 1 and comment ID for testing
          final result = await newsDataSource.toggleCommentLike(100, 6017);

          // Assert
          result.fold(
            (failure) {
              fail('Unexpected error: ${failure.message}');
            },
            (likeResponse) {
              expect(likeResponse, isA<LikeResponse>());
              expect(likeResponse.like, isA<bool>());
              AppLogger.d(
                'Toggled comment like, new state: ${likeResponse.like}',
              );
            },
          );
        },
      );
    });
  });
}
