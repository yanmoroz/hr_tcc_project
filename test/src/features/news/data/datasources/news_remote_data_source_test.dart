import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hr_tcc_project/src/core/auth/auth_token_provider.dart';
import 'package:hr_tcc_project/src/core/logging/app_logger.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/core/base_types/result.dart';
import 'package:hr_tcc_project/src/features/news/data/data.dart';

void main() {
  group('NewsRemoteDataSource', () {
    late NewsRemoteDataSource dataSource;
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
      dataSource = NewsRemoteDataSourceImpl(apiClient);
    });

    group('getNewsList', () {
      test('should fetch news list from API and map to models', () async {
        // Act
        final result = await dataSource.getNewsList(page: 0);

        // Assert
        result.fold(
          (failure) {
            fail('Unexpected error: ${failure.message}');
          },
          (response) {
            expect(response, isA<NewsListResponse>());
            expect(response.items, isA<List<NewsItemModel>>());
            AppLogger.d(
              'Fetched news: ${response.items.length} items, total: ${response.total}',
            );
          },
        );
      });
    });

    group('getNewsDetail', () {
      test(
        'should fetch news detail by id from API and map to model',
        () async {
          // Act - Using news ID 100 for testing
          final result = await dataSource.getNewsDetail(100);

          // Assert
          result.fold(
            (failure) {
              fail('Unexpected error: ${failure.message}');
            },
            (detail) {
              expect(detail, isA<NewsDetailModel>());
              expect(detail.id, equals(100));
              AppLogger.d('Fetched news detail: ${detail.toString()}');
            },
          );
        },
      );
    });

    group('getNewsStats', () {
      test('should fetch news stats by id from API and map to model', () async {
        // Act - Using news ID 100 for testing
        final result = await dataSource.getNewsStats(100);

        // Assert
        result.fold(
          (failure) {
            fail('Unexpected error: ${failure.message}');
          },
          (stats) {
            expect(stats, isA<NewsStatsModel>());
            AppLogger.d(
              'Fetched news stats: likes=${stats.likeCount}, comments=${stats.commentCount}',
            );
          },
        );
      });
    });

    group('getNewsGallery', () {
      test(
        'should fetch news gallery by galleryId from API and map to models',
        () async {
          // Act - Using gallery ID 1 for testing
          final result = await dataSource.getNewsGallery(1);

          // Assert
          result.fold(
            (failure) {
              fail('Unexpected error: ${failure.message}');
            },
            (gallery) {
              expect(gallery, isA<GalleryResponse>());
              expect(gallery.items, isA<List<GalleryImageModel>>());
              AppLogger.d(
                'Fetched gallery: ${gallery.items.map((i) => i.id.toString()).join('\n')}',
              );
            },
          );
        },
      );
    });
  });
}
