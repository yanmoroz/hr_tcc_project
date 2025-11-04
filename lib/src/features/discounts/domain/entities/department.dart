import 'package:freezed_annotation/freezed_annotation.dart';

part 'department.freezed.dart';

@freezed
abstract class Department with _$Department {
  const factory Department({required int id, required String title, bool? archive}) = _Department;
}
