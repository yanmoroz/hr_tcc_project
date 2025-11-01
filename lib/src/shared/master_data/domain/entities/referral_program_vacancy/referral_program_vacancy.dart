import 'package:freezed_annotation/freezed_annotation.dart';

import 'bonus_info.dart';
import 'field_activity.dart';

part 'referral_program_vacancy.freezed.dart';

@freezed
abstract class ReferralProgramVacancy with _$ReferralProgramVacancy {
  const factory ReferralProgramVacancy({
    required String id,
    BonusInfo? bonusInfo,
    required String name,
    String? linkHH,
    required bool active,
    String? subdivision,
    List<FieldActivity>? fieldActivity,
  }) = _ReferralProgramVacancy;
}
