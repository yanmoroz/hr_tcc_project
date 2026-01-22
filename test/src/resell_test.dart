import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hr_tcc_project/src/core/auth/auth_status_notifier.dart';
import 'package:hr_tcc_project/src/core/auth/auth_token_provider.dart';
import 'package:hr_tcc_project/src/core/logging/app_logger.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/features/resell/resell.dart';

import 'helpers/result_helper.dart';

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
      apiClient = InsecureApiClient(
        authTokenProvider,
        AuthStatusNotifier(authTokenProvider),
      );
      dataSource = ResellRemoteDataSourceImpl(apiClient);
      repository = ResellRepositoryImpl(dataSource);
      getResellItemsUsecase = GetResellItemsUsecase(repository);
      getResellDetailUsecase = GetResellDetailUsecase(repository);
      bookResellItemUsecase = BookResellItemUsecase(repository);
      confirmResellBookingUsecase = ConfirmResellBookingUsecase(repository);
    });

    test('E2E', () async {
      final result = await getOrFail(
        getResellItemsUsecase(
          status: ResellStatus.onSale,
          page: 0,
          pageSize: 20,
        ),
      );
      expect(result, isA<ResellItemsResult>());
      AppLogger.d('Fetched resell items: ${result.items.length} items');

      final detail = await getOrFail(getResellDetailUsecase(result.items.first.id));
      expect(detail, isA<ResellDetail>());
      AppLogger.d('Fetched resell detail: ${detail.toString()}');

      await getOrFail(bookResellItemUsecase(detail.id));
      AppLogger.d('Booked resell item: ${detail.id}');

      await getOrFail(
        confirmResellBookingUsecase(
          params: ConfirmResellBookingParams(
            id: detail.id,
            transition: BookingTransition.confirm,
            inn: '520205004556',
            address: 'Test address',
            employeePlace: 'Test workplace',
            pickupLotMyself: true,
          ),
        ),
      );
      AppLogger.d('Confirmed resell item: ${detail.id}');

      await getOrFail(
        confirmResellBookingUsecase(
          params: ConfirmResellBookingParams(
            id: detail.id,
            transition: BookingTransition.cancel,
          ),
        ),
      );
      AppLogger.d('Cancelled resell item: ${detail.id}');
    });
  });
}
