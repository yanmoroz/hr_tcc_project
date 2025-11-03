import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';

part 'training_form_model.freezed.dart';
part 'training_form_model.g.dart';

@freezed
abstract class TrainingFormModel with _$TrainingFormModel {
  const factory TrainingFormModel({required String id, required String code, required String name}) =
      _TrainingFormModel;

  factory TrainingFormModel.fromJson(Map<String, dynamic> json) => _$TrainingFormModelFromJson(json);
}

extension TrainingFormModelX on TrainingFormModel {
  TrainingForm toDomain() {
    return TrainingForm(id: id, code: code, name: name);
  }
}
