import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';

part 'resell_items_state.freezed.dart';

@freezed
class ResellItemsState with _$ResellItemsState {
  const factory ResellItemsState.initial() = ResellItemsInitial;
  const factory ResellItemsState.loading() = ResellItemsLoading;
  const factory ResellItemsState.loaded({
    required List<ResellItem> items,
    required int currentPage,
    required bool hasMorePages,
    required bool isLoadingMore,
    required int currentStatus,
  }) = ResellItemsLoaded;
  const factory ResellItemsState.error(String message) = ResellItemsError;
}
