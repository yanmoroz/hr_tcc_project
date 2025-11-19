import 'package:freezed_annotation/freezed_annotation.dart';

part 'candidate_info_model.freezed.dart';
part 'candidate_info_model.g.dart';

/// Candidate information for referral program
@freezed
abstract class CandidateInfoModel with _$CandidateInfoModel {
  const factory CandidateInfoModel({
    required String lastName,
    required String firstName,
    String? middleName,
  }) = _CandidateInfoModel;

  factory CandidateInfoModel.fromJson(Map<String, dynamic> json) =>
      _$CandidateInfoModelFromJson(json);
}
