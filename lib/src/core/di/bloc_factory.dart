import '../../features/polls/presentation/bloc/poll_page/poll_detail_bloc.dart';
import '../../features/polls/presentation/bloc/polls_page/polls_list_bloc.dart';
import '../../features/notifications/presentation/bloc/notifications_page/notifications_list_bloc.dart';
import '../../features/discounts/presentation/bloc/discount_categories_page/discount_categories_bloc.dart';
import '../../features/discounts/presentation/bloc/discounts_page/discounts_list_bloc.dart';
import '../../features/discounts/presentation/bloc/discount_page/discount_detail_bloc.dart';
import '../../features/news/presentation/bloc/news_page/news_list_bloc.dart';
import '../../features/news/presentation/bloc/news_detail_page/news_detail_bloc.dart';
import '../../shared/comments/presentation/bloc/comments_page/comments_bloc.dart';
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

  /// Creates a [CommentsBloc] instance for the given [entityId] and [feature].
  ///
  /// [feature] should be 'discount' or 'news' to resolve the correct use case instances.
  static CommentsBloc createCommentsBloc({
    required int entityId,
    required String feature,
  }) {
    // Capitalize first letter for instance name
    final capitalizedFeature = feature[0].toUpperCase() + feature.substring(1);

    return CommentsBloc(
      entityId: entityId,
      getCommentsUsecase: sl(
        instanceName: 'get${capitalizedFeature}CommentsUsecase',
      ),
      addCommentUsecase: sl(
        instanceName: 'add${capitalizedFeature}CommentUsecase',
      ),
      deleteCommentUsecase: sl(
        instanceName: 'delete${capitalizedFeature}CommentUsecase',
      ),
      toggleCommentLikeUsecase: sl(
        instanceName: 'toggle${capitalizedFeature}CommentLikeUsecase',
      ),
    );
  }
}
