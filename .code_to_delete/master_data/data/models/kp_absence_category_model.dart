import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/domain.dart';

part 'kp_absence_category_model.freezed.dart';
part 'kp_absence_category_model.g.dart';

@freezed
abstract class KpAbsenceCategoryModel with _$KpAbsenceCategoryModel {
  const factory KpAbsenceCategoryModel({required int id, required String name}) = _KpAbsenceCategoryModel;

  factory KpAbsenceCategoryModel.fromJson(Map<String, dynamic> json) => _$KpAbsenceCategoryModelFromJson(json);
}

extension KpAbsenceCategoryModelX on KpAbsenceCategoryModel {
  KpAbsenceCategory toDomain() {
    return KpAbsenceCategory(id: id, name: name);
  }
}
