import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../features/applications/applications.dart';
import '../../features/auth/auth.dart';
import '../../features/discounts/discounts.dart';
import '../../features/g2g/comments/comments.dart';
import '../../features/g2g/notifications/notifications.dart';
import '../../features/g2g/users/users.dart';
import '../../features/news/news.dart';
import '../../features/polls/polls.dart';
import '../../features/resell/resell.dart';
import '../auth/auth_status_notifier.dart';
import '../auth/auth_token_provider.dart';
import '../cache/image_cache_service.dart';
import '../dadata/dadata.dart';
import '../dictionaries/dictionaries.dart';
import '../files/files.dart';
import '../network/api_client.dart';
import '../network/keycloak_api_client.dart';
import '../retry/retry_notifier.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  _initializeCoreDependencies();
  await _initializeAuthDependencies();
  _initializeFileDependencies();
  _initializeDaDataDependencies();
  _initializeMasterDataDependencies();
  _initializeCommentDependencies();
  _initializeNotificationDependencies();
  _initializePollDependencies();
  _initializeUserDependencies();
  _initializeDiscountDependencies();
  _initializeNewsDependencies();
  _initializeResellDependencies();
  _initializeApplicationDependencies();
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
  sl.registerFactory<GetKpAbsenceCategoriesUsecase>(
    () => GetKpAbsenceCategoriesUsecase(sl()),
  );
}

Future<void> _initializeAuthDependencies() async {
  // Secure storage
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // Auth Token Provider - use SecureAuthTokenProvider for production
  final secureAuthTokenProvider = SecureAuthTokenProvider(sl());
  await secureAuthTokenProvider.initialize();
  sl.registerLazySingleton<AuthTokenProvider>(() => secureAuthTokenProvider);

  // Auth Status Notifier (reactive auth status for GoRouter)
  final authStatusNotifier = AuthStatusNotifier(sl());
  await authStatusNotifier.checkInitialStatus();
  sl.registerLazySingleton<AuthStatusNotifier>(() => authStatusNotifier);

  // API Client (handles 401/403 by triggering logout via AuthStatusNotifier)
  sl.registerLazySingleton<ApiClient>(
    () => InsecureApiClient(sl<AuthTokenProvider>(), sl<AuthStatusNotifier>()),
  );

  // Keycloak API Client (lightweight client for OAuth2 token requests only)
  sl.registerLazySingleton<KeycloakApiClient>(() => KeycloakApiClient());

  // Data sources - inject Keycloak client
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), tokenProvider: sl()),
  );

  // Use cases
  sl.registerFactory(() => LoginUsecase(sl()));
  sl.registerFactory(() => LogoutUsecase(sl()));
  sl.registerFactory(() => RefreshTokenUsecase(sl()));
}

void _initializeCommentDependencies() {
  sl.registerLazySingleton<CommentRemoteDataSource>(
    () => CommentRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CommentRepository>(
    () => CommentRepositoryImpl(sl()),
  );
  sl.registerFactory<GetCommentsUsecase>(() => GetCommentsUsecase(sl()));
  sl.registerFactory<AddCommentUsecase>(() => AddCommentUsecase(sl()));
  sl.registerFactory<DeleteCommentUsecase>(() => DeleteCommentUsecase(sl()));
  sl.registerFactory<ToggleCommentLikeUsecase>(
    () => ToggleCommentLikeUsecase(sl()),
  );
}

void _initializeCoreDependencies() {
  sl.registerLazySingleton<LocalAuthTokenProvider>(
    () => LocalAuthTokenProvider(),
  );
  sl.registerLazySingleton<RetryNotifier>(() => RetryNotifier());
  // NOTE: ApiClient moved to _initializeAuthDependencies() - requires AuthStatusNotifier
}

void _initializeDaDataDependencies() {
  // Token provider
  sl.registerLazySingleton<DaDataTokenProvider>(
    () => LocalDaDataTokenProvider(),
  );

  // DaData client
  sl.registerLazySingleton<DaDataClient>(() => DaDataClient(sl()));

  // Data sources
  sl.registerLazySingleton<DaDataRemoteDataSource>(
    () => DaDataRemoteDataSourceImpl(sl()),
  );

  // Service
  sl.registerLazySingleton<DaDataService>(() => DaDataServiceImpl(sl()));
}

void _initializeDiscountDependencies() {
  // Data sources
  sl.registerLazySingleton<DiscountRemoteDataSource>(
    () => DiscountRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<DiscountRepository>(
    () => DiscountRepositoryImpl(sl()),
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
  sl.registerFactory<GetKpDiscountCategoriesUsecase>(
    () => GetKpDiscountCategoriesUsecase(sl()),
  );
  sl.registerFactory<GetKpDiscountSourcesUsecase>(
    () => GetKpDiscountSourcesUsecase(sl()),
  );
}

void _initializeFileDependencies() {
  // Data sources
  sl.registerLazySingleton<FileRemoteDataSource>(
    () => FileRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<FileLocalDataSource>(
    () => FileLocalDataSourceImpl(),
  );

  // Files service
  sl.registerLazySingleton<FilesService>(
    () =>
        FilesServiceImpl(sl<FileRemoteDataSource>(), sl<FileLocalDataSource>()),
  );

  // Image cache service
  sl.registerLazySingleton<ImageCacheService>(
    () => ImageCacheService(sl<FilesService>()),
  );
}

void _initializeMasterDataDependencies() {
  sl.registerLazySingleton<DictionariesCache>(() => DictionariesCache());
  sl.registerLazySingleton<DictionariesRemoteDataSource>(
    () => DictionariesRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<DictionariesRepository>(
    () => DictionariesRepositoryImpl(sl(), sl()),
  );
}

void _initializeNewsDependencies() {
  // Data sources
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<NewsRepository>(() => NewsRepositoryImpl(sl()));

  // Use cases
  sl.registerFactory<GetNewsListUsecase>(() => GetNewsListUsecase(sl()));
  sl.registerFactory<GetNewsDetailUsecase>(() => GetNewsDetailUsecase(sl()));
  sl.registerFactory<GetNewsStatsUsecase>(() => GetNewsStatsUsecase(sl()));
  sl.registerFactory<GetNewsGalleryUsecase>(() => GetNewsGalleryUsecase(sl()));
  sl.registerFactory<ToggleNewsLikeUsecase>(
    () => ToggleNewsLikeUsecase(sl<NewsRepository>()),
  );
}

void _initializeNotificationDependencies() {
  // Data sources
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<NotificationLocalDataSource>(
    () => NotificationLocalDataSourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(sl(), sl()),
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
  sl.registerFactory<GetNotificationUsecase>(
    () => GetNotificationUsecase(sl()),
  );
  sl.registerFactory<WatchNotificationsUseCase>(
    () => WatchNotificationsUseCase(sl()),
  );

  // Cubits
  sl.registerLazySingleton<UnreadNotificationsCubit>(
    () => UnreadNotificationsCubit(sl(), sl()),
  );
}

void _initializePollDependencies() {
  // Data sources
  sl.registerLazySingleton<PollRemoteDataSource>(
    () => PollRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<PollRepository>(() => PollRepositoryImpl(sl()));

  // Use cases
  sl.registerFactory<GetPollsUsecase>(() => GetPollsUsecase(sl()));
  sl.registerFactory<GetStaffUsecase>(() => GetStaffUsecase(sl()));
  sl.registerFactory<GetPollDetailUsecase>(() => GetPollDetailUsecase(sl()));
  sl.registerFactory<SubmitPollAnswersUsecase>(
    () => SubmitPollAnswersUsecase(sl()),
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
