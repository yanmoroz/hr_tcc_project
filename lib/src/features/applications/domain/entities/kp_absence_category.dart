import 'package:freezed_annotation/freezed_annotation.dart';

part 'kp_absence_category.freezed.dart';

@freezed
abstract class KpAbsenceCategory with _$KpAbsenceCategory {
  const factory KpAbsenceCategory({required int id, required String name}) =
      _KpAbsenceCategory;
}
