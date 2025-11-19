import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_application_request_model.freezed.dart';
part 'check_application_request_model.g.dart';

@freezed
abstract class CheckApplicationRequestModel
    with _$CheckApplicationRequestModel {
  const factory CheckApplicationRequestModel({
    required String applicationFormCode,
    required String instance,
  }) = _CheckApplicationRequestModel;

  factory CheckApplicationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CheckApplicationRequestModelFromJson(json);

  Map<String, dynamic> toJson() => {
    'applicationFormCode': applicationFormCode,
    'instance': instance,
  };
}
