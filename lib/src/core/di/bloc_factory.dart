import '../../features/applications/applications.dart';
import '../../features/discounts/discounts.dart';
import '../../features/g2g/comments/comments.dart';
import '../../features/g2g/notifications/notifications.dart';
import '../../features/g2g/users/users.dart';
import '../../features/news/news.dart';
import '../../features/polls/polls.dart';
import '../../features/resell/resell.dart';
import '../../shared/files/domain/domain.dart';
import '../blocs/current_user/bloc.dart';
import '../cache/image_cache_service.dart';
import '../entities/application_form.dart';
import 'service_locator.dart';

class BlocFactory {
  static AddressBookBloc createAddressBookBloc() {
    return AddressBookBloc(getAddressBookUsecase: sl());
  }

  static ApplicationCreationBloc createApplicationCreationBloc() {
    return ApplicationCreationBloc(dictionariesRepository: sl());
  }

  static ApplicationDetailBloc createApplicationDetailBloc(
    String applicationId,
  ) {
    return ApplicationDetailBloc(
      applicationId: applicationId,
      getApplicationDetailUsecase: sl(),
      cancelApplicationUsecase: sl(),
    );
  }

  static ApplicationFormBloc createApplicationFormBloc(
    ApplicationForm applicationForm,
  ) {
    return ApplicationFormBloc(
      applicationForm: applicationForm,
      createApplicationUsecase: sl(),
      getKpAbsenceCategoriesUsecase: sl(),
    );
  }

  static ApplicationsListBloc createApplicationsListBloc() {
    return ApplicationsListBloc(getApplicationsUsecase: sl());
  }

  static CommentsBloc createCommentsBloc({
    required int entityId,
    required CommentableEntityType entityType,
    required String entityName,
  }) {
    return CommentsBloc(
      entityId: entityId,
      entityType: entityType,
      entityName: entityName,
      getCommentsUsecase: sl(),
      addCommentUsecase: sl(),
      deleteCommentUsecase: sl(),
      toggleCommentLikeUsecase: sl(),
      uploadFileUsecase: sl<UploadFileUsecase>(),
      downloadFileUsecase: sl<DownloadFileUsecase>(),
    );
  }

  static CurrentUserBloc createCurrentUserBloc() {
    return CurrentUserBloc(getCurrentUserInfoUsecase: sl());
  }

  static DiscountCategoriesBloc createDiscountCategoriesBloc() {
    return DiscountCategoriesBloc(
      getKpDiscountCategoriesUsecase: sl(),
      getKpDiscountSourcesUsecase: sl(),
    );
  }

  static DiscountDetailBloc createDiscountDetailBloc(int discountId) {
    return DiscountDetailBloc(
      discountId: discountId,
      getDiscountDetailUsecase: sl(),
      getDiscountStatsUsecase: sl(),
      toggleDiscountLikeUsecase: sl(),
      downloadFileUsecase: sl(),
    );
  }

  static DiscountsListBloc createDiscountsListBloc() {
    return DiscountsListBloc(
      getDiscountsUsecase: sl(),
      downloadFileUsecase: sl(),
      toggleDiscountLikeUsecase: sl(),
    );
  }

  static MentionCubit createMentionCubit() {
    return MentionCubit(getUsersUsecase: sl());
  }

  static NewsDetailBloc createNewsDetailBloc(int newsId) {
    return NewsDetailBloc(
      newsId: newsId,
      getNewsDetailUsecase: sl(),
      getNewsStatsUsecase: sl(),
      toggleNewsLikeUsecase: sl(),
      downloadFileUsecase: sl(),
    );
  }

  static NewsListBloc createNewsListBloc() {
    return NewsListBloc(
      getNewsListUsecase: sl(),
      imageCacheService: sl<ImageCacheService>(),
    );
  }

  static NotificationDetailBloc createNotificationDetailBloc(
    int notificationId,
  ) {
    return NotificationDetailBloc(
      notificationId: notificationId,
      getNotificationUsecase: sl(),
      markNotificationAsReadUsecase: sl(),
    );
  }

  static NotificationsListBloc createNotificationsListBloc() {
    return NotificationsListBloc(
      getNotificationsUsecase: sl(),
      markAllNotificationsAsReadUsecase: sl(),
      watchNotificationsUseCase: sl(),
    );
  }

  static PollDetailBloc createPollDetailBloc(int pollId) {
    return PollDetailBloc(
      pollId: pollId,
      getPollDetailUsecase: sl(),
      submitPollAnswersUsecase: sl(),
      getStaffUsecase: sl(),
      uploadFileUsecase: sl(),
    );
  }

  static PollsListBloc createPollsListBloc() {
    return PollsListBloc(getPollsUsecase: sl(), downloadFileUsecase: sl());
  }

  static ResellBookingBloc createResellBookingBloc(String itemId) {
    return ResellBookingBloc(itemId, sl());
  }

  static ResellDetailBloc createResellDetailBloc(String itemId) {
    return ResellDetailBloc(
      itemId: itemId,
      getResellDetailUsecase: sl(),
      bookResellItemUsecase: sl(),
    );
  }

  static ResellItemsBloc createResellItemsBloc() {
    return ResellItemsBloc(sl(), sl(), sl<ImageCacheService>());
  }

  static UnreadNotificationsCubit getUnreadNotificationsCubit() {
    return sl<UnreadNotificationsCubit>();
  }
}
