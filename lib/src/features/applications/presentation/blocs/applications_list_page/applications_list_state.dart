import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/value_objects/status_group_type.dart';
import '../../../domain/domain.dart';

part 'applications_list_state.freezed.dart';

@freezed
class ApplicationsListState with _$ApplicationsListState {
  const factory ApplicationsListState.initial() = ApplicationsListInitial;

  const factory ApplicationsListState.loading() = ApplicationsListLoading;

  const factory ApplicationsListState.loaded({
    required List<ApplicationInfo> applications,
    required List<ApplicationStatistics> statistics,
    required int currentPage,
    required bool hasMorePages,
    required bool isLoadingMore,
    StatusGroupType? statusGroup,
    String? search,
  }) = ApplicationsListLoaded;

  const factory ApplicationsListState.error(String message) =
      ApplicationsListError;
}
