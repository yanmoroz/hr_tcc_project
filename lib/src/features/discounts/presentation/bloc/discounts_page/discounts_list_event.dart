import 'package:freezed_annotation/freezed_annotation.dart';

part 'discounts_list_event.freezed.dart';

@freezed
class DiscountsListEvent with _$DiscountsListEvent {
  const factory DiscountsListEvent.loadDiscounts({
    int? category,
    int? source,
  }) = LoadDiscounts;

  const factory DiscountsListEvent.refreshDiscounts({
    int? category,
    int? source,
  }) = RefreshDiscounts;

  const factory DiscountsListEvent.loadMoreDiscounts() = LoadMoreDiscounts;
}
