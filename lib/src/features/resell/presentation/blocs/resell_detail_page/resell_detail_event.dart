import 'package:freezed_annotation/freezed_annotation.dart';

part 'resell_detail_event.freezed.dart';

@freezed
abstract class ResellDetailEvent with _$ResellDetailEvent {
  const factory ResellDetailEvent.loadResellDetail() = LoadResellDetail;
  const factory ResellDetailEvent.bookResellItem() = BookResellItem;
}
