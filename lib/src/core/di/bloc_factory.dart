import '../../features/polls/presentation/bloc/poll_page/poll_detail_bloc.dart';
import '../../features/polls/presentation/bloc/polls_page/polls_list_bloc.dart';
import '../../features/notifications/presentation/bloc/notifications_page/notifications_list_bloc.dart';
import 'service_locator.dart';

/// Factory for creating BLoC instances.
class BlocFactory {
  /// Creates a [PollsListBloc] instance.
  static PollsListBloc createPollsListBloc() {
    return PollsListBloc(getPollsUsecase: sl());
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
}
