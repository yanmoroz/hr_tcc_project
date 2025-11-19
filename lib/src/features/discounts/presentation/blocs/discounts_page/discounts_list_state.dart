import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';

part 'discounts_list_state.freezed.dart';

@freezed
class DiscountsListState with _$DiscountsListState {
  const factory DiscountsListState.initial() = DiscountsListInitial;
  const factory DiscountsListState.loading() = DiscountsListLoading;
  const factory DiscountsListState.loaded({
    required List<Discount> discounts,
    required int currentPage,
    required bool hasMorePages,
    required bool isLoadingMore,
    @Default({}) Map<int, Uint8List> coverImages,
    int? category,
    int? source,
    String? categoryName,
  }) = DiscountsListLoaded;
  const factory DiscountsListState.error(String message) = DiscountsListError;
}
