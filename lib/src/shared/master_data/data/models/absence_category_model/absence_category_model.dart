import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/entities.dart';

part 'absence_category_model.freezed.dart';
part 'absence_category_model.g.dart';

@freezed
abstract class AbsenceCategoryModel with _$AbsenceCategoryModel {
  const factory AbsenceCategoryModel({required int id, required String name}) = _AbsenceCategoryModel;

  factory AbsenceCategoryModel.fromJson(Map<String, dynamic> json) => _$AbsenceCategoryModelFromJson(json);
}

extension AbsenceCategoryModelX on AbsenceCategoryModel {
  AbsenceCategory toDomain() {
    return AbsenceCategory(id: id, name: name);
  }
}
