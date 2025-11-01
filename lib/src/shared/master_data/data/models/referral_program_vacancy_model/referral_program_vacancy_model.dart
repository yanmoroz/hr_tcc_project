import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/entities.dart';
import 'bonus_info_model.dart';
import 'field_activity_model.dart';

part 'referral_program_vacancy_model.freezed.dart';
part 'referral_program_vacancy_model.g.dart';

@freezed
abstract class ReferralProgramVacancyModel with _$ReferralProgramVacancyModel {
  const factory ReferralProgramVacancyModel({
    required String id,
    @JsonKey(name: 'bonus') BonusInfoModel? bonusInfo,
    required String name,
    String? linkHH,
    required bool active,
    String? subdivision,
    List<FieldActivityModel>? fieldActivity,
  }) = _ReferralProgramVacancyModel;

  factory ReferralProgramVacancyModel.fromJson(Map<String, dynamic> json) =>
      _$ReferralProgramVacancyModelFromJson(json);
}

extension ReferralProgramVacancyModelX on ReferralProgramVacancyModel {
  ReferralProgramVacancy toDomain() => ReferralProgramVacancy(
    id: id,
    bonusInfo: bonusInfo?.toDomain(),
    name: name,
    linkHH: linkHH,
    active: active,
    subdivision: subdivision,
    fieldActivity: fieldActivity?.map((e) => e.toDomain()).toList(),
  );
}
