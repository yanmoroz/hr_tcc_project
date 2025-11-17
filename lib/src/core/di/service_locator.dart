import 'package:get_it/get_it.dart';

import '../../features/applications/data/data.dart';
import '../../features/applications/domain/domain.dart';
import '../../features/discounts/data/data.dart';
import '../../features/discounts/domain/domain.dart';
import '../../features/news/data/data.dart';
import '../../features/news/domain/domain.dart';
import '../../features/notifications/data/data.dart';
import '../../features/notifications/domain/domain.dart';
import '../../features/polls/data/data.dart';
import '../../features/polls/domain/domain.dart';
import '../../features/resell/data/data.dart';
import '../../features/resell/domain/domain.dart';
import '../../features/resell/presentation/bloc/resell_booking_bloc.dart';
import '../../features/resell/presentation/bloc/resell_detail_bloc.dart';
import '../../features/resell/presentation/bloc/resell_items_bloc.dart';
import '../../features/users/data/data.dart';
import '../../features/users/domain/domain.dart';
import '../../shared/comments/data/data.dart';
import '../../shared/comments/domain/domain.dart';
import '../../shared/files/files.dart';
import '../auth/auth_token_provider.dart';
import '../master_data/datasources/master_data_remote_data_source.dart';
import '../master_data/datasources/master_data_remote_data_source_impl.dart';
import '../master_data/master_data_cache.dart';
import '../master_data/repositories/master_data_repository.dart';
import '../master_data/repositories/master_data_repository_impl.dart';
import '../network/api_client.dart';

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
  _initializeApplicationDependencies();
}

void _initializeCoreDependencies() {
  sl.registerLazySingleton<AuthTokenProvider>(() => LocalAuthTokenProvider());
  sl.registerLazySingleton<ApiClient>(() => InsecureApiClient(sl()));
}

void _initializeFileDependencies() {
  // Data sources
  sl.registerLazySingleton<FileRemoteDataSource>(
    () => FileRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<FileRepository>(() => FileRepositoryImpl(sl()));

  // Use cases
  sl.registerFactory<UploadFileUsecase>(() => UploadFileUsecase(sl()));
  sl.registerFactory<DownloadFileUsecase>(() => DownloadFileUsecase(sl()));
  sl.registerFactory<ClearFileCacheUsecase>(() => ClearFileCacheUsecase());
}

void _initializeMasterDataDependencies() {
  sl.registerLazySingleton<MasterDataCache>(() => MasterDataCache());
  sl.registerLazySingleton<MasterDataRemoteDataSource>(
    () => MasterDataRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<MasterDataRepository>(
    () => MasterDataRepositoryImpl(sl(), sl()),
  );
}

void _initializeNotificationDependencies() {
  // Data sources
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerFactory<GetNotificationsUsecase>(
    () => GetNotificationsUsecase(sl()),
  );
  sl.registerFactory<MarkNotificationAsReadUsecase>(
    () => MarkNotificationAsReadUsecase(sl()),
  );
  sl.registerFactory<MarkAllNotificationsAsReadUsecase>(
    () => MarkAllNotificationsAsReadUsecase(sl()),
  );
  sl.registerFactory<GetUnreadNotificationsCountUsecase>(
    () => GetUnreadNotificationsCountUsecase(sl()),
  );
}

void _initializePollDependencies() {
  // Data sources
  sl.registerLazySingleton<PollRemoteDataSource>(
    () => PollRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<StaffRemoteDataSource>(
    () => StaffRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<PollDetailRemoteDataSource>(
    () => PollDetailRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<PollRepository>(() => PollRepositoryImpl(sl()));
  sl.registerLazySingleton<StaffRepository>(() => StaffRepositoryImpl(sl()));
  sl.registerLazySingleton<PollDetailRepository>(
    () => PollDetailRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerFactory<GetPollsUsecase>(() => GetPollsUsecase(sl()));
  sl.registerFactory<GetStaffUsecase>(() => GetStaffUsecase(sl()));
  sl.registerFactory<GetPollDetailUsecase>(() => GetPollDetailUsecase(sl()));
  sl.registerFactory<SubmitPollAnswersUsecase>(
    () => SubmitPollAnswersUsecase(sl()),
  );
}

void _initializeUserDependencies() {
  // Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl()));

  // Use cases
  sl.registerFactory<GetUsersUsecase>(() => GetUsersUsecase(sl()));
  sl.registerFactory<GetAddressBookUsecase>(() => GetAddressBookUsecase(sl()));
  sl.registerFactory<GetCurrentUserInfoUsecase>(
    () => GetCurrentUserInfoUsecase(sl()),
  );
}

void _initializeDiscountDependencies() {
  // Data sources
  sl.registerLazySingleton<DiscountRemoteDataSource>(
    () => DiscountRemoteDataSourceImpl(sl()),
  );

  // Shared comment data source with discount-specific endpoints
  sl.registerLazySingleton<CommentRemoteDataSource>(
    () => CommentRemoteDataSourceImpl(apiClient: sl()),
    instanceName: 'discountComments',
  );

  // Repositories
  sl.registerLazySingleton<DiscountRepository>(
    () => DiscountRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<CommentRepository>(
    () => CommentRepositoryImpl(sl(instanceName: 'discountComments')),
    instanceName: 'discountCommentRepository',
  );

  // Use cases
  sl.registerFactory<GetDiscountsUsecase>(() => GetDiscountsUsecase(sl()));
  sl.registerFactory<GetDiscountDetailUsecase>(
    () => GetDiscountDetailUsecase(sl()),
  );
  sl.registerFactory<GetDiscountStatsUsecase>(
    () => GetDiscountStatsUsecase(sl()),
  );
  sl.registerFactory<ToggleDiscountLikeUsecase>(
    () => ToggleDiscountLikeUsecase(sl<DiscountRepository>()),
  );
  sl.registerFactory<GetDiscountCommentsUsecase>(
    () => GetDiscountCommentsUsecase(
      sl(instanceName: 'discountCommentRepository'),
    ),
    instanceName: 'getDiscountCommentsUsecase',
  );
  sl.registerFactory<AddCommentUsecase>(
    () => AddDiscountCommentUsecase(
      sl(instanceName: 'discountCommentRepository'),
    ),
    instanceName: 'addDiscountCommentUsecase',
  );
  sl.registerFactory<DeleteCommentUsecase>(
    () => DeleteDiscountCommentUsecase(
      sl(instanceName: 'discountCommentRepository'),
    ),
    instanceName: 'deleteDiscountCommentUsecase',
  );
  sl.registerFactory<ToggleDiscountCommentLikeUsecase>(
    () => ToggleDiscountCommentLikeUsecase(sl()),
  );
  sl.registerFactory<GetKpDiscountCategoriesUsecase>(
    () => GetKpDiscountCategoriesUsecase(sl()),
  );
  sl.registerFactory<GetKpDiscountSourcesUsecase>(
    () => GetKpDiscountSourcesUsecase(sl()),
  );
}

void _initializeNewsDependencies() {
  // Data sources
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(sl()),
  );

  // Shared comment data source with news-specific endpoints
  sl.registerLazySingleton<CommentRemoteDataSource>(
    () => CommentRemoteDataSourceImpl(apiClient: sl()),
    instanceName: 'newsComments',
  );

  // Repositories
  sl.registerLazySingleton<NewsRepository>(() => NewsRepositoryImpl(sl()));
  sl.registerLazySingleton<CommentRepository>(
    () => CommentRepositoryImpl(sl(instanceName: 'newsComments')),
    instanceName: 'newsCommentRepository',
  );

  // Use cases
  sl.registerFactory<GetNewsListUsecase>(() => GetNewsListUsecase(sl()));
  sl.registerFactory<GetNewsDetailUsecase>(() => GetNewsDetailUsecase(sl()));
  sl.registerFactory<GetNewsStatsUsecase>(() => GetNewsStatsUsecase(sl()));
  sl.registerFactory<GetNewsGalleryUsecase>(() => GetNewsGalleryUsecase(sl()));
  sl.registerFactory<ToggleNewsLikeUsecase>(
    () => ToggleNewsLikeUsecase(sl<NewsRepository>()),
  );

  // Comment use cases for news feature
  sl.registerFactory<GetNewsCommentsUsecase>(
    () => GetNewsCommentsUsecase(sl(instanceName: 'newsCommentRepository')),
    instanceName: 'getNewsCommentsUsecase',
  );
  sl.registerFactory<AddCommentUsecase>(
    () => AddNewsCommentUsecase(sl(instanceName: 'newsCommentRepository')),
    instanceName: 'addNewsCommentUsecase',
  );
  sl.registerFactory<DeleteCommentUsecase>(
    () => DeleteNewsCommentUsecase(sl(instanceName: 'newsCommentRepository')),
    instanceName: 'deleteNewsCommentUsecase',
  );
  sl.registerFactory<ToggleNewsCommentLikeUsecase>(
    () => ToggleNewsCommentLikeUsecase(sl()),
  );
}

void _initializeResellDependencies() {
  // Data sources
  sl.registerLazySingleton<ResellRemoteDataSource>(
    () => ResellRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<ResellRepository>(() => ResellRepositoryImpl(sl()));

  // Use cases
  sl.registerFactory<GetResellItemsUsecase>(() => GetResellItemsUsecase(sl()));
  sl.registerFactory<GetResellDetailUsecase>(
    () => GetResellDetailUsecase(sl()),
  );
  sl.registerFactory<BookResellItemUsecase>(() => BookResellItemUsecase(sl()));
  sl.registerFactory<ConfirmResellBookingUsecase>(
    () => ConfirmResellBookingUsecase(sl()),
  );
  sl.registerFactory<GetResellEquipmentTypesUsecase>(
    () => GetResellEquipmentTypesUsecase(sl()),
  );

  // BLoCs
  sl.registerFactory<ResellItemsBloc>(() => ResellItemsBloc(sl()));
  sl.registerFactory<ResellDetailBloc>(() => ResellDetailBloc(sl(), sl()));
  sl.registerFactory<ResellBookingBloc>(() => ResellBookingBloc(sl()));
}

void _initializeApplicationDependencies() {
  // Data sources
  sl.registerLazySingleton<ApplicationRemoteDataSource>(
    () => ApplicationRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<ApplicationRepository>(
    () => ApplicationRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerFactory<GetApplicationsUsecase>(
    () => GetApplicationsUsecase(sl()),
  );
  sl.registerFactory<GetApplicationDetailUsecase>(
    () => GetApplicationDetailUsecase(sl()),
  );
  sl.registerFactory<CreateApplicationUsecase>(
    () => CreateApplicationUsecase(sl()),
  );
  sl.registerFactory<CancelApplicationUsecase>(
    () => CancelApplicationUsecase(sl()),
  );
  sl.registerFactory<CheckCancelStatusUsecase>(
    () => CheckCancelStatusUsecase(sl()),
  );
  sl.registerFactory<CheckApplicationStatusUsecase>(
    () => CheckApplicationStatusUsecase(sl()),
  );
}
