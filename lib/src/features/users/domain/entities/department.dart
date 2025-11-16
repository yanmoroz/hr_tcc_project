import 'package:freezed_annotation/freezed_annotation.dart';

part 'department.freezed.dart';

@freezed
abstract class Department with _$Department {
  const factory Department({
    String? id,
    String? code,
    String? name,
    bool? archive,
  }) = _Department;
}
