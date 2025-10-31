import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/entities.dart';
import 'department_model.dart';

part 'author_model.freezed.dart';
part 'author_model.g.dart';

@freezed
abstract class AuthorModel with _$AuthorModel {
  const factory AuthorModel({
    required String firstName,
    required String lastName,
    required String middleName,
    DepartmentModel? department,
    required String organisation,
    required bool isArchive,
    required int vacationDaysLeft,
    required bool isVaccinated,
    String? photo,
    required int id,
    required String title,
    String? position,
    String? status,
  }) = _AuthorModel;

  factory AuthorModel.fromJson(Map<String, dynamic> json) => _$AuthorModelFromJson(json);
}

extension AuthorModelX on AuthorModel {
  Author toDomain() => Author(
    firstName: firstName,
    lastName: lastName,
    middleName: middleName,
    department: department?.toDomain(),
    organisation: organisation,
    isArchive: isArchive,
    vacationDaysLeft: vacationDaysLeft,
    isVaccinated: isVaccinated,
    photo: photo,
    id: id,
    title: title,
    position: position,
    status: status,
  );
}
