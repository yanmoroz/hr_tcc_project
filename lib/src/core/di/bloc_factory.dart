import '../../features/applications/presentation/blocs/application_creation_page/application_creation_bloc.dart';
import '../../features/applications/presentation/blocs/application_detail_page/application_detail_bloc.dart';
import '../../features/applications/presentation/blocs/application_form_page/application_form_bloc.dart';
import '../../features/applications/presentation/blocs/applications_list_page/applications_list_bloc.dart';
import '../../features/comments/domain/domain.dart';
import '../../features/comments/presentation/blocs/comments_page/comments_bloc.dart';
import '../../features/polls/presentation/blocs/poll_page/poll_detail_bloc.dart';
import '../../features/polls/presentation/blocs/polls_page/polls_list_bloc.dart';
import '../../features/notifications/presentation/blocs/notification_detail_page/notification_detail_bloc.dart';
import '../../features/notifications/presentation/blocs/notifications_page/notifications_list_bloc.dart';
import '../../features/discounts/presentation/blocs/discount_categories_page/discount_categories_bloc.dart';
import '../../features/discounts/presentation/blocs/discounts_page/discounts_list_bloc.dart';
import '../../features/discounts/presentation/blocs/discount_page/discount_detail_bloc.dart';
import '../../features/news/presentation/blocs/news_page/news_list_bloc.dart';
import '../../features/news/presentation/blocs/news_detail_page/news_detail_bloc.dart';
import '../../features/users/presentation/blocs/address_book_page/address_book_bloc.dart';
import '../../features/users/presentation/blocs/user_profile_header/user_profile_header_bloc.dart';
import 'service_locator.dart';

/// Factory for creating BLoC instances.
class BlocFactory {
  /// Creates a [PollsListBloc] instance.
  static PollsListBloc createPollsListBloc() {
    return PollsListBloc(getPollsUsecase: sl(), downloadFileUsecase: sl());
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

  /// Creates a [NotificationsListBloc] instance.
  static NotificationsListBloc createNotificationsListBloc() {
    return NotificationsListBloc(
      getNotificationsUsecase: sl(),
      markNotificationAsReadUsecase: sl(),
      markAllNotificationsAsReadUsecase: sl(),
      getUnreadNotificationsCountUsecase: sl(),
    );
  }

  /// Creates a [NotificationDetailBloc] instance.
  static NotificationDetailBloc createNotificationDetailBloc() {
    return NotificationDetailBloc(
      getNotificationsUsecase: sl(),
      markNotificationAsReadUsecase: sl(),
    );
  }

  /// Creates a [DiscountCategoriesBloc] instance.
  static DiscountCategoriesBloc createDiscountCategoriesBloc() {
    return DiscountCategoriesBloc(
      getKpDiscountCategoriesUsecase: sl(),
      getKpDiscountSourcesUsecase: sl(),
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

  /// Creates a [NewsListBloc] instance.
  static NewsListBloc createNewsListBloc() {
    return NewsListBloc(getNewsListUsecase: sl(), downloadFileUsecase: sl());
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

  /// Creates an [AddressBookBloc] instance.
  static AddressBookBloc createAddressBookBloc() {
    return AddressBookBloc(getAddressBookUsecase: sl());
  }

  /// Creates a [UserProfileHeaderBloc] instance.
  static UserProfileHeaderBloc createUserProfileHeaderBloc() {
    return UserProfileHeaderBloc(getCurrentUserInfoUsecase: sl());
  }

  /// Creates an [ApplicationsListBloc] instance.
  static ApplicationsListBloc createApplicationsListBloc() {
    return ApplicationsListBloc(getApplicationsUsecase: sl());
  }

  /// Creates an [ApplicationCreationBloc] instance.
  static ApplicationCreationBloc createApplicationCreationBloc() {
    return ApplicationCreationBloc(dictionariesRepository: sl());
  }

  /// Creates an [ApplicationFormBloc] instance.
  static ApplicationFormBloc createApplicationFormBloc() {
    return ApplicationFormBloc(
      createApplicationUsecase: sl(),
      getKpAbsenceCategoriesUsecase: sl(),
    );
  }

  /// Creates an [ApplicationDetailBloc] instance.
  static ApplicationDetailBloc createApplicationDetailBloc() {
    return ApplicationDetailBloc(
      getApplicationDetailUsecase: sl(),
      cancelApplicationUsecase: sl(),
    );
  }
}
