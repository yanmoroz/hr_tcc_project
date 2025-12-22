import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../domain/domain.dart';

part 'resell_items_state.freezed.dart';

@freezed
sealed class ResellItemsState with _$ResellItemsState {
  const factory ResellItemsState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default(LoadingStatus.initial) LoadingStatus filteringStatus,
    @Default([]) List<ResellItem> items,
    @Default(0) int currentPage,
    @Default(true) bool hasMorePages,
    @Default(false) bool isLoadingMore,
    @Default(1) int currentStatus,
    @Default(0) int totalOnSale,
    @Default(0) int totalReserved,
    String? search,
    String? errorMessage,
    String? bookingItemId,
    @Default(false) bool isBooking,
    @Default({}) Map<String, Uint8List> coverImages,
  }) = _ResellItemsState;
}
