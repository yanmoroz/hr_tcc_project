import 'package:freezed_annotation/freezed_annotation.dart';

part 'training_type.freezed.dart';

@freezed
abstract class TrainingType with _$TrainingType {
  const factory TrainingType({
    required String id,
    required String code,
    required String name,
  }) = _TrainingType;
}
