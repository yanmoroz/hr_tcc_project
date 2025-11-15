import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hr_tcc_project/src/core/auth/auth_token_provider.dart';
import 'package:hr_tcc_project/src/core/logging/app_logger.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/core/base_types/result.dart';
import 'package:hr_tcc_project/src/features/discounts/data/data.dart';

void main() {
  group('DiscountRemoteDataSource', () {
    late DiscountRemoteDataSource dataSource;
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
      dataSource = DiscountRemoteDataSourceImpl(apiClient);
    });

    group('getDiscounts', () {
      test('should fetch discounts from API and map to models', () async {
        // Act
        final result = await dataSource.getDiscounts(
          category: 2,
          source: 1,
          page: 0,
        );

        // Assert
        result.fold(
          (failure) {
            fail('Unexpected error: ${failure.message}');
          },
          (response) {
            expect(response, isA<DiscountListResponse>());
            expect(response.discounts, isA<List<DiscountModel>>());
            AppLogger.d(
              'Fetched discounts: ${response.discounts.map((d) => d.toString()).join('\n')}',
            );
          },
        );
      });
    });

    group('getDiscountDetail', () {
      test(
        'should fetch discount detail by id from API and map to model',
        () async {
          // Act
          final result = await dataSource.getDiscountDetail(49);

          // Assert
          result.fold(
            (failure) {
              fail('Unexpected error: ${failure.message}');
            },
            (detail) {
              expect(detail, isA<DiscountDetailModel>());
              expect(detail.id, equals(49));
              AppLogger.d('Fetched discount detail: ${detail.toString()}');
            },
          );
        },
      );
    });

    group('getDiscountStats', () {
      test(
        'should fetch discount stats by id from API and map to model',
        () async {
          // Act
          final result = await dataSource.getDiscountStats(49);

          // Assert
          result.fold(
            (failure) {
              fail('Unexpected error: ${failure.message}');
            },
            (stats) {
              expect(stats, isA<StatsResponse>());
              AppLogger.d(
                'Fetched discount stats: likes=${stats.likeCount}, comments=${stats.commentCount}',
              );
            },
          );
        },
      );
    });
  });
}
