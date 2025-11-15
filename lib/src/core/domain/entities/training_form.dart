import 'package:freezed_annotation/freezed_annotation.dart';

part 'training_form.freezed.dart';

@freezed
abstract class TrainingForm with _$TrainingForm {
  const factory TrainingForm({
    required String id,
    required String code,
    required String name,
  }) = _TrainingForm;
}
