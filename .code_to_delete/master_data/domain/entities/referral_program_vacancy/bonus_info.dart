import 'package:freezed_annotation/freezed_annotation.dart';

part 'bonus_info.freezed.dart';

@freezed
abstract class BonusInfo with _$BonusInfo {
  const factory BonusInfo({required int cents, String? currency}) = _BonusInfo;
}
