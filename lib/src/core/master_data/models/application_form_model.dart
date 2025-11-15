import 'package:freezed_annotation/freezed_annotation.dart';

import '../../entities/application_form.dart';

part 'application_form_model.freezed.dart';
part 'application_form_model.g.dart';

@freezed
abstract class ApplicationFormModel with _$ApplicationFormModel {
  const factory ApplicationFormModel({
    required String id,
    required String idGroup,
    required String code,
    String? codeSystem,
    String? system,
    required String name,
    required bool archive,
  }) = _ApplicationFormModel;

  factory ApplicationFormModel.fromJson(Map<String, dynamic> json) =>
      _$ApplicationFormModelFromJson(json);
}

extension ApplicationFormModelX on ApplicationFormModel {
  ApplicationForm toDomain() {
    return ApplicationForm(
      id: id,
      idGroup: idGroup,
      code: code,
      codeSystem: codeSystem,
      system: system,
      name: name,
      archive: archive,
    );
  }
}
