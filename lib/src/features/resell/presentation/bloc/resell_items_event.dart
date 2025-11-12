import 'package:freezed_annotation/freezed_annotation.dart';

part 'resell_items_event.freezed.dart';

@freezed
class ResellItemsEvent with _$ResellItemsEvent {
  const factory ResellItemsEvent.loadResellItems() = LoadResellItems;
  const factory ResellItemsEvent.loadMore() = LoadMore;
  const factory ResellItemsEvent.refreshItems() = RefreshItems;
  const factory ResellItemsEvent.filterByStatus(int status) = FilterByStatus;
}
