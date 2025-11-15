import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';

part 'field_activity_model.freezed.dart';
part 'field_activity_model.g.dart';

@freezed
abstract class FieldActivityModel with _$FieldActivityModel {
  const factory FieldActivityModel({required String code, required String name}) = _FieldActivityModel;

  factory FieldActivityModel.fromJson(Map<String, dynamic> json) => _$FieldActivityModelFromJson(json);
}

extension FieldActivityModelX on FieldActivityModel {
  FieldActivity toDomain() => FieldActivity(code: code, name: name);
}
