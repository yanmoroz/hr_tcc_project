import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/value_objects/status_group_type.dart';

part 'applications_list_event.freezed.dart';

@freezed
class ApplicationsListEvent with _$ApplicationsListEvent {
  const factory ApplicationsListEvent.changeSearchQuery(String? query) =
      ChangeSearchQuery;

  const factory ApplicationsListEvent.changeStatusFilter(
    StatusGroupType? statusGroup,
  ) = ChangeStatusFilter;

  const factory ApplicationsListEvent.loadApplications() = LoadApplications;

  const factory ApplicationsListEvent.loadMoreApplications() =
      LoadMoreApplications;

  const factory ApplicationsListEvent.refreshApplications() =
      RefreshApplications;
}
