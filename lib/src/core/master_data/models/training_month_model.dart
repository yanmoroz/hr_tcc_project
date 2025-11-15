import 'package:freezed_annotation/freezed_annotation.dart';

import '../../entities/training_month.dart';

part 'training_month_model.freezed.dart';
part 'training_month_model.g.dart';

@freezed
abstract class TrainingMonthModel with _$TrainingMonthModel {
  const factory TrainingMonthModel({
    required String id,
    required String code,
    required String name,
  }) = _TrainingMonthModel;

  factory TrainingMonthModel.fromJson(Map<String, dynamic> json) =>
      _$TrainingMonthModelFromJson(json);
}

extension TrainingMonthModelX on TrainingMonthModel {
  TrainingMonth toDomain() {
    return TrainingMonth(id: id, code: code, name: name);
  }
}
