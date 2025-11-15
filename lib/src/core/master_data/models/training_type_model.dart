import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/training_type.dart';

part 'training_type_model.freezed.dart';
part 'training_type_model.g.dart';

@freezed
abstract class TrainingTypeModel with _$TrainingTypeModel {
  const factory TrainingTypeModel({
    required String id,
    required String code,
    required String name,
  }) = _TrainingTypeModel;

  factory TrainingTypeModel.fromJson(Map<String, dynamic> json) =>
      _$TrainingTypeModelFromJson(json);
}

extension TrainingTypeModelX on TrainingTypeModel {
  TrainingType toDomain() {
    return TrainingType(id: id, code: code, name: name);
  }
}
