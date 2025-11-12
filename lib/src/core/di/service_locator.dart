import 'package:get_it/get_it.dart';

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
import '../../features/resell/data/data.dart';
import '../../features/resell/domain/domain.dart';
import '../../features/resell/presentation/bloc/resell_items_bloc.dart';
import '../../features/resell/presentation/bloc/resell_detail_bloc.dart';
import '../../features/resell/presentation/bloc/resell_booking_bloc.dart';
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
  _initializeResellDependencies();
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
    instanceName: 'discountComments',
  );

  // Shared like data source with discount-specific endpoints
  sl.registerLazySingleton<LikeRemoteDataSource>(
    () => LikeRemoteDataSourceImpl(
      apiClient: sl(),
      toggleEntityLikeEndpoint: ApiConstants.discountLikeEndpoint,
      toggleCommentLikeEndpoint: ApiConstants.commentLikeEndpoint,
    ),
    instanceName: 'discountLikes',
  );

  // Repositories
  sl.registerLazySingleton<DiscountRepository>(() => DiscountRepositoryImpl(sl()));
  sl.registerLazySingleton<CommentRepository>(
    () => CommentRepositoryImpl(sl(instanceName: 'discountComments')),
    instanceName: 'discountCommentRepository',
  );
  sl.registerLazySingleton<LikeRepository>(
    () => LikeRepositoryImpl(sl(instanceName: 'discountLikes')),
    instanceName: 'discountLikeRepository',
  );

  // Use cases
  sl.registerFactory<GetDiscountsUsecase>(() => GetDiscountsUsecase(sl()));
  sl.registerFactory<GetDiscountDetailUsecase>(() => GetDiscountDetailUsecase(sl()));
  sl.registerFactory<GetDiscountStatsUsecase>(() => GetDiscountStatsUsecase(sl()));
  sl.registerFactory<ToggleDiscountLikeUsecase>(
    () => ToggleDiscountLikeUsecase(sl(instanceName: 'discountLikeRepository')),
  );
  sl.registerFactory<GetCommentsUsecase>(
    () => GetCommentsUsecase(sl(instanceName: 'discountCommentRepository')),
    instanceName: 'getDiscountCommentsUsecase',
  );
  sl.registerFactory<AddCommentUsecase>(
    () => AddCommentUsecase(sl(instanceName: 'discountCommentRepository')),
    instanceName: 'addDiscountCommentUsecase',
  );
  sl.registerFactory<DeleteCommentUsecase>(
    () => DeleteCommentUsecase(sl(instanceName: 'discountCommentRepository')),
    instanceName: 'deleteDiscountCommentUsecase',
  );
  sl.registerFactory<ToggleCommentLikeUsecase>(
    () => ToggleCommentLikeUsecase(sl(instanceName: 'discountLikeRepository')),
    instanceName: 'toggleDiscountCommentLikeUsecase',
  );
}

void _initializeNewsDependencies() {
  // Data sources
  sl.registerLazySingleton<NewsRemoteDataSource>(() => NewsRemoteDataSourceImpl(sl()));

  // Shared comment data source with news-specific endpoints
  sl.registerLazySingleton<CommentRemoteDataSource>(
    () => CommentRemoteDataSourceImpl(
      apiClient: sl(),
      getCommentsEndpoint: ApiConstants.newsCommentsEndpoint,
      addCommentEndpoint: ApiConstants.newsCommentsEndpoint,
      deleteCommentEndpoint: ApiConstants.newsCommentEndpoint,
    ),
    instanceName: 'newsComments',
  );

  // Shared like data source with news-specific endpoints
  sl.registerLazySingleton<LikeRemoteDataSource>(
    () => LikeRemoteDataSourceImpl(
      apiClient: sl(),
      toggleEntityLikeEndpoint: ApiConstants.newsLikeEndpoint,
      toggleCommentLikeEndpoint: ApiConstants.newsCommentLikeEndpoint,
    ),
    instanceName: 'newsLikes',
  );

  // Repositories
  sl.registerLazySingleton<NewsRepository>(() => NewsRepositoryImpl(sl()));
  sl.registerLazySingleton<CommentRepository>(
    () => CommentRepositoryImpl(sl(instanceName: 'newsComments')),
    instanceName: 'newsCommentRepository',
  );
  sl.registerLazySingleton<LikeRepository>(
    () => LikeRepositoryImpl(sl(instanceName: 'newsLikes')),
    instanceName: 'newsLikeRepository',
  );

  // Use cases
  sl.registerFactory<GetNewsListUsecase>(() => GetNewsListUsecase(sl()));
  sl.registerFactory<GetNewsDetailUsecase>(() => GetNewsDetailUsecase(sl()));
  sl.registerFactory<GetNewsStatsUsecase>(() => GetNewsStatsUsecase(sl()));
  sl.registerFactory<GetNewsGalleryUsecase>(() => GetNewsGalleryUsecase(sl()));
  sl.registerFactory<ToggleNewsLikeUsecase>(() => ToggleNewsLikeUsecase(sl(instanceName: 'newsLikeRepository')));

  // Comment use cases for news feature
  sl.registerFactory<GetCommentsUsecase>(
    () => GetCommentsUsecase(sl(instanceName: 'newsCommentRepository')),
    instanceName: 'getNewsCommentsUsecase',
  );
  sl.registerFactory<AddCommentUsecase>(
    () => AddCommentUsecase(sl(instanceName: 'newsCommentRepository')),
    instanceName: 'addNewsCommentUsecase',
  );
  sl.registerFactory<DeleteCommentUsecase>(
    () => DeleteCommentUsecase(sl(instanceName: 'newsCommentRepository')),
    instanceName: 'deleteNewsCommentUsecase',
  );
  sl.registerFactory<ToggleCommentLikeUsecase>(
    () => ToggleCommentLikeUsecase(sl(instanceName: 'newsLikeRepository')),
    instanceName: 'toggleNewsCommentLikeUsecase',
  );
}

void _initializeResellDependencies() {
  // Data sources
  sl.registerLazySingleton<ResellRemoteDataSource>(() => ResellRemoteDataSourceImpl(sl()));

  // Repositories
  sl.registerLazySingleton<ResellRepository>(() => ResellRepositoryImpl(sl()));

  // Use cases
  sl.registerFactory<GetResellItemsUsecase>(() => GetResellItemsUsecase(sl()));
  sl.registerFactory<GetResellDetailUsecase>(() => GetResellDetailUsecase(sl()));
  sl.registerFactory<BookResellItemUsecase>(() => BookResellItemUsecase(sl()));
  sl.registerFactory<ConfirmResellBookingUsecase>(() => ConfirmResellBookingUsecase(sl()));

  // BLoCs
  sl.registerFactory<ResellItemsBloc>(() => ResellItemsBloc(sl()));
  sl.registerFactory<ResellDetailBloc>(() => ResellDetailBloc(sl(), sl()));
  sl.registerFactoryParam<ResellBookingBloc, ResellBooking, void>(
    (booking, _) => ResellBookingBloc(sl(), booking),
  );
}
