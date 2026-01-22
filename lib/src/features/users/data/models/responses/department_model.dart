import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';

part 'department_model.freezed.dart';
part 'department_model.g.dart';

@freezed
abstract class DepartmentModel with _$DepartmentModel {
  const factory DepartmentModel({
    String? id,
    String? code,
    String? name,
    bool? archive,
  }) = _DepartmentModel;

  factory DepartmentModel.fromJson(Map<String, dynamic> json) =>
      _$DepartmentModelFromJson(json);
}

extension DepartmentModelX on DepartmentModel {
  Department toDomain() =>
      Department(id: id, code: code, name: name, archive: archive);
}
