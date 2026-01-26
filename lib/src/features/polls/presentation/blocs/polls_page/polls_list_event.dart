import 'package:freezed_annotation/freezed_annotation.dart';

part 'polls_list_event.freezed.dart';

@freezed
abstract class PollsListEvent with _$PollsListEvent {
  const factory PollsListEvent.loadPolls() = LoadPolls;
  const factory PollsListEvent.loadMore() = LoadMore;
  const factory PollsListEvent.refreshPolls() = RefreshPolls;
  const factory PollsListEvent.filterByStatus(int? status) = FilterByStatus;
}
