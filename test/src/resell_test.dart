import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hr_tcc_project/src/core/auth/auth_token_provider.dart';
import 'package:hr_tcc_project/src/core/base_types/result.dart';
import 'package:hr_tcc_project/src/core/logging/app_logger.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/features/resell/data/data.dart';
import 'package:hr_tcc_project/src/features/resell/domain/domain.dart';

void main() {
  group('Resell', () {
    late AuthTokenProvider authTokenProvider;
    late ApiClient apiClient;
    late ResellRemoteDataSource dataSource;
    late ResellRepository repository;
    late GetResellItemsUsecase getResellItemsUsecase;
    late GetResellDetailUsecase getResellDetailUsecase;
    late BookResellItemUsecase bookResellItemUsecase;
    late ConfirmResellBookingUsecase confirmResellBookingUsecase;

    setUpAll(() async {
      await dotenv.load(fileName: ".env");
    });

    setUp(() {
      authTokenProvider = LocalAuthTokenProvider();
      apiClient = InsecureApiClient(authTokenProvider);
      dataSource = ResellRemoteDataSourceImpl(apiClient);
      repository = ResellRepositoryImpl(dataSource);
      getResellItemsUsecase = GetResellItemsUsecase(repository);
      getResellDetailUsecase = GetResellDetailUsecase(repository);
      bookResellItemUsecase = BookResellItemUsecase(repository);
      confirmResellBookingUsecase = ConfirmResellBookingUsecase(repository);
    });

    test('E2E', () async {
      final resellItemsResult = await getResellItemsUsecase(
        status: ResellStatus.onSale,
        page: 0,
        pageSize: 20,
      );

      await resellItemsResult.fold(
        (failure) {
          fail('Unexpected error: ${failure.message}');
        },
        (items) async {
          expect(items, isA<List<ResellItem>>());
          AppLogger.d('Fetched resell items: ${items.length} items');

          final resellDetailResult = await getResellDetailUsecase(
            items.first.id,
          );
          await resellDetailResult.fold(
            (failure) {
              fail('Unexpected error: ${failure.message}');
            },
            (detail) async {
              expect(detail, isA<ResellDetail>());
              AppLogger.d('Fetched resell detail: ${detail.toString()}');

              final bookingResult = await bookResellItemUsecase(detail.id);
              await bookingResult.fold(
                (failure) {
                  fail('Unexpected error: ${failure.message}');
                },
                (_) async {
                  AppLogger.d('Booked resell item: ${detail.id}');

                  final confirmParams = ConfirmResellBookingUsecaseParams(
                    id: detail.id,
                    transition: BookingTransition.confirm,
                    inn: '520205004556',
                    address: 'Test address',
                    employeePlace: 'Test workplace',
                    pickupLotMyself: true,
                  );
                  final confirmResult = await confirmResellBookingUsecase(
                    params: confirmParams,
                  );
                  await confirmResult.fold(
                    (failure) {
                      fail('Unexpected error: ${failure.message}');
                    },
                    (_) async {
                      AppLogger.d('Confirmed resell item: ${detail.id}');

                      final cancelResult = await confirmResellBookingUsecase(
                        params: ConfirmResellBookingUsecaseParams(
                          id: detail.id,
                          transition: BookingTransition.cancel,
                        ),
                      );
                      await cancelResult.fold(
                        (failure) {
                          fail('Unexpected error: ${failure.message}');
                        },
                        (_) {
                          AppLogger.d('Cancelled resell item: ${detail.id}');
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
  });
}
