import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/value_objects/status_group_type.dart';

part 'applications_list_event.freezed.dart';

@freezed
class ApplicationsListEvent with _$ApplicationsListEvent {
  const factory ApplicationsListEvent.loadApplications({
    StatusGroupType? statusGroup,
    String? search,
  }) = LoadApplications;

  const factory ApplicationsListEvent.refreshApplications({
    StatusGroupType? statusGroup,
    String? search,
  }) = RefreshApplications;

  const factory ApplicationsListEvent.loadMoreApplications() =
      LoadMoreApplications;

  const factory ApplicationsListEvent.changeStatusFilter(
    StatusGroupType? statusGroup,
  ) = ChangeStatusFilter;
}
