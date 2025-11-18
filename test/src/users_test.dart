import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:hr_tcc_project/src/core/auth/auth_token_provider.dart';
import 'package:hr_tcc_project/src/core/logging/app_logger.dart';
import 'package:hr_tcc_project/src/core/network/api_client.dart';
import 'package:hr_tcc_project/src/core/value_objects/system_type.dart';
import 'package:hr_tcc_project/src/features/users/data/data.dart';
import 'package:hr_tcc_project/src/features/users/domain/domain.dart';
import 'helpers/result_helper.dart';

void main() {
  group('Users', () {
    late AuthTokenProvider authTokenProvider;
    late ApiClient apiClient;
    late UserRemoteDataSource dataSource;
    late UserRepository repository;
    late GetUsersUsecase getUsersUsecase;
    late GetAddressBookUsecase getAddressBookUsecase;
    late GetCurrentUserInfoUsecase getCurrentUserInfoUsecase;

    setUpAll(() async {
      await dotenv.load(fileName: ".env");
    });

    setUp(() {
      authTokenProvider = LocalAuthTokenProvider();
      apiClient = InsecureApiClient(authTokenProvider);
      dataSource = UserRemoteDataSourceImpl(apiClient);
      repository = UserRepositoryImpl(dataSource);
      getUsersUsecase = GetUsersUsecase(repository);
      getAddressBookUsecase = GetAddressBookUsecase(repository);
      getCurrentUserInfoUsecase = GetCurrentUserInfoUsecase(repository);
    });

    test('E2E', () async {
      final users = await getOrFail(
        getUsersUsecase(systemType: SystemType.elma),
      );
      expect(users, isA<List<User>>());
      AppLogger.d('Fetched users: ${users.length} items');

      final addressBook = await getOrFail(
        getAddressBookUsecase(page: 0, pageSize: 20),
      );
      expect(addressBook, isA<List<AddressBookUser>>());
      AppLogger.d('Fetched address book: ${addressBook.length} items');

      final currentUserInfo = await getOrFail(getCurrentUserInfoUsecase());
      expect(currentUserInfo, isA<AddressBookUser>());
      AppLogger.d('Fetched current user info: ${currentUserInfo.toString()}');
    });
  });
}
