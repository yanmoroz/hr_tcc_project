import 'package:freezed_annotation/freezed_annotation.dart';

part 'discount_detail_event.freezed.dart';

@freezed
class DiscountDetailEvent with _$DiscountDetailEvent {
  const factory DiscountDetailEvent.loadDetail() = LoadDetail;
  const factory DiscountDetailEvent.toggleLike() = ToggleLike;
  const factory DiscountDetailEvent.refresh() = RefreshDetail;
}
