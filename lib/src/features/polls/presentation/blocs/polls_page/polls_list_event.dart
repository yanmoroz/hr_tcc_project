import 'package:freezed_annotation/freezed_annotation.dart';

part 'polls_list_event.freezed.dart';

@freezed
abstract class PollsListEvent with _$PollsListEvent {
  const factory PollsListEvent.loadPolls({int? status}) = LoadPolls;
  const factory PollsListEvent.refreshPolls({int? status}) = RefreshPolls;
}
