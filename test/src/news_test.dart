import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:hr_tcc_project/src/core/auth/auth_token_provider.dart';
import 'package:hr_tcc_project/src/core/logging/app_logger.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/features/comments/comments.dart';
import 'package:hr_tcc_project/src/features/news/news.dart';

import 'helpers/result_helper.dart';

void main() {
  group('News', () {
    late AuthTokenProvider authTokenProvider;
    late ApiClient apiClient;
    late NewsRemoteDataSource dataSource;
    late NewsRepository repository;
    late GetNewsListUsecase getNewsListUsecase;
    late GetNewsDetailUsecase getNewsDetailUsecase;
    late GetNewsStatsUsecase getNewsStatsUsecase;
    late ToggleNewsLikeUsecase toggleNewsLikeUsecase;
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
      dataSource = NewsRemoteDataSourceImpl(apiClient);
      repository = NewsRepositoryImpl(dataSource);
      getNewsListUsecase = GetNewsListUsecase(repository);
      getNewsDetailUsecase = GetNewsDetailUsecase(repository);
      getNewsStatsUsecase = GetNewsStatsUsecase(repository);
      toggleNewsLikeUsecase = ToggleNewsLikeUsecase(repository);
      commentDataSource = CommentRemoteDataSourceImpl(apiClient);
      commentRepository = CommentRepositoryImpl(commentDataSource);
      getCommentsUsecase = GetCommentsUsecase(commentRepository);
      addCommentUsecase = AddCommentUsecase(commentRepository);
      deleteCommentUsecase = DeleteCommentUsecase(commentRepository);
      toggleCommentLikeUsecase = ToggleCommentLikeUsecase(commentRepository);
    });

    test('E2E Comments', () async {
      final newsList = await getOrFail(getNewsListUsecase(page: 0));
      expect(newsList, isA<List<NewsItem>>());
      AppLogger.d('Fetched news list: ${newsList.length} items');

      final newsDetail = await getOrFail(
        getNewsDetailUsecase(newsList.first.id),
      );
      expect(newsDetail, isA<NewsDetail>());
      AppLogger.d('Fetched news detail: ${newsDetail.toString()}');

      final newsStats = await getOrFail(getNewsStatsUsecase(newsDetail.id));
      expect(newsStats, isA<GetNewsStatsResults>());
      AppLogger.d('Fetched news stats: ${newsStats.toString()}');

      final newsComments = await getOrFail(
        getCommentsUsecase(
          entityId: newsDetail.id,
          entityType: CommentableEntityType.news,
        ),
      );
      expect(newsComments, isA<List<Comment>>());
      AppLogger.d('Fetched news comments: ${newsComments.length} items');

      final comment = await getOrFail(
        addCommentUsecase(
          entityId: newsDetail.id,
          entityType: CommentableEntityType.news,
          content: 'Test comment',
          parent: null,
          attachments: null,
        ),
      );
      expect(comment, isA<Comment>());
      AppLogger.d('Added comment: ${comment.toString()}');

      final updatedNewsStats = await getOrFail(
        getNewsStatsUsecase(newsDetail.id),
      );
      expect(updatedNewsStats, isA<GetNewsStatsResults>());
      AppLogger.d('Updated news stats: ${updatedNewsStats.toString()}');

      final removedIds = await getOrFail(
        deleteCommentUsecase(
          entityId: newsDetail.id,
          entityType: CommentableEntityType.news,
          commentId: comment.id,
        ),
      );
      expect(removedIds, isA<List<int>>());
      AppLogger.d('Deleted comment: ${removedIds.length} items');

      final finalNewsStats = await getOrFail(
        getNewsStatsUsecase(newsDetail.id),
      );
      expect(finalNewsStats, isA<GetNewsStatsResults>());
      AppLogger.d('Updated news stats: ${finalNewsStats.toString()}');
    });

    test('E2E Likes', () async {
      final newsList = await getOrFail(getNewsListUsecase(page: 0));
      expect(newsList, isA<List<NewsItem>>());
      AppLogger.d('Fetched news list: ${newsList.length} items');

      final newsDetail = await getOrFail(
        getNewsDetailUsecase(newsList.first.id),
      );
      expect(newsDetail, isA<NewsDetail>());
      AppLogger.d('Fetched news detail: ${newsDetail.toString()}');

      final newsStats = await getOrFail(getNewsStatsUsecase(newsDetail.id));
      expect(newsStats, isA<GetNewsStatsResults>());
      AppLogger.d('Fetched news stats: ${newsStats.toString()}');

      final liked = await getOrFail(toggleNewsLikeUsecase(newsDetail.id));
      expect(liked, isA<bool>());
      AppLogger.d('Toggled news like: $liked');

      final updatedNewsStats = await getOrFail(
        getNewsStatsUsecase(newsDetail.id),
      );
      expect(updatedNewsStats, isA<GetNewsStatsResults>());
      AppLogger.d('Updated news stats: ${updatedNewsStats.toString()}');
    });

    test('E2E Comment Likes', () async {
      final newsList = await getOrFail(getNewsListUsecase(page: 0));
      expect(newsList, isA<List<NewsItem>>());
      AppLogger.d('Fetched news list: ${newsList.length} items');

      final newsDetail = await getOrFail(
        getNewsDetailUsecase(newsList.first.id),
      );
      expect(newsDetail, isA<NewsDetail>());
      AppLogger.d('Fetched news detail: ${newsDetail.toString()}');

      final newsComments = await getOrFail(
        getCommentsUsecase(
          entityId: newsDetail.id,
          entityType: CommentableEntityType.news,
        ),
      );
      expect(newsComments, isA<List<Comment>>());
      AppLogger.d(
        'Comment: ${newsComments.first}\nLiked: ${newsComments.first.like}',
      );

      final liked = await getOrFail(
        toggleCommentLikeUsecase(
          entityId: newsDetail.id,
          entityType: CommentableEntityType.news,
          commentId: newsComments.first.id,
        ),
      );
      expect(liked, isA<bool>());
      AppLogger.d('Toggled comment like: $liked');
    });
  });
}
