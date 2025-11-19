import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/value_objects/application_status.dart';

part 'create_application_result_model.freezed.dart';
part 'create_application_result_model.g.dart';

@freezed
abstract class CreateApplicationResultModel
    with _$CreateApplicationResultModel {
  const CreateApplicationResultModel._();

  const factory CreateApplicationResultModel({
    required String status,
    String? instance,
    String? id,
    String? idApplication,
  }) = _CreateApplicationResultModel;

  factory CreateApplicationResultModel.fromJson(Map<String, dynamic> json) =>
      _$CreateApplicationResultModelFromJson(json);

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
