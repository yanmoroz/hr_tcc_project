import 'package:get_it/get_it.dart';

import '../../shared/master_data/data/datasources/data_sources.dart';
import '../../shared/master_data/data/repositories/repositories.dart';
import '../../shared/master_data/domain/repositories/repositories.dart';
import '../auth/auth_token_provider.dart';
import '../network/api_client.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Core - Auth token provider
  sl.registerLazySingleton<AuthTokenProvider>(() => LocalAuthTokenProvider());

  // Core - Using InsecureApiClient for now
  sl.registerLazySingleton<ApiClient>(() => InsecureApiClient(sl()));

  // Data sources
  sl.registerLazySingleton<ViolationSecurityLevelRemoteDataSource>(
    () => ViolationSecurityLevelRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<ViolationSecurityLevelRepository>(() => ViolationSecurityLevelRepositoryImpl(sl()));
}
