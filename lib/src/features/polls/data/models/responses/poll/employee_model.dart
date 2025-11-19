import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/domain.dart';
import 'department_model.dart';

part 'employee_model.freezed.dart';
part 'employee_model.g.dart';

@freezed
abstract class EmployeeModel with _$EmployeeModel {
  const factory EmployeeModel({
    required int id,
    required String firstName,
    String? lastName,
    String? middleName,
    String? position,
    DepartmentModel? department,
    String? organisation,
    required bool isArchive,
    required int vacationDaysLeft,
    required bool isVaccinated,
    String? status,
    required String photo,
    required String title,
  }) = _EmployeeModel;

  factory EmployeeModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeModelFromJson(json);
}

extension EmployeeModelX on EmployeeModel {
  Employee toDomain() => Employee(
    id: id,
    firstName: firstName,
    lastName: lastName,
    middleName: middleName,
    position: position,
    department: department?.toDomain(),
    organisation: organisation,
    isArchive: isArchive,
    vacationDaysLeft: vacationDaysLeft,
    isVaccinated: isVaccinated,
    status: status,
    photo: photo,
    title: title,
  );
}
