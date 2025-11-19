import 'package:freezed_annotation/freezed_annotation.dart';

part 'department.freezed.dart';

@freezed
abstract class Department with _$Department {
  const factory Department({
    required int id,
    required String title,
    required bool isArchive,
  }) = _Department;
}
