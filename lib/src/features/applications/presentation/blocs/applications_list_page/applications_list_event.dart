import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/value_objects/status_group_type.dart';

part 'applications_list_event.freezed.dart';

@freezed
class ApplicationsListEvent with _$ApplicationsListEvent {
  /// Initial load of applications
  const factory ApplicationsListEvent.loadApplications() = LoadApplications;

  /// Pull-to-refresh (uses current filters from state)
  const factory ApplicationsListEvent.refreshApplications() =
      RefreshApplications;

  /// Load next page (pagination)
  const factory ApplicationsListEvent.loadMoreApplications() =
      LoadMoreApplications;

  /// Change status filter tab
  const factory ApplicationsListEvent.changeStatusFilter(
    StatusGroupType? statusGroup,
  ) = ChangeStatusFilter;

  /// Change search query
  const factory ApplicationsListEvent.changeSearchQuery(String? query) =
      ChangeSearchQuery;
}
