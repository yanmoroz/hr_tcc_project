import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/domain.dart';

part 'referral_program_candidate_model.freezed.dart';
part 'referral_program_candidate_model.g.dart';

@freezed
abstract class ReferralProgramCandidateModel with _$ReferralProgramCandidateModel {
  const factory ReferralProgramCandidateModel({required String id, required String name}) =
      _ReferralProgramCandidateModel;

  factory ReferralProgramCandidateModel.fromJson(Map<String, dynamic> json) =>
      _$ReferralProgramCandidateModelFromJson(json);
}

extension ReferralProgramCandidateModelX on ReferralProgramCandidateModel {
  ReferralProgramCandidate toDomain() {
    return ReferralProgramCandidate(id: id, name: name);
  }
}
