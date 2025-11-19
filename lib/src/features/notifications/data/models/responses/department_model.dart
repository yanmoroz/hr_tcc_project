import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';

part 'department_model.freezed.dart';
part 'department_model.g.dart';

@freezed
abstract class DepartmentModel with _$DepartmentModel {
  const factory DepartmentModel({
    required int id,
    required String title,
    required bool isArchive,
  }) = _DepartmentModel;

  factory DepartmentModel.fromJson(Map<String, dynamic> json) =>
      _$DepartmentModelFromJson(json);
}

extension DepartmentModelX on DepartmentModel {
  Department toDomain() =>
      Department(id: id, title: title, isArchive: isArchive);
}
