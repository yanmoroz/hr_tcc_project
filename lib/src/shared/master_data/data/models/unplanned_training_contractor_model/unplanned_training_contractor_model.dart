import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/entities.dart';

part 'unplanned_training_contractor_model.freezed.dart';
part 'unplanned_training_contractor_model.g.dart';

@freezed
abstract class UnplannedTrainingContractorModel
    with _$UnplannedTrainingContractorModel {
  const factory UnplannedTrainingContractorModel({
    required String id,
    required String name,
  }) = _UnplannedTrainingContractorModel;

  factory UnplannedTrainingContractorModel.fromJson(
    Map<String, dynamic> json,
  ) => _$UnplannedTrainingContractorModelFromJson(json);
}

extension UnplannedTrainingContractorModelX
    on UnplannedTrainingContractorModel {
  UnplannedTrainingContractor toDomain() {
    return UnplannedTrainingContractor(id: id, name: name);
  }
}
