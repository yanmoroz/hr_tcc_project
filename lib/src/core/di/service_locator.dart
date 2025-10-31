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
  sl.registerLazySingleton<CoreDictionariesRemoteDataSource>(() => CoreDictionariesRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<ViolationSecurityLevelRemoteDataSource>(
    () => ViolationSecurityLevelRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<UnplannedTrainingContractorRemoteDataSource>(
    () => UnplannedTrainingContractorRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ResellEquipmentTypeRemoteDataSource>(() => ResellEquipmentTypeRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<ReferralProgramCandidateRemoteDataSource>(
    () => ReferralProgramCandidateRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ReferralProgramVacancyRemoteDataSource>(
    () => ReferralProgramVacancyRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<KpAbsenceCategoryRemoteDataSource>(() => KpAbsenceCategoryRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<KpDiscountCategoryRemoteDataSource>(() => KpDiscountCategoryRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<KpDiscountSourceRemoteDataSource>(() => KpDiscountSourceRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<KpOfficeRemoteDataSource>(() => KpOfficeRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<KpNewsCategoryRemoteDataSource>(() => KpNewsCategoryRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<KpParkingTypeRemoteDataSource>(() => KpParkingTypeRemoteDataSourceImpl(sl()));

  // Repositories
  sl.registerLazySingleton<CoreDictionariesRepository>(() => CoreDictionariesRepositoryImpl(sl()));
  sl.registerLazySingleton<ViolationSecurityLevelRepository>(() => ViolationSecurityLevelRepositoryImpl(sl()));
  sl.registerLazySingleton<UnplannedTrainingContractorRepository>(
    () => UnplannedTrainingContractorRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ResellEquipmentTypeRepository>(() => ResellEquipmentTypeRepositoryImpl(sl()));
  sl.registerLazySingleton<ReferralProgramCandidateRepository>(() => ReferralProgramCandidateRepositoryImpl(sl()));
  sl.registerLazySingleton<ReferralProgramVacancyRepository>(() => ReferralProgramVacancyRepositoryImpl(sl()));
  sl.registerLazySingleton<KpAbsenceCategoryRepository>(() => KpAbsenceCategoryRepositoryImpl(sl()));
  sl.registerLazySingleton<KpDiscountCategoryRepository>(() => KpDiscountCategoryRepositoryImpl(sl()));
  sl.registerLazySingleton<KpDiscountSourceRepository>(() => KpDiscountSourceRepositoryImpl(sl()));
  sl.registerLazySingleton<KpOfficeRepository>(() => KpOfficeRepositoryImpl(sl()));
  sl.registerLazySingleton<KpNewsCategoryRepository>(() => KpNewsCategoryRepositoryImpl(sl()));
  sl.registerLazySingleton<KpParkingTypeRepository>(() => KpParkingTypeRepositoryImpl(sl()));
}
