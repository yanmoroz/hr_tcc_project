import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../domain/domain.dart';

part 'resell_items_state.freezed.dart';

@freezed
sealed class ResellItemsState with _$ResellItemsState {
  const factory ResellItemsState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default([]) List<ResellItem> items,
    @Default(0) int currentPage,
    @Default(true) bool hasMorePages,
    @Default(false) bool isLoadingMore,
    @Default(0) int currentStatus,
    String? errorMessage,
  }) = _ResellItemsState;
}
