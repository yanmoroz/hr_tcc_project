import 'package:freezed_annotation/freezed_annotation.dart';

import 'department.dart';

part 'employee.freezed.dart';

@freezed
abstract class Employee with _$Employee {
  const factory Employee({
    required int id,
    required String firstName,
    String? lastName,
    String? middleName,
    String? position,
    Department? department,
    String? organisation,
    required bool isArchive,
    required int vacationDaysLeft,
    required bool isVaccinated,
    String? status,
    required String photo,
    required String title,
  }) = _Employee;
}
