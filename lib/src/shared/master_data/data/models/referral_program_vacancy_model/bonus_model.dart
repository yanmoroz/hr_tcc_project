import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/entities.dart';

part 'bonus_model.freezed.dart';
part 'bonus_model.g.dart';

@freezed
abstract class BonusModel with _$BonusModel {
  const factory BonusModel({required int cents, required String currency}) = _BonusModel;

  factory BonusModel.fromJson(Map<String, dynamic> json) => _$BonusModelFromJson(json);
}

extension BonusModelX on BonusModel {
  Bonus toDomain() => Bonus(cents: cents, currency: currency);
}
