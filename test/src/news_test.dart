import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:hr_tcc_project/src/core/auth/auth_token_provider.dart';
import 'package:hr_tcc_project/src/core/base_types/result.dart';
import 'package:hr_tcc_project/src/core/logging/app_logger.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/features/news/data/data.dart';
import 'package:hr_tcc_project/src/features/news/domain/domain.dart';
import 'package:hr_tcc_project/src/features/comments/data/data.dart';
import 'package:hr_tcc_project/src/features/comments/domain/domain.dart';

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
      final newsListResult = await getNewsListUsecase(page: 0);
      await newsListResult.fold(
        (failure) {
          fail('Unexpected error: ${failure.message}');
        },
        (newsList) async {
          expect(newsList, isA<List<NewsItem>>());
          AppLogger.d('Fetched news list: ${newsList.length} items');

          final newsDetailResult = await getNewsDetailUsecase(
            newsList.first.id,
          );
          await newsDetailResult.fold(
            (failure) {
              fail('Unexpected error: ${failure.message}');
            },
            (newsDetail) async {
              expect(newsDetail, isA<NewsDetail>());
              AppLogger.d('Fetched news detail: ${newsDetail.toString()}');

              final newsStatsResult = await getNewsStatsUsecase(newsDetail.id);
              await newsStatsResult.fold(
                (failure) {
                  fail('Unexpected error: ${failure.message}');
                },
                (newsStats) async {
                  expect(
                    newsStats,
                    isA<({int likeCount, bool like, int commentCount})>(),
                  );
                  AppLogger.d(
                    'Fetched news stats: likeCount: ${newsStats.likeCount}, like: ${newsStats.like}, commentCount: ${newsStats.commentCount}',
                  );

                  final newsCommentsResult = await getCommentsUsecase(
                    entityId: newsDetail.id,
                    entityType: CommentableEntityType.news,
                  );
                  await newsCommentsResult.fold(
                    (failure) {
                      fail('Unexpected error: ${failure.message}');
                    },
                    (newsComments) async {
                      expect(newsComments, isA<List<Comment>>());
                      AppLogger.d(
                        'Fetched news comments: ${newsComments.length} items',
                      );

                      final addCommentResult = await addCommentUsecase(
                        entityId: newsDetail.id,
                        entityType: CommentableEntityType.news,
                        content: 'Test comment',
                        parent: null,
                        attachments: null,
                      );
                      await addCommentResult.fold(
                        (failure) {
                          fail('Unexpected error: ${failure.message}');
                        },
                        (comment) async {
                          expect(comment, isA<Comment>());
                          AppLogger.d('Added comment: ${comment.toString()}');

                          final newsStatsResult = await getNewsStatsUsecase(
                            newsDetail.id,
                          );
                          await newsStatsResult.fold(
                            (failure) {
                              fail('Unexpected error: ${failure.message}');
                            },
                            (newsStats) async {
                              expect(
                                newsStats,
                                isA<
                                  ({int likeCount, bool like, int commentCount})
                                >(),
                              );
                              AppLogger.d(
                                'Updated news stats: ${newsStats.toString()}',
                              );

                              final deleteCommentResult =
                                  await deleteCommentUsecase(
                                    entityId: newsDetail.id,
                                    entityType: CommentableEntityType.news,
                                    commentId: comment.id,
                                  );
                              await deleteCommentResult.fold(
                                (failure) {
                                  fail('Unexpected error: ${failure.message}');
                                },
                                (removedIds) async {
                                  expect(removedIds, isA<List<int>>());
                                  AppLogger.d(
                                    'Deleted comment: ${removedIds.length} items',
                                  );

                                  final newsStatsResult =
                                      await getNewsStatsUsecase(newsDetail.id);
                                  await newsStatsResult.fold(
                                    (failure) {
                                      fail(
                                        'Unexpected error: ${failure.message}',
                                      );
                                    },
                                    (newsStats) async {
                                      expect(
                                        newsStats,
                                        isA<
                                          ({
                                            int likeCount,
                                            bool like,
                                            int commentCount,
                                          })
                                        >(),
                                      );
                                      AppLogger.d(
                                        'Updated news stats: ${newsStats.toString()}',
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      );
    });

    test('E2E Likes', () async {
      final newsListResult = await getNewsListUsecase(page: 0);
      await newsListResult.fold(
        (failure) {
          fail('Unexpected error: ${failure.message}');
        },
        (newsList) async {
          expect(newsList, isA<List<NewsItem>>());
          AppLogger.d('Fetched news list: ${newsList.length} items');

          final newsDetailResult = await getNewsDetailUsecase(
            newsList.first.id,
          );
          await newsDetailResult.fold(
            (failure) {
              fail('Unexpected error: ${failure.message}');
            },
            (newsDetail) async {
              expect(newsDetail, isA<NewsDetail>());
              AppLogger.d('Fetched news detail: ${newsDetail.toString()}');

              final newsStatsResult = await getNewsStatsUsecase(newsDetail.id);
              await newsStatsResult.fold(
                (failure) {
                  fail('Unexpected error: ${failure.message}');
                },
                (newsStats) async {
                  expect(
                    newsStats,
                    isA<({int likeCount, bool like, int commentCount})>(),
                  );
                  AppLogger.d(
                    'Fetched news stats: likeCount: ${newsStats.likeCount}, like: ${newsStats.like}, commentCount: ${newsStats.commentCount}',
                  );

                  final toggleNewsLikeResult = await toggleNewsLikeUsecase(
                    newsDetail.id,
                  );
                  await toggleNewsLikeResult.fold(
                    (failure) {
                      fail('Unexpected error: ${failure.message}');
                    },
                    (liked) async {
                      expect(liked, isA<bool>());
                      AppLogger.d('Toggled news like: $liked');
                    },
                  );

                  final newsStatsResult = await getNewsStatsUsecase(
                    newsDetail.id,
                  );
                  await newsStatsResult.fold(
                    (failure) {
                      fail('Unexpected error: ${failure.message}');
                    },
                    (newsStats) async {
                      expect(
                        newsStats,
                        isA<({int likeCount, bool like, int commentCount})>(),
                      );
                      AppLogger.d(
                        'Updated news stats: ${newsStats.toString()}',
                      );
                    },
                  );
                },
              );
            },
          );
        },
      );
    });

    test('E2E Comment Likes', () async {
      final newsListResult = await getNewsListUsecase(page: 0);
      await newsListResult.fold(
        (failure) {
          fail('Unexpected error: ${failure.message}');
        },
        (newsList) async {
          expect(newsList, isA<List<NewsItem>>());
          AppLogger.d('Fetched news list: ${newsList.length} items');

          final newsDetailResult = await getNewsDetailUsecase(
            newsList.first.id,
          );
          await newsDetailResult.fold(
            (failure) {
              fail('Unexpected error: ${failure.message}');
            },
            (newsDetail) async {
              expect(newsDetail, isA<NewsDetail>());
              AppLogger.d('Fetched news detail: ${newsDetail.toString()}');

              final newsCommentsResult = await getCommentsUsecase(
                entityId: newsDetail.id,
                entityType: CommentableEntityType.news,
              );
              await newsCommentsResult.fold(
                (failure) {
                  fail('Unexpected error: ${failure.message}');
                },
                (newsComments) async {
                  expect(newsComments, isA<List<Comment>>());
                  AppLogger.d(
                    '''Fetched news comments: ${newsComments.length} items
The 1st comment: ${newsComments.first}''',
                  );

                  final toggleCommentLikeResult =
                      await toggleCommentLikeUsecase(
                        entityId: newsDetail.id,
                        entityType: CommentableEntityType.news,
                        commentId: newsComments.first.id,
                      );
                  await toggleCommentLikeResult.fold(
                    (failure) {
                      fail('Unexpected error: ${failure.message}');
                    },
                    (liked) async {
                      expect(liked, isA<bool>());
                      AppLogger.d('Toggled comment like: $liked');
                    },
                  );
                },
              );
            },
          );
        },
      );
    });
  });
}
