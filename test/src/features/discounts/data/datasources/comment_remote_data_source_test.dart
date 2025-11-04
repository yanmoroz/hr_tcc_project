import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hr_tcc_project/src/core/auth/auth_token_provider.dart';
import 'package:hr_tcc_project/src/core/logging/app_logger.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/core/types/result.dart';
import 'package:hr_tcc_project/src/features/discounts/data/data.dart';

void main() {
  group('CommentRemoteDataSource', () {
    late CommentRemoteDataSource dataSource;
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
      dataSource = CommentRemoteDataSourceImpl(apiClient);
    });

    group('getComments', () {
      test('should fetch comments by discountId from API and map to models', () async {
        // Act
        final result = await dataSource.getComments(49);

        // Assert
        result.fold(
          (failure) {
            fail('Unexpected error: ${failure.message}');
          },
          (commentResponse) {
            expect(commentResponse, isA<CommentListResponse>());
            expect(commentResponse.comments, isA<List<CommentModel>>());
            AppLogger.d('Fetched comments: ${commentResponse.comments.length}');
          },
        );
      });
    });

    group('addAndDeleteComment', () {
      test('should add comment and then delete it using the returned commentId', () async {
        // Arrange
        final request = AddCommentRequest(content: '12345');

        // Act - Add comment
        final addResult = await dataSource.addComment(49, request);

        // Assert - Verify comment was added
        await addResult.fold(
          (failure) async {
            fail('Failed to add comment: ${failure.message}');
          },
          (comment) async {
            expect(comment, isA<CommentModel>());
            AppLogger.d('Added comment with id: ${comment.id}');

            final commentId = comment.id;

            // Act - Delete the comment we just added
            final deleteResult = await dataSource.deleteComment(49, commentId);

            // Assert - Verify comment was deleted
            deleteResult.fold(
              (failure) {
                fail('Failed to delete comment: ${failure.message}');
              },
              (deleteResponse) {
                expect(deleteResponse, isA<CommentRemoveResponse>());
                expect(deleteResponse.removedIds, contains(commentId));
                AppLogger.d('Deleted comment with id: $commentId, removed IDs: ${deleteResponse.removedIds}');
              },
            );
          },
        );
      });
    });
  });
}
