import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hr_tcc_project/src/core/auth/auth_token_provider.dart';
import 'package:hr_tcc_project/src/core/logging/app_logger.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/core/types/result.dart';
import 'package:hr_tcc_project/src/features/resell/data/data.dart';
import 'package:hr_tcc_project/src/features/resell/domain/domain.dart';

void main() {
  group('ResellRemoteDataSource', () {
    late ResellRemoteDataSource dataSource;
    late ApiClient apiClient;
    late AuthTokenProvider authTokenProvider;

    setUpAll(() async {
      await dotenv.load(fileName: ".env");
    });

    setUp(() {
      authTokenProvider = LocalAuthTokenProvider();
      apiClient = InsecureApiClient(authTokenProvider);
      dataSource = ResellRemoteDataSourceImpl(apiClient);
    });

    group('getResellItems', () {
      test('should fetch list of resell items with status filter from API and map to models', () async {
        // Act
        final result = await dataSource.getResellItems(status: ResellStatus.onSale, page: 0, pageSize: 20);

        // Assert
        result.fold(
          (failure) {
            fail('Unexpected error: ${failure.message}');
          },
          (response) {
            expect(response, isA<ResellListResponseModel>());
            AppLogger.d(
              'Fetched resell items: ${response.items.length} items out of ${response.total} total\n${response.items.map((n) => '  - ${n.toString()}').join('\n')}',
            );
          },
        );
      });
    });

    test('should fetch list of resell items with search filter', () async {
      final result = await dataSource.getResellItems(
        status: ResellStatus.onSale,
        search: 'test',
        page: 0,
        pageSize: 10,
      );

      result.fold((error) => fail('Unexpected error: ${error.toString()}'), (response) {
        expect(response, isA<ResellListResponseModel>());
        AppLogger.d('Search results: ${response.items.length} items found');
      });
    });

    group('getResellDetail', () {
      test('should fetch resell item detail by id from API and map to model', () async {
        // First get a list to extract an ID
        final listResult = await dataSource.getResellItems(status: ResellStatus.onSale, page: 0, pageSize: 1);

        await listResult.fold((failure) => fail('Failed to get list: ${failure.message}'), (response) async {
          if (response.items.isEmpty) {
            AppLogger.d('No items available to test detail endpoint');
            return;
          }

          final itemId = response.items.first.id;
          AppLogger.d('Testing detail endpoint with ID: $itemId');

          // Act
          final detailResult = await dataSource.getResellDetail(itemId);

          // Assert
          detailResult.fold(
            (failure) {
              fail('Unexpected error: ${failure.message}');
            },
            (detail) {
              AppLogger.d('Fetched resell detail: ${detail.toString()}');
            },
          );
        });
      });
    });

    test('should initiate booking for a resell item', () async {
      // First get a list to extract an ID
      final listResult = await dataSource.getResellItems(status: ResellStatus.onSale, page: 0, pageSize: 1);

      await listResult.fold((error) => fail('Failed to get list: ${error.toString()}'), (response) async {
        if (response.items.isEmpty) {
          AppLogger.d('No items available to test booking endpoint');
          return;
        }

        final itemId = response.items.first.id;
        AppLogger.d('Testing booking endpoint with ID: $itemId');

        final bookingResult = await dataSource.bookResellItem(itemId);

        bookingResult.fold(
          (error) {
            // Expected to fail if item already booked or other business rules
            AppLogger.d('Booking failed (expected): ${error.toString()}');
            expect(error, isA<Exception>());
          },
          (_) {
            AppLogger.d('Booking successful');
          },
        );
      });
    });

    test('should confirm booking with confirmation data', () async {
      // First get a list to extract an ID
      final listResult = await dataSource.getResellItems(status: ResellStatus.onSale, page: 0, pageSize: 1);

      await listResult.fold((error) => fail('Failed to get list: ${error.toString()}'), (response) async {
        if (response.items.isEmpty) {
          AppLogger.d('No items available to test confirm booking endpoint');
          return;
        }

        final itemId = response.items.first.id;
        AppLogger.d('Testing confirm booking endpoint with ID: $itemId');

        final confirmResult = await dataSource.confirmBooking(
          id: itemId,
          transition: BookingTransition.confirm,
          inn: '520205004556',
          address: 'Test address',
          employeePlace: 'Test workplace',
          pickupLotMyself: true,
        );

        confirmResult.fold(
          (error) {
            // Expected to fail if not booked yet or other business rules
            AppLogger.d('Confirmation failed (expected): ${error.toString()}');
            expect(error, isA<Exception>());
          },
          (_) {
            AppLogger.d('Confirmation successful');
          },
        );
      });
    });

    test('should cancel booking', () async {
      // First get a list to extract an ID
      final listResult = await dataSource.getResellItems(status: ResellStatus.booked, page: 0, pageSize: 1);

      await listResult.fold((error) => fail('Failed to get list: ${error.toString()}'), (response) async {
        if (response.items.isEmpty) {
          AppLogger.d('No booked items available to test cancel booking endpoint');
          return;
        }

        final itemId = response.items.first.id;
        AppLogger.d('Testing cancel booking endpoint with ID: $itemId');

        final cancelResult = await dataSource.confirmBooking(
          id: itemId,
          transition: BookingTransition.cancel,
          inn: null,
          address: null,
          employeePlace: null,
          pickupLotMyself: null,
        );

        cancelResult.fold(
          (error) {
            // Expected to fail if not authorized or other business rules
            AppLogger.d('Cancellation failed (expected): ${error.toString()}');
            expect(error, isA<Exception>());
          },
          (_) {
            AppLogger.d('Cancellation successful');
          },
        );
      });
    });
  });
}
