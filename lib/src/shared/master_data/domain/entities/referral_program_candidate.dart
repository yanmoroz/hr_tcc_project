import 'package:freezed_annotation/freezed_annotation.dart';

part 'referral_program_candidate.freezed.dart';

@freezed
abstract class ReferralProgramCandidate with _$ReferralProgramCandidate {
  const factory ReferralProgramCandidate({required String id, required String name}) = _ReferralProgramCandidate;
}
