import 'package:get_it/get_it.dart';

import '../../shared/master_data/data/data.dart';
import '../../shared/master_data/domain/domain.dart';
import '../../features/notifications/data/data.dart';
import '../../features/notifications/domain/domain.dart';
import '../../features/polls/data/data.dart';
import '../../features/polls/domain/domain.dart';
import '../../features/users/data/data.dart';
import '../../features/users/domain/domain.dart';
import '../../features/discounts/data/data.dart';
import '../../features/discounts/domain/domain.dart';
import '../../features/news/data/data.dart';
import '../../features/news/domain/domain.dart';
import '../auth/auth_token_provider.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';
import '../files/files.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  _initializeCoreDependencies();
  _initializeFileDependencies();
  _initializeMasterDataDependencies();
  _initializeNotificationDependencies();
  _initializePollDependencies();
  _initializeUserDependencies();
  _initializeDiscountDependencies();
  _initializeNewsDependencies();
}

void _initializeCoreDependencies() {
  // Core - Auth token provider
  sl.registerLazySingleton<AuthTokenProvider>(() => LocalAuthTokenProvider());

  // Core - Using InsecureApiClient for now
  sl.registerLazySingleton<ApiClient>(() => InsecureApiClient(sl()));
}

void _initializeFileDependencies() {
  // Data sources
  sl.registerLazySingleton<FileRemoteDataSource>(() => FileRemoteDataSourceImpl(sl()));

  // Repositories
  sl.registerLazySingleton<FileRepository>(() => FileRepositoryImpl(sl()));

  // Use cases
  sl.registerFactory<UploadFileUsecase>(() => UploadFileUsecase(sl()));
  sl.registerFactory<DownloadFileUsecase>(() => DownloadFileUsecase(sl()));
  sl.registerFactory<ClearFileCacheUsecase>(() => ClearFileCacheUsecase());
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

  // Use cases
  sl.registerFactory<GetKpDiscountCategoriesUsecase>(() => GetKpDiscountCategoriesUsecase(sl()));
  sl.registerFactory<GetKpDiscountSourcesUsecase>(() => GetKpDiscountSourcesUsecase(sl()));
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
  sl.registerFactory<SubmitPollAnswersUsecase>(() => SubmitPollAnswersUsecase(sl()));
}

void _initializeUserDependencies() {
  // Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(sl()));

  // Repositories
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl()));

  // Use cases
  sl.registerFactory<GetUsersUsecase>(() => GetUsersUsecase(sl()));
}

void _initializeDiscountDependencies() {
  // Data sources
  sl.registerLazySingleton<DiscountRemoteDataSource>(() => DiscountRemoteDataSourceImpl(sl()));

  // Shared comment data source with discount-specific endpoints
  sl.registerLazySingleton<CommentRemoteDataSource>(
    () => CommentRemoteDataSourceImpl(
      apiClient: sl(),
      getCommentsEndpoint: ApiConstants.discountCommentsEndpoint,
      addCommentEndpoint: ApiConstants.discountCommentsEndpoint,
      deleteCommentEndpoint: ApiConstants.discountCommentEndpoint,
    ),
  );

  // Shared like data source with discount-specific endpoints
  sl.registerLazySingleton<LikeRemoteDataSource>(
    () => LikeRemoteDataSourceImpl(
      apiClient: sl(),
      toggleEntityLikeEndpoint: ApiConstants.discountLikeEndpoint,
      toggleCommentLikeEndpoint: ApiConstants.commentLikeEndpoint,
    ),
  );

  // Repositories
  sl.registerLazySingleton<DiscountRepository>(() => DiscountRepositoryImpl(sl()));
  sl.registerLazySingleton<CommentRepository>(() => CommentRepositoryImpl(sl()));
  sl.registerLazySingleton<LikeRepository>(() => LikeRepositoryImpl(sl()));

  // Use cases
  sl.registerFactory<GetDiscountsUsecase>(() => GetDiscountsUsecase(sl()));
  sl.registerFactory<GetDiscountDetailUsecase>(() => GetDiscountDetailUsecase(sl()));
  sl.registerFactory<GetDiscountStatsUsecase>(() => GetDiscountStatsUsecase(sl()));
  sl.registerFactory<ToggleDiscountLikeUsecase>(() => ToggleDiscountLikeUsecase(sl()));
  sl.registerFactory<GetCommentsUsecase>(() => GetCommentsUsecase(sl()));
  sl.registerFactory<AddCommentUsecase>(() => AddCommentUsecase(sl()));
  sl.registerFactory<DeleteCommentUsecase>(() => DeleteCommentUsecase(sl()));
  sl.registerFactory<ToggleCommentLikeUsecase>(() => ToggleCommentLikeUsecase(sl()));
}

void _initializeNewsDependencies() {
  // Data sources
  sl.registerLazySingleton<NewsRemoteDataSource>(() => NewsRemoteDataSourceImpl(sl()));

  // Repositories
  sl.registerLazySingleton<NewsRepository>(() => NewsRepositoryImpl(sl()));

  // Use cases
  sl.registerFactory<GetNewsListUsecase>(() => GetNewsListUsecase(sl()));
  sl.registerFactory<GetNewsDetailUsecase>(() => GetNewsDetailUsecase(sl()));
  sl.registerFactory<GetNewsStatsUsecase>(() => GetNewsStatsUsecase(sl()));
  sl.registerFactory<GetNewsGalleryUsecase>(() => GetNewsGalleryUsecase(sl()));
  sl.registerFactory<ToggleNewsLikeUsecase>(() => ToggleNewsLikeUsecase(sl()));
}
