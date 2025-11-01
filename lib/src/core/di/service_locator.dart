import 'package:get_it/get_it.dart';

import '../../shared/master_data/data/datasources/data_sources.dart';
import '../../shared/master_data/data/repositories/repositories.dart';
import '../../shared/master_data/domain/repositories/repositories.dart';
import '../../features/notifications/data/datasources/data_sources.dart';
import '../../features/notifications/data/repositories/repositories.dart';
import '../../features/notifications/domain/repositories/repositories.dart';
import '../../features/notifications/domain/usecases/usecases.dart';
import '../../features/notifications/presentation/bloc/notifications_page/notifications_list_bloc.dart';
import '../../features/polls/data/datasources/data_sources.dart';
import '../../features/polls/data/repositories/repositories.dart';
import '../../features/polls/domain/repositories/repositories.dart';
import '../../features/polls/domain/usecases/usecases.dart';
import '../auth/auth_token_provider.dart';
import '../network/api_client.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  _initializeCoreDependencies();
  _initializeMasterDataDependencies();
  _initializeNotificationDependencies();
  _initializePollDependencies();
}

void _initializeCoreDependencies() {
  // Core - Auth token provider
  sl.registerLazySingleton<AuthTokenProvider>(() => LocalAuthTokenProvider());

  // Core - Using InsecureApiClient for now
  sl.registerLazySingleton<ApiClient>(() => InsecureApiClient(sl()));
}

void _initializeMasterDataDependencies() {
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

void _initializeNotificationDependencies() {
  // Data sources
  sl.registerLazySingleton<NotificationRemoteDataSource>(() => NotificationRemoteDataSourceImpl(sl()));

  // Repositories
  sl.registerLazySingleton<NotificationRepository>(() => NotificationRepositoryImpl(sl()));

  // Use cases
  sl.registerFactory<GetNotificationsUsecase>(() => GetNotificationsUsecase(sl()));
  sl.registerFactory<MarkNotificationAsReadUsecase>(() => MarkNotificationAsReadUsecase(sl()));
  sl.registerFactory<MarkAllNotificationsAsReadUsecase>(() => MarkAllNotificationsAsReadUsecase(sl()));
  sl.registerFactory<GetUnreadNotificationsCountUsecase>(() => GetUnreadNotificationsCountUsecase(sl()));

  // BLoC
  sl.registerFactory<NotificationsListBloc>(
    () => NotificationsListBloc(
      getNotificationsUsecase: sl(),
      markNotificationAsReadUsecase: sl(),
      markAllNotificationsAsReadUsecase: sl(),
      getUnreadNotificationsCountUsecase: sl(),
    ),
  );
}

void _initializePollDependencies() {
  // Data sources
  sl.registerLazySingleton<PollRemoteDataSource>(() => PollRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<StaffRemoteDataSource>(() => StaffRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<PollDetailRemoteDataSource>(() => PollDetailRemoteDataSourceImpl(sl()));

  // Repositories
  sl.registerLazySingleton<PollRepository>(() => PollRepositoryImpl(sl()));
  sl.registerLazySingleton<StaffRepository>(() => StaffRepositoryImpl(sl()));
  sl.registerLazySingleton<PollDetailRepository>(() => PollDetailRepositoryImpl(sl()));

  // Use cases
  sl.registerFactory<GetPollsUsecase>(() => GetPollsUsecase(sl()));
  sl.registerFactory<GetStaffUsecase>(() => GetStaffUsecase(sl()));
  sl.registerFactory<GetPollDetailUsecase>(() => GetPollDetailUsecase(sl()));
}
