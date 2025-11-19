import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/value_objects/application_status.dart';
import '../../../../../core/dictionaries/data/models/models.dart';

part 'cancel_application_result_model.freezed.dart';
part 'cancel_application_result_model.g.dart';

@freezed
abstract class CancelApplicationResultModel
    with _$CancelApplicationResultModel {
  const CancelApplicationResultModel._();

  const factory CancelApplicationResultModel({
    required String status,
    required String id,
    @JsonKey(name: 'systemStatus') required SystemStatusModel systemStatusModel,
  }) = _CancelApplicationResultModel;

  factory CancelApplicationResultModel.fromJson(Map<String, dynamic> json) =>
      _$CancelApplicationResultModelFromJson(json);

  ApplicationStatus get parsedStatus => _parseApplicationStatus(status);

  ApplicationStatus _parseApplicationStatus(String status) {
    switch (status.toLowerCase()) {
      case 'ok':
        return ApplicationStatus.ok;
      case 'processing':
        return ApplicationStatus.processing;
      default:
        return ApplicationStatus.processing;
    }
  }
}
