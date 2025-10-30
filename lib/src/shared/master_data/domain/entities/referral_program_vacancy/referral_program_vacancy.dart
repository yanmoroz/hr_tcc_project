import 'package:freezed_annotation/freezed_annotation.dart';

import 'bonus.dart';
import 'field_activity.dart';

part 'referral_program_vacancy.freezed.dart';

@freezed
abstract class ReferralProgramVacancy with _$ReferralProgramVacancy {
  const factory ReferralProgramVacancy({
    required String id,
    required Bonus bonus,
    required String name,
    required String linkHH,
    required bool active,
    required String subdivision,
    required List<FieldActivity> fieldActivity,
  }) = _ReferralProgramVacancy;
}
