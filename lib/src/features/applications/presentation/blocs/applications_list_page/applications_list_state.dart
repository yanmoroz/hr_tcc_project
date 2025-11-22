import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../../../core/value_objects/status_group_type.dart';
import '../../../domain/domain.dart';

part 'applications_list_state.freezed.dart';

@freezed
sealed class ApplicationsListState with _$ApplicationsListState {
  const factory ApplicationsListState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default([]) List<ApplicationInfo> applications,
    @Default([]) List<ApplicationStatistics> statistics,
    @Default(0) int currentPage,
    @Default(true) bool hasMorePages,
    @Default(false) bool isLoadingMore,
    StatusGroupType? statusGroup,
    String? search,
    String? errorMessage,
  }) = _ApplicationsListState;
}
