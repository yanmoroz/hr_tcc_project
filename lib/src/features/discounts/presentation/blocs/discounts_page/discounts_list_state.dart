import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../domain/domain.dart';

part 'discounts_list_state.freezed.dart';

@freezed
sealed class DiscountsListState with _$DiscountsListState {
  const factory DiscountsListState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default([]) List<Discount> discounts,
    @Default(0) int currentPage,
    @Default(true) bool hasMorePages,
    @Default(false) bool isLoadingMore,
    @Default({}) Map<int, Uint8List> coverImages,
    int? category,
    int? source,
    String? categoryName,
    String? errorMessage,
  }) = _DiscountsListState;
}
