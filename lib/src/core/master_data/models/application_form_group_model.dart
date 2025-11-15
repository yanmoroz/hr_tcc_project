import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/application_form_group.dart';

part 'application_form_group_model.freezed.dart';
part 'application_form_group_model.g.dart';

@freezed
abstract class ApplicationFormGroupModel with _$ApplicationFormGroupModel {
  const factory ApplicationFormGroupModel({
    required String id,
    required int code,
    required String name,
  }) = _ApplicationFormGroupModel;

  factory ApplicationFormGroupModel.fromJson(Map<String, dynamic> json) =>
      _$ApplicationFormGroupModelFromJson(json);
}

extension ApplicationFormGroupModelX on ApplicationFormGroupModel {
  ApplicationFormGroup toDomain() {
    return ApplicationFormGroup(id: id, code: code, name: name);
  }
}
