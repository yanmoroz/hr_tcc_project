import 'package:freezed_annotation/freezed_annotation.dart';

part 'absence_category.freezed.dart';

@freezed
abstract class AbsenceCategory with _$AbsenceCategory {
  const factory AbsenceCategory({required int id, required String name}) = _AbsenceCategory;
}
