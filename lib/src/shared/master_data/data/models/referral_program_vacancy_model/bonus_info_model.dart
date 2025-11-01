import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/entities.dart';

part 'bonus_info_model.freezed.dart';
part 'bonus_info_model.g.dart';

@freezed
abstract class BonusInfoModel with _$BonusInfoModel {
  const factory BonusInfoModel({required int cents, String? currency}) = _BonusInfoModel;

  factory BonusInfoModel.fromJson(Map<String, dynamic> json) => _$BonusInfoModelFromJson(json);
}

extension BonusInfoModelX on BonusInfoModel {
  BonusInfo toDomain() => BonusInfo(cents: cents, currency: currency);
}
