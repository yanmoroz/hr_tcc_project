import 'package:freezed_annotation/freezed_annotation.dart';

part 'referral_program_vacation.freezed.dart';

@freezed
abstract class ReferralProgramVacation with _$ReferralProgramVacation {
  const factory ReferralProgramVacation({
    required int code,
    required String name,
    required bool active,
  }) = _ReferralProgramVacation;
}
