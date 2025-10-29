import 'package:freezed_annotation/freezed_annotation.dart';

part 'unplanned_training_contractor.freezed.dart';

@freezed
abstract class UnplannedTrainingContractor with _$UnplannedTrainingContractor {
  const factory UnplannedTrainingContractor({
    required int code,
    required String name,
  }) = _UnplannedTrainingContractor;
}
