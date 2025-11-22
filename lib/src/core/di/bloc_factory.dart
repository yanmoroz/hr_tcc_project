import '../../features/applications/applications.dart';
import '../../features/comments/comments.dart';
import '../../features/discounts/discounts.dart';
import '../../features/news/news.dart';
import '../../features/notifications/notifications.dart';
import '../../features/polls/polls.dart';
import '../../features/resell/resell.dart';
import '../../features/users/users.dart';
import 'service_locator.dart';

/// Factory for creating BLoC instances.
class BlocFactory {
  /// Creates an [AddressBookBloc] instance.
  static AddressBookBloc createAddressBookBloc() {
    return AddressBookBloc(getAddressBookUsecase: sl());
  }

  /// Creates an [ApplicationCreationBloc] instance.
  static ApplicationCreationBloc createApplicationCreationBloc() {
    return ApplicationCreationBloc(dictionariesRepository: sl());
  }

  /// Creates an [ApplicationDetailBloc] instance.
  static ApplicationDetailBloc createApplicationDetailBloc() {
    return ApplicationDetailBloc(
      getApplicationDetailUsecase: sl(),
      cancelApplicationUsecase: sl(),
    );
  }

  /// Creates an [ApplicationFormBloc] instance.
  static ApplicationFormBloc createApplicationFormBloc() {
    return ApplicationFormBloc(
      createApplicationUsecase: sl(),
      getKpAbsenceCategoriesUsecase: sl(),
    );
  }

  /// Creates an [ApplicationsListBloc] instance.
  static ApplicationsListBloc createApplicationsListBloc() {
    return ApplicationsListBloc(getApplicationsUsecase: sl());
  }

  /// Creates a [CommentsBloc] instance for the given [entityId] and [entityType].
  static CommentsBloc createCommentsBloc({
    required int entityId,
    required CommentableEntityType entityType,
  }) {
    return CommentsBloc(
      entityId: entityId,
      entityType: entityType,
      getCommentsUsecase: sl(),
      addCommentUsecase: sl(),
      deleteCommentUsecase: sl(),
      toggleCommentLikeUsecase: sl(),
    );
  }

  /// Creates a [CurrentUserBloc] instance.
  static CurrentUserBloc createCurrentUserBloc() {
    return CurrentUserBloc(getCurrentUserInfoUsecase: sl());
  }

  /// Creates a [DiscountCategoriesBloc] instance.
  static DiscountCategoriesBloc createDiscountCategoriesBloc() {
    return DiscountCategoriesBloc(
      getKpDiscountCategoriesUsecase: sl(),
      getKpDiscountSourcesUsecase: sl(),
    );
  }

  /// Creates a [DiscountDetailBloc] instance with the given [discountId].
  static DiscountDetailBloc createDiscountDetailBloc(int discountId) {
    return DiscountDetailBloc(
      discountId: discountId,
      getDiscountDetailUsecase: sl(),
      getDiscountStatsUsecase: sl(),
      toggleDiscountLikeUsecase: sl(),
      downloadFileUsecase: sl(),
    );
  }

  /// Creates a [DiscountsListBloc] instance.
  static DiscountsListBloc createDiscountsListBloc() {
    return DiscountsListBloc(
      getDiscountsUsecase: sl(),
      downloadFileUsecase: sl(),
      toggleDiscountLikeUsecase: sl(),
    );
  }

  /// Creates a [NewsDetailBloc] instance with the given [newsId].
  static NewsDetailBloc createNewsDetailBloc(int newsId) {
    return NewsDetailBloc(
      newsId: newsId,
      getNewsDetailUsecase: sl(),
      getNewsStatsUsecase: sl(),
      toggleNewsLikeUsecase: sl(),
      downloadFileUsecase: sl(),
    );
  }

  /// Creates a [NewsListBloc] instance.
  static NewsListBloc createNewsListBloc() {
    return NewsListBloc(getNewsListUsecase: sl(), downloadFileUsecase: sl());
  }

  /// Creates a [NotificationDetailBloc] instance.
  static NotificationDetailBloc createNotificationDetailBloc() {
    return NotificationDetailBloc(
      getNotificationsUsecase: sl(),
      markNotificationAsReadUsecase: sl(),
    );
  }

  /// Creates a [NotificationsListBloc] instance.
  static NotificationsListBloc createNotificationsListBloc() {
    return NotificationsListBloc(
      getNotificationsUsecase: sl(),
      markNotificationAsReadUsecase: sl(),
      markAllNotificationsAsReadUsecase: sl(),
      getUnreadNotificationsCountUsecase: sl(),
    );
  }

  /// Creates a [PollDetailBloc] instance with the given [pollId].
  static PollDetailBloc createPollDetailBloc(int pollId) {
    return PollDetailBloc(
      pollId: pollId,
      getPollDetailUsecase: sl(),
      submitPollAnswersUsecase: sl(),
      getStaffUsecase: sl(),
      uploadFileUsecase: sl(),
    );
  }

  /// Creates a [PollsListBloc] instance.
  static PollsListBloc createPollsListBloc() {
    return PollsListBloc(getPollsUsecase: sl(), downloadFileUsecase: sl());
  }

  /// Creates a [ResellBookingBloc] instance.
  static ResellBookingBloc createResellBookingBloc() {
    return ResellBookingBloc(sl());
  }

  /// Creates a [ResellDetailBloc] instance with the given [itemId].
  static ResellDetailBloc createResellDetailBloc() {
    return ResellDetailBloc(sl(), sl());
  }

  /// Creates a [ResellItemsBloc] instance.
  static ResellItemsBloc createResellItemsBloc() {
    return ResellItemsBloc(sl());
  }
}
