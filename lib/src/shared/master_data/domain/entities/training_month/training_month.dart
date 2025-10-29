import 'package:freezed_annotation/freezed_annotation.dart';

part 'training_month.freezed.dart';

@freezed
abstract class TrainingMonth with _$TrainingMonth {
  const factory TrainingMonth({
    required String id,
    required String code,
    required String name,
  }) = _TrainingMonth;
}
