import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:hr_tcc_project/src/core/auth/auth_token_provider.dart';
import 'package:hr_tcc_project/src/core/logging/app_logger.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/features/comments/comments.dart';
import 'package:hr_tcc_project/src/features/discounts/discounts.dart';
import 'helpers/result_helper.dart';

void main() {
  group('News', () {
    late AuthTokenProvider authTokenProvider;
    late ApiClient apiClient;
    late DiscountRemoteDataSource dataSource;
    late DiscountRepository repository;
    late GetDiscountsUsecase getDiscountsUsecase;
    late GetDiscountDetailUsecase getDiscountDetailUsecase;
    late GetDiscountStatsUsecase getDiscountStatsUsecase;
    late ToggleDiscountLikeUsecase toggleDiscountLikeUsecase;
    late CommentRemoteDataSource commentDataSource;
    late CommentRepository commentRepository;
    late GetCommentsUsecase getCommentsUsecase;
    late AddCommentUsecase addCommentUsecase;
    late DeleteCommentUsecase deleteCommentUsecase;
    late ToggleCommentLikeUsecase toggleCommentLikeUsecase;

    setUpAll(() async {
      await dotenv.load(fileName: ".env");
    });

    setUp(() {
      authTokenProvider = LocalAuthTokenProvider();
      apiClient = InsecureApiClient(authTokenProvider);
      dataSource = DiscountRemoteDataSourceImpl(apiClient);
      repository = DiscountRepositoryImpl(dataSource);
      getDiscountsUsecase = GetDiscountsUsecase(repository);
      getDiscountDetailUsecase = GetDiscountDetailUsecase(repository);
      getDiscountStatsUsecase = GetDiscountStatsUsecase(repository);
      toggleDiscountLikeUsecase = ToggleDiscountLikeUsecase(repository);
      commentDataSource = CommentRemoteDataSourceImpl(apiClient);
      commentRepository = CommentRepositoryImpl(commentDataSource);
      getCommentsUsecase = GetCommentsUsecase(commentRepository);
      addCommentUsecase = AddCommentUsecase(commentRepository);
      deleteCommentUsecase = DeleteCommentUsecase(commentRepository);
      toggleCommentLikeUsecase = ToggleCommentLikeUsecase(commentRepository);
    });

    test('E2E Comments', () async {
      final discountList = await getOrFail(
        getDiscountsUsecase(category: 5, source: 1, page: 0),
      );
      expect(discountList, isA<List<Discount>>());
      AppLogger.d('Fetched discount list: ${discountList.length} items');

      final discountDetail = await getOrFail(
        getDiscountDetailUsecase(discountList.first.id),
      );
      expect(discountDetail, isA<DiscountDetail>());
      AppLogger.d('Fetched discount detail: ${discountDetail.toString()}');

      final discountStats = await getOrFail(
        getDiscountStatsUsecase(discountDetail.id),
      );
      expect(discountStats, isA<GetDiscountStatsResult>());
      AppLogger.d('Fetched discount stats: ${discountStats.toString()}');

      final comment = await getOrFail(
        addCommentUsecase(
          entityId: discountDetail.id,
          entityType: CommentableEntityType.discount,
          content: 'Test comment',
          parent: null,
          attachments: null,
        ),
      );
      expect(comment, isA<Comment>());
      AppLogger.d('Added comment: ${comment.toString()}');

      final updatedDiscountStats = await getOrFail(
        getDiscountStatsUsecase(discountDetail.id),
      );
      expect(updatedDiscountStats, isA<GetDiscountStatsResult>());
      AppLogger.d('Updated discount stats: ${updatedDiscountStats.toString()}');

      final removedIds = await getOrFail(
        deleteCommentUsecase(
          entityId: discountDetail.id,
          entityType: CommentableEntityType.discount,
          commentId: comment.id,
        ),
      );
      expect(removedIds, isA<List<int>>());
      AppLogger.d('Deleted comment: ${removedIds.length} items');

      final finalDiscountStats = await getOrFail(
        getDiscountStatsUsecase(discountDetail.id),
      );
      expect(finalDiscountStats, isA<GetDiscountStatsResult>());
      AppLogger.d('Updated discount stats: ${finalDiscountStats.toString()}');
    });

    test('E2E Likes', () async {
      final discountList = await getOrFail(
        getDiscountsUsecase(category: 5, source: 1, page: 0),
      );
      expect(discountList, isA<List<Discount>>());
      AppLogger.d('Fetched discount list: ${discountList.length} items');

      final discountDetail = await getOrFail(
        getDiscountDetailUsecase(discountList.first.id),
      );
      expect(discountDetail, isA<DiscountDetail>());
      AppLogger.d('Fetched discount detail: ${discountDetail.toString()}');

      final liked = await getOrFail(
        toggleDiscountLikeUsecase(discountDetail.id),
      );
      expect(liked, isA<bool>());
      AppLogger.d('Toggled discount like: $liked');

      final updatedDiscountStats = await getOrFail(
        getDiscountStatsUsecase(discountDetail.id),
      );
      expect(updatedDiscountStats, isA<GetDiscountStatsResult>());
      AppLogger.d('Updated discount stats: ${updatedDiscountStats.toString()}');
    });

    test('E2E Comment Likes', () async {
      final discountList = await getOrFail(
        getDiscountsUsecase(category: 5, source: 1, page: 0),
      );
      expect(discountList, isA<List<Discount>>());
      AppLogger.d('Fetched discount list: ${discountList.length} items');

      final discountDetail = await getOrFail(
        getDiscountDetailUsecase(discountList.first.id),
      );
      expect(discountDetail, isA<DiscountDetail>());
      AppLogger.d('Fetched discount detail: ${discountDetail.toString()}');

      final discountComments = await getOrFail(
        getCommentsUsecase(
          entityId: discountDetail.id,
          entityType: CommentableEntityType.discount,
        ),
      );
      expect(discountComments, isA<List<Comment>>());
      AppLogger.d(
        'Comment: ${discountComments.first}\nLiked: ${discountComments.first.like}',
      );

      final liked = await getOrFail(
        toggleCommentLikeUsecase(
          entityId: discountDetail.id,
          entityType: CommentableEntityType.discount,
          commentId: discountComments.first.id,
        ),
      );
      expect(liked, isA<bool>());
      AppLogger.d('Toggled comment like: $liked');
    });
  });
}
